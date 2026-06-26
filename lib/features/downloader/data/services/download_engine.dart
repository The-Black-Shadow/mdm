import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:mdm/core/helpers/file_helper.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/features/downloader/data/services/chunked_downloader.dart';

import 'package:mdm/features/downloader/domain/entities/download_task.dart';
import 'package:mdm/shared/enums/download_status.dart';
import 'package:mdm/features/downloader/domain/services/media_processor.dart';

import 'package:mdm/core/services/notification_service.dart';

@singleton
class DownloadEngine {
  final ChunkedDownloader _chunkedDownloader = ChunkedDownloader();
  final MediaProcessor _mediaProcessor;
  final NotificationService _notificationService;
  final Map<String, CancelToken> _cancelTokens = {};
  final StreamController<DownloadTask> _progressController =
      StreamController<DownloadTask>.broadcast();

  Stream<DownloadTask> get progressStream => _progressController.stream;

  final Map<String, DateTime> _lastEmitTime = {};

  DownloadEngine(this._mediaProcessor, this._notificationService);

  Future<void> start(DownloadTask originalTask) async {
    final yt = YoutubeExplode();
    try {
      final cancelToken = CancelToken();
      _cancelTokens[originalTask.id] = cancelToken;

      AppLogger.i('Starting download for task: ${originalTask.id}');

      // Resolve full output path if only a filename was provided
      var resolvedOutputPath = originalTask.outputPath;
      if (!resolvedOutputPath.startsWith('/')) {
        final downloadDir = await FileHelper.getDownloadDirectory();
        resolvedOutputPath = '${downloadDir.path}/$resolvedOutputPath';
      }
      final task = originalTask.copyWith(outputPath: resolvedOutputPath);

      final downloadTask = task.copyWith(status: DownloadStatus.downloading);
      _progressController.add(downloadTask);

      // Resolve fresh stream URLs to avoid 403 (expiration / IP mismatch)
      AppLogger.d('Refreshing stream URLs for video: ${task.videoId}');
      final manifest = await yt.videos.streamsClient.getManifest(
        task.videoId,
        ytClients: [YoutubeApiClient.androidVr],
      );

      final videoStream = manifest.streams.firstWhere(
        (s) => s.tag.toString() == task.selectedStream.itag,
        orElse: () => throw Exception(
          'Selected stream with itag ${task.selectedStream.itag} not found',
        ),
      );
      final resolvedVideoUrl = videoStream.url.toString();

      String? resolvedAudioUrl;
      if (task.audioUrl != null && manifest.audioOnly.isNotEmpty) {
        final audioStream = manifest.audioOnly.withHighestBitrate();
        resolvedAudioUrl = audioStream.url.toString();
      }

      if (task.extractAudio) {
        // High-quality audio extraction
        final targetUrl = resolvedAudioUrl ?? resolvedVideoUrl;
        final tempPath = '${task.outputPath}.tmp';

        await _downloadPart(
          url: targetUrl,
          outputPath: tempPath,
          cancelToken: cancelToken,
          task: task,
          baseProgress: 0.0,
          progressWeight: 0.75,
        );

        _progressController.add(task.copyWith(status: DownloadStatus.merging));
        final extractResult = await _mediaProcessor.extractAudio(
          inputFilePath: tempPath,
          outputFilePath: task.outputPath,
          onProgress: (ffmpegProgress) {
            _emitProgress(task, 0.75 + (ffmpegProgress * 0.25), 0, 0, false);
          },
        );

        try {
          final tmpFile = File(tempPath);
          if (await tmpFile.exists()) await tmpFile.delete();
        } catch (e) {
          AppLogger.w('Failed to clean up temp files for task ${task.id}');
        }

        if (extractResult.isFailure) {
          throw extractResult.exceptionOrNull!;
        }

        _emitProgress(task, 1.0, 0, 0, true);
      } else if (task.selectedStream.requiresMerge &&
          resolvedAudioUrl != null) {
        // High-quality flow: video -> audio -> merge
        final videoTempPath = '${task.outputPath}.vid.tmp';
        final audioTempPath = '${task.outputPath}.aud.tmp';

        // 1. Download Video (0% - 50%)
        await _downloadPart(
          url: resolvedVideoUrl,
          outputPath: videoTempPath,
          cancelToken: cancelToken,
          task: task,
          baseProgress: 0.0,
          progressWeight: 0.5,
        );

        // 2. Download Audio (50% - 75%)
        await _downloadPart(
          url: resolvedAudioUrl,
          outputPath: audioTempPath,
          cancelToken: cancelToken,
          task: task,
          baseProgress: 0.5,
          progressWeight: 0.25,
        );

        // 3. Merge (75% - 100%)
        _progressController.add(task.copyWith(status: DownloadStatus.merging));

        final mergeResult = await _mediaProcessor.mergeVideoAndAudio(
          videoFilePath: videoTempPath,
          audioFilePath: audioTempPath,
          outputFilePath: task.outputPath,
          onProgress: (ffmpegProgress) {
            final overallProgress = 0.75 + (ffmpegProgress * 0.25);
            _emitProgress(task, overallProgress, 0, 0, false);
          },
        );

        // Clean up temps
        try {
          final vidFile = File(videoTempPath);
          final audFile = File(audioTempPath);
          if (await vidFile.exists()) await vidFile.delete();
          if (await audFile.exists()) await audFile.delete();
        } catch (e) {
          AppLogger.w('Failed to clean up temp files for task ${task.id}');
        }

        if (mergeResult.isFailure) {
          throw mergeResult.exceptionOrNull!;
        }

        _emitProgress(task, 1.0, 0, 0, true);
      } else if (task.outputPath.endsWith('.mp4') &&
          task.selectedStream.container == 'webm') {
        // WebM to MP4 conversion
        final tempPath = '${task.outputPath}.tmp';
        await _downloadPart(
          url: resolvedVideoUrl,
          outputPath: tempPath,
          cancelToken: cancelToken,
          task: task,
          baseProgress: 0.0,
          progressWeight: 0.75,
        );

        _progressController.add(task.copyWith(status: DownloadStatus.merging));
        final convertResult = await _mediaProcessor.convertToMp4(
          inputFilePath: tempPath,
          outputFilePath: task.outputPath,
          onProgress: (ffmpegProgress) {
            _emitProgress(task, 0.75 + (ffmpegProgress * 0.25), 0, 0, false);
          },
        );

        try {
          final tmpFile = File(tempPath);
          if (await tmpFile.exists()) await tmpFile.delete();
        } catch (e) {
          AppLogger.w('Failed to clean up temp files for task ${task.id}');
        }

        if (convertResult.isFailure) {
          throw convertResult.exceptionOrNull!;
        }

        _emitProgress(task, 1.0, 0, 0, true);
      } else {
        // Normal flow (0% - 100%)
        await _downloadPart(
          url: resolvedVideoUrl,
          outputPath: task.outputPath,
          cancelToken: cancelToken,
          task: task,
          baseProgress: 0.0,
          progressWeight: 1.0,
        );
        _emitProgress(task, 1.0, 0, 0, true);
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        AppLogger.i('Download paused/canceled for task: ${originalTask.id}');
        _notificationService.cancelNotification(originalTask.id.hashCode);
      } else {
        AppLogger.e('Download failed for task: ${originalTask.id}', e);
        _progressController.add(
          originalTask.copyWith(status: DownloadStatus.failed, errorMessage: e.message),
        );
        _notificationService.showDownloadFailed(
          id: originalTask.id.hashCode,
          title: originalTask.title,
          error: e.message,
        );
      }
      _cancelTokens.remove(originalTask.id);
      _lastEmitTime.remove(originalTask.id);
      if (_cancelTokens.isEmpty)
        _notificationService.stopForegroundService(originalTask.id.hashCode);
    } catch (e, stackTrace) {
      AppLogger.e(
        'Unexpected error downloading task: ${originalTask.id}',
        e,
        stackTrace,
      );
      _progressController.add(
        originalTask.copyWith(
          status: DownloadStatus.failed,
          errorMessage: e.toString(),
        ),
      );
      _notificationService.showDownloadFailed(
        id: originalTask.id.hashCode,
        title: originalTask.title,
        error: e.toString(),
      );
      _cancelTokens.remove(originalTask.id);
      _lastEmitTime.remove(originalTask.id);
      if (_cancelTokens.isEmpty)
        _notificationService.stopForegroundService(originalTask.id.hashCode);
    } finally {
      yt.close();
    }
  }

