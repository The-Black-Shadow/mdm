// >>> VideoInfo =======================
// Immutable model representing video metadata
class VideoInfo {
  final String videoId;
  final String title;
  final String channelName;
  final String thumbnailUrl;
  final Duration duration;

  const VideoInfo({
    required this.videoId,
    required this.title,
    required this.channelName,
    required this.thumbnailUrl,
    required this.duration,
  });
}
// <<< VideoInfo =======================
