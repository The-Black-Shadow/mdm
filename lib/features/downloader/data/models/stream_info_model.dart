// >>> StreamInfoModel =======================
// Freezed data model for stream info with JSON serialization and domain mapping

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mdm/features/downloader/domain/entities/stream_info.dart';
import 'package:mdm/shared/enums/media_type.dart';

part 'stream_info_model.freezed.dart';
part 'stream_info_model.g.dart';

@freezed
abstract class StreamInfoModel with _$StreamInfoModel {
  const StreamInfoModel._();

  const factory StreamInfoModel({
    required String itag,
    required String type,
    String? resolution,
    int? fps,
    required String codec,
    required String container,
    int? bitrate,
    int? estimatedSizeBytes,
    required bool requiresMerge,
  }) = _StreamInfoModel;

  factory StreamInfoModel.fromJson(Map<String, dynamic> json) =>
      _$StreamInfoModelFromJson(json);

  StreamInfo toDomain() => StreamInfo(
        itag: itag,
        type: MediaType.values.firstWhere((e) => e.name == type),
        resolution: resolution,
        fps: fps,
        codec: codec,
        container: container,
        bitrate: bitrate,
        estimatedSizeBytes: estimatedSizeBytes,
        requiresMerge: requiresMerge,
      );
}
// <<< StreamInfoModel =======================
