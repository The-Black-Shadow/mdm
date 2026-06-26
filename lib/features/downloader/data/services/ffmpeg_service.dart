// >>> FfmpegService =======================
import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:injectable/injectable.dart';
import 'package:mdm/core/utils/app_exception.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/core/utils/result.dart';
import 'package:mdm/features/downloader/domain/entities/video_metadata.dart';
import 'package:mdm/features/downloader/domain/services/media_processor.dart';

@LazySingleton(as: MediaProcessor)
class FfmpegService implements MediaProcessor {
  @override
  Future<Result<void>> mergeVideoAndAudio({
    required String videoFilePath,
    required String audioFilePath,
    required String outputFilePath,
    void Function(double progress)? onProgress,
  }) async {
    return _executeFfmpeg(
      command: '-y -i "$videoFilePath" -i "$audioFilePath" -c:v copy -c:a aac -strict experimental "$outputFilePath"',
      mainInputPath: videoFilePath,
      onProgress: onProgress,
      operationName: 'Merge Video & Audio',
    );
  }



  @override
  Future<Result<void>> convertToMp4({
    required String inputFilePath,
    required String outputFilePath,
    void Function(double progress)? onProgress,
  }) async {
    // Basic re-encode or copy if possible. For safety, re-encode video (vp9->h264)
    // but this might take long. A simpler command:
    final command = '-y -i "$inputFilePath" -c:v libx264 -preset fast -c:a aac "$outputFilePath"';
    return _executeFfmpeg(
      command: command,
      mainInputPath: inputFilePath,
      onProgress: onProgress,
      operationName: 'Convert to MP4',
    );
  }

  @override
  Future<Result<void>> extractAudio({
    required String inputFilePath,
    required String outputFilePath,
    void Function(double progress)? onProgress,
  }) async {
    // Extract audio and save as mp3
    final command = '-y -i "$inputFilePath" -vn -c:a libmp3lame -q:a 2 "$outputFilePath"';
    return _executeFfmpeg(
      command: command,
      mainInputPath: inputFilePath,
      onProgress: onProgress,
      operationName: 'Extract Audio',
    );
  }

  @override
  Future<Result<void>> embedMetadata({
    required String filePath,
    required VideoMetadata metadata,
    required String thumbnailFilePath,
  }) async {
    // Note: Embedding metadata might be complex for mp4 directly using simple copy if we want to add thumbnail.
    // For now, let's do a fast tagging.
    final tempOutput = '$filePath.meta.mp4';
    
    // Command to add metadata and thumbnail
    final command = '-y -i "$filePath" -i "$thumbnailFilePath" '
        '-map 0 -map 1 -c copy -disposition:v:1 attached_pic '
        '-metadata title="${_escapeMetadata(metadata.title)}" '
        '-metadata artist="${_escapeMetadata(metadata.channelName)}" '
        '-metadata date="${metadata.uploadDate?.year ?? ''}" '
        '"$tempOutput"';

    final result = await _executeFfmpeg(
      command: command,
      mainInputPath: filePath,
      operationName: 'Embed Metadata',
    );

    if (result is Success) {
      try {
        final originalFile = File(filePath);
        final newFile = File(tempOutput);
        if (await newFile.exists()) {
          await originalFile.delete();
          await newFile.rename(filePath);
        }
      } catch (e, stackTrace) {
        AppLogger.e('Failed to replace original file after metadata embed', e, stackTrace);
      }
    }

    return result;
  }

  String _escapeMetadata(String text) {
    return text.replaceAll('"', '\\"');
  }

  Future<Result<void>> _executeFfmpeg({
    required String command,
    required String mainInputPath,
    void Function(double progress)? onProgress,
    required String operationName,
  }) async {
    try {
      int? totalDurationMs;

      // Try to get duration for progress tracking
      if (onProgress != null) {
        final session = await FFprobeKit.getMediaInformation(mainInputPath);
        final info = session.getMediaInformation();
        if (info != null) {
          final duration = info.getDuration();
          if (duration != null) {
            totalDurationMs = (double.parse(duration) * 1000).toInt();
          }
        }
      }

      AppLogger.i('Starting FFmpeg operation: $operationName\nCommand: $command');

      final completer = Completer<void>();

      final session = await FFmpegKit.executeAsync(
        command,
        (session) async {
          // Session completed — resolve the completer
          completer.complete();
        },
        (log) {
          // You could log this if debugging FFmpeg issues
          // AppLogger.v(log.getMessage());
        },
        (statistics) {
          if (onProgress != null && totalDurationMs != null && totalDurationMs > 0) {
            final timeMs = statistics.getTime();
            final progress = (timeMs / totalDurationMs).clamp(0.0, 1.0);
            onProgress(progress);
          }
        },
      );

      // Wait for FFmpeg to actually finish
      await completer.future;

      final returnCode = await session.getReturnCode();
      final failStackTrace = await session.getFailStackTrace();

      if (ReturnCode.isSuccess(returnCode)) {
        AppLogger.i('FFmpeg operation completed successfully: $operationName');
        return Result.success(null);
      } else if (ReturnCode.isCancel(returnCode)) {
        AppLogger.w('FFmpeg operation cancelled: $operationName');
        return Result.failure(AppException.unknown('FFmpeg operation cancelled: $operationName'));
      } else {
        AppLogger.e(
          'FFmpeg operation failed: $operationName',
          'ReturnCode: $returnCode, StackTrace: $failStackTrace',
        );
        // Clean up output files would happen at a higher level or here if we knew them explicitly
        return Result.failure(AppException.mergeFailure());
      }
    } catch (e, stackTrace) {
      AppLogger.e('Exception during FFmpeg operation: $operationName', e, stackTrace);
      return Result.failure(AppException.mergeFailure());
    }
  }
}
// <<< FfmpegService =======================
