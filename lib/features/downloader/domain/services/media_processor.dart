// >>> MediaProcessor =======================
import 'package:mdm/core/utils/result.dart';
import 'package:mdm/features/downloader/domain/entities/video_metadata.dart';

abstract class MediaProcessor {
  /// Merges a video stream file and an audio stream file into a single output file.
  /// Reports progress via the [onProgress] callback (0.0 to 1.0).
  Future<Result<void>> mergeVideoAndAudio({
    required String videoFilePath,
    required String audioFilePath,
    required String outputFilePath,
    void Function(double progress)? onProgress,
  });

  /// Converts a video file (e.g. webm) to an mp4 file.
  Future<Result<void>> convertToMp4({
    required String inputFilePath,
    required String outputFilePath,
    void Function(double progress)? onProgress,
  });

  /// Extracts audio from a video file and saves it as mp3.
  Future<Result<void>> extractAudio({
    required String inputFilePath,
    required String outputFilePath,
    void Function(double progress)? onProgress,
  });

  /// Embeds metadata and thumbnail into the media file.
  Future<Result<void>> embedMetadata({
    required String filePath,
    required VideoMetadata metadata,
    required String thumbnailFilePath,
  });
}
// <<< MediaProcessor =======================
