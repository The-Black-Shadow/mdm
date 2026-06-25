// >>> DownloadEngine =======================
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/features/downloader/domain/entities/download_task.dart';
import 'package:mdm/shared/enums/download_status.dart';

@singleton
class DownloadEngine {
  final Dio _dio = Dio();
  final Map<String, CancelToken> _cancelTokens = {};
  final StreamController<DownloadTask> _progressController =
      StreamController<DownloadTask>.broadcast();

  Stream<DownloadTask> get progressStream => _progressController.stream;

  // Track the last time we emitted progress for each task to avoid UI lockups
  final Map<String, DateTime> _lastEmitTime = {};

  Future<void> start(DownloadTask task) async {
    try {
      final cancelToken = CancelToken();
      _cancelTokens[task.id] = cancelToken;

      AppLogger.i('Starting download for task: ${task.id}');

      final downloadTask = task.copyWith(status: DownloadStatus.downloading);
      _progressController.add(downloadTask);

      final stopwatch = Stopwatch()..start();
      int previousReceived = 0;
      int speedCalcTime = 0;
      int speedBytesPerSecond = 0;

      await _dio.download(
        task.videoUrl,
        task.outputPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final now = DateTime.now();
            final lastTime =
                _lastEmitTime[task.id] ?? DateTime.fromMillisecondsSinceEpoch(0);

            // Calculate speed per second
            final int elapsedSinceCalc =
                stopwatch.elapsedMilliseconds - speedCalcTime;
            if (elapsedSinceCalc >= 1000) {
              speedBytesPerSecond =
                  ((received - previousReceived) / (elapsedSinceCalc / 1000))
                      .round();
              previousReceived = received;
              speedCalcTime = stopwatch.elapsedMilliseconds;
            }

            // Throttle to at most 4 emissions per second (every 250ms)
            if (now.difference(lastTime).inMilliseconds >= 250 ||
                received == total) {
              _lastEmitTime[task.id] = now;

              final progress = received / total;
              final remainingBytes = total - received;
              final etaSeconds = speedBytesPerSecond > 0
                  ? remainingBytes / speedBytesPerSecond
                  : 0;
              final eta = Duration(seconds: etaSeconds.round());

              final isCompleted = received == total;
              final updatedTask = task.copyWith(
                status: isCompleted
                    ? DownloadStatus.completed
                    : DownloadStatus.downloading,
                progress: progress,
                speedBytesPerSecond: speedBytesPerSecond,
                remainingBytes: remainingBytes,
                eta: eta,
                completedAt: isCompleted ? now : null,
              );

              _progressController.add(updatedTask);

              if (isCompleted) {
                _cancelTokens.remove(task.id);
                _lastEmitTime.remove(task.id);
                AppLogger.i('Completed download for task: ${task.id}');
              }
            }
          }
        },
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        AppLogger.i('Download paused/canceled for task: ${task.id}');
      } else {
        AppLogger.e('Download failed for task: ${task.id}', e);
        _progressController.add(
          task.copyWith(
            status: DownloadStatus.failed,
            errorMessage: e.message,
          ),
        );
      }
      _cancelTokens.remove(task.id);
      _lastEmitTime.remove(task.id);
    } catch (e, stackTrace) {
      AppLogger.e(
        'Unexpected error downloading task: ${task.id}',
        e,
        stackTrace,
      );
      _progressController.add(
        task.copyWith(
          status: DownloadStatus.failed,
          errorMessage: e.toString(),
        ),
      );
      _cancelTokens.remove(task.id);
      _lastEmitTime.remove(task.id);
    }
  }

  Future<void> pause(String taskId) async {
    AppLogger.i('Pausing download for task: $taskId');
    _cancelTokens[taskId]?.cancel('Paused by user');
    _cancelTokens.remove(taskId);
    _lastEmitTime.remove(taskId);
  }

  Future<void> cancel(String taskId) async {
    AppLogger.i('Canceling download for task: $taskId');
    _cancelTokens[taskId]?.cancel('Canceled by user');
    _cancelTokens.remove(taskId);
    _lastEmitTime.remove(taskId);
  }
}
// <<< DownloadEngine =======================
