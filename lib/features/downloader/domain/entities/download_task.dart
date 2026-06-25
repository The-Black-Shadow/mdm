// >>> DownloadTask =======================
// Domain entity representing a single download task with progress tracking

import 'package:mdm/features/downloader/domain/entities/stream_info.dart';
import 'package:mdm/shared/enums/download_status.dart';

class DownloadTask {
  final String id;
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String? audioUrl;
  final String outputPath;
  final DownloadStatus status;
  final double progress;
  final int? speedBytesPerSecond;
  final int? remainingBytes;
  final Duration? eta;
  final String? errorMessage;
  final StreamInfo selectedStream;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool extractAudio;
  final String channelName;

  const DownloadTask({
    required this.id,
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.channelName,
    required this.videoUrl,
    this.audioUrl,
    required this.outputPath,
    required this.status,
    required this.progress,
    this.speedBytesPerSecond,
    this.remainingBytes,
    this.eta,
    this.errorMessage,
    required this.selectedStream,
    required this.createdAt,
    this.completedAt,
    this.extractAudio = false,
  });

  DownloadTask copyWith({
    String? id,
    String? videoId,
    String? title,
    String? thumbnailUrl,
    String? channelName,
    String? videoUrl,
    String? audioUrl,
    String? outputPath,
    DownloadStatus? status,
    double? progress,
    int? speedBytesPerSecond,
    int? remainingBytes,
    Duration? eta,
    String? errorMessage,
    StreamInfo? selectedStream,
    DateTime? createdAt,
    DateTime? completedAt,
    bool? extractAudio,
  }) =>
      DownloadTask(
        id: id ?? this.id,
        videoId: videoId ?? this.videoId,
        title: title ?? this.title,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        channelName: channelName ?? this.channelName,
        videoUrl: videoUrl ?? this.videoUrl,
        audioUrl: audioUrl ?? this.audioUrl,
        outputPath: outputPath ?? this.outputPath,
        status: status ?? this.status,
        progress: progress ?? this.progress,
        speedBytesPerSecond: speedBytesPerSecond ?? this.speedBytesPerSecond,
        remainingBytes: remainingBytes ?? this.remainingBytes,
        eta: eta ?? this.eta,
        errorMessage: errorMessage ?? this.errorMessage,
        selectedStream: selectedStream ?? this.selectedStream,
        createdAt: createdAt ?? this.createdAt,
        completedAt: completedAt ?? this.completedAt,
        extractAudio: extractAudio ?? this.extractAudio,
      );
}
// <<< DownloadTask =======================
