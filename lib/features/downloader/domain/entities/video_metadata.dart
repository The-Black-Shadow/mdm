// >>> VideoMetadata =======================
// Domain entity representing full metadata for a YouTube video

import 'package:mdm/features/downloader/domain/entities/stream_info.dart';

class VideoMetadata {
  final String videoId;
  final String url;
  final String title;
  final String channelName;
  final String? channelAvatarUrl;
  final String thumbnailUrl;
  final Duration duration;
  final int? viewCount;
  final DateTime? uploadDate;
  final String? description;
  final List<StreamInfo> videoStreams;
  final List<StreamInfo> audioStreams;

  const VideoMetadata({
    required this.videoId,
    required this.url,
    required this.title,
    required this.channelName,
    this.channelAvatarUrl,
    required this.thumbnailUrl,
    required this.duration,
    this.viewCount,
    this.uploadDate,
    this.description,
    required this.videoStreams,
    required this.audioStreams,
  });
}
// <<< VideoMetadata =======================