  Future<void> _downloadPart({
    required String url,
    required String outputPath,
    required CancelToken cancelToken,
    required DownloadTask task,
    required double baseProgress,
    required double progressWeight,
  }) async {
    await _chunkedDownloader.download(
      url: url,
      outputPath: outputPath,
      cancelToken: cancelToken,
      onProgress: (received, total, speedBps) {
        if (total > 0) {
          final now = DateTime.now();
          final lastTime =
              _lastEmitTime[task.id] ?? DateTime.fromMillisecondsSinceEpoch(0);

          if (now.difference(lastTime).inMilliseconds >= 250 ||
              received == total) {
            _lastEmitTime[task.id] = now;
            final partProgress = received / total;
            final overallProgress =
                baseProgress + (partProgress * progressWeight);
            final remainingBytes = total - received;

            _emitProgress(
              task,
              overallProgress,
              speedBps,
              remainingBytes,
              false,
            );
          }
        }
      },
    );
  }

  void _emitProgress(
    DownloadTask task,
    double overallProgress,
    int speedBytesPerSecond,
    int remainingBytes,
    bool isCompleted,
  ) {
    final etaSeconds = speedBytesPerSecond > 0
        ? remainingBytes / speedBytesPerSecond
        : 0;
    final eta = Duration(seconds: etaSeconds.round());

    final updatedTask = task.copyWith(
      status: isCompleted
          ? DownloadStatus.completed
          : DownloadStatus.downloading,
      progress: overallProgress,
      speedBytesPerSecond: speedBytesPerSecond,
      remainingBytes: remainingBytes,
      eta: eta,
      completedAt: isCompleted ? DateTime.now() : null,
    );

    _progressController.add(updatedTask);

    final notifId = task.id.hashCode;

    if (isCompleted) {
      _cancelTokens.remove(task.id);
      _lastEmitTime.remove(task.id);
      AppLogger.i('Completed download for task: ${task.id}');

      if (_cancelTokens.isEmpty) {
        _notificationService.stopForegroundService(notifId);
      } else {
        _notificationService.cancelNotification(notifId);
      }

      _notificationService.showDownloadComplete(id: notifId, title: task.title);
    } else {
      _notificationService.showDownloadProgress(
        id: notifId,
        title: task.title,
        progress: (overallProgress * 100).toInt(),
        maxProgress: 100,
      );
    }
  }

  Future<void> pause(String taskId) async {
    AppLogger.i('Pausing download for task: $taskId');
    _cancelTokens[taskId]?.cancel('Paused by user');
    _cancelTokens.remove(taskId);
    _lastEmitTime.remove(taskId);
    _notificationService.cancelNotification(taskId.hashCode);
    if (_cancelTokens.isEmpty)
      _notificationService.stopForegroundService(taskId.hashCode);
  }

  Future<void> cancel(String taskId) async {
    AppLogger.i('Canceling download for task: $taskId');
    _cancelTokens[taskId]?.cancel('Canceled by user');
    _cancelTokens.remove(taskId);
    _lastEmitTime.remove(taskId);
    _notificationService.cancelNotification(taskId.hashCode);
    if (_cancelTokens.isEmpty)
      _notificationService.stopForegroundService(taskId.hashCode);
  }
}

// <<< DownloadEngine =======================
