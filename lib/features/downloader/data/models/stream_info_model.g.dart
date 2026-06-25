// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StreamInfoModel _$StreamInfoModelFromJson(Map<String, dynamic> json) =>
    _StreamInfoModel(
      itag: json['itag'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
      resolution: json['resolution'] as String?,
      fps: (json['fps'] as num?)?.toInt(),
      codec: json['codec'] as String,
      container: json['container'] as String,
      bitrate: (json['bitrate'] as num?)?.toInt(),
      estimatedSizeBytes: (json['estimatedSizeBytes'] as num?)?.toInt(),
      requiresMerge: json['requiresMerge'] as bool,
    );

Map<String, dynamic> _$StreamInfoModelToJson(_StreamInfoModel instance) =>
    <String, dynamic>{
      'itag': instance.itag,
      'url': instance.url,
      'type': instance.type,
      'resolution': instance.resolution,
      'fps': instance.fps,
      'codec': instance.codec,
      'container': instance.container,
      'bitrate': instance.bitrate,
      'estimatedSizeBytes': instance.estimatedSizeBytes,
      'requiresMerge': instance.requiresMerge,
    };
