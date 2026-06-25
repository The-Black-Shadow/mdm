// >>> StreamInfo =======================
// Domain entity representing a single media stream (video, audio, or muxed)

import 'package:mdm/shared/enums/media_type.dart';

class StreamInfo {
  final String itag;
  final MediaType type;
  final String? resolution;
  final int? fps;
  final String codec;
  final String container;
  final int? bitrate;
  final int? estimatedSizeBytes;
  final bool requiresMerge;

  const StreamInfo({
    required this.itag,
    required this.type,
    this.resolution,
    this.fps,
    required this.codec,
    required this.container,
    this.bitrate,
    this.estimatedSizeBytes,
    required this.requiresMerge,
  });
}
// <<< StreamInfo =======================
