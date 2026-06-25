// >>> VideoMetadataModel =======================
// Freezed data model for video metadata with JSON serialization and domain mapping

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mdm/features/downloader/data/models/stream_info_model.dart';
import 'package:mdm/features/downloader/domain/entities/video_metadata.dart';

part 'video_metadata_model.freezed.dart';
part 'video_metadata_model.g.dart';

@freezed
abstract class VideoMetadataModel with _$VideoMetadataModel {
  const VideoMetadataModel._();

  const factory VideoMetadataModel({
    required String videoId,
    required String url,
    required String title,
    required String channelName,
    String? channelAvatarUrl,
    required String thumbnailUrl,
    required int durationMs,
    int? viewCount,
    DateTime? uploadDate,
    String? description,
    required List<StreamInfoModel> videoStreams,
    required List<StreamInfoModel> audioStreams,
  }) = _VideoMetadataModel;

  factory VideoMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$VideoMetadataModelFromJson(json);

  VideoMetadata toDomain() => VideoMetadata(
        videoId: videoId,
        url: url,
        title: title,
        channelName: channelName,
        channelAvatarUrl: channelAvatarUrl,
        thumbnailUrl: thumbnailUrl,
        duration: Duration(milliseconds: durationMs),
        viewCount: viewCount,
        uploadDate: uploadDate,
        description: description,
        videoStreams: videoStreams.map((s) => s.toDomain()).toList(),
        audioStreams: audioStreams.map((s) => s.toDomain()).toList(),
      );
}
// <<< VideoMetadataModel =======================
