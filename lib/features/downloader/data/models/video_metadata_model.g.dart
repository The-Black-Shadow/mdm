// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoMetadataModel _$VideoMetadataModelFromJson(Map<String, dynamic> json) =>
    _VideoMetadataModel(
      videoId: json['videoId'] as String,
      url: json['url'] as String,
      title: json['title'] as String,
      channelName: json['channelName'] as String,
      channelAvatarUrl: json['channelAvatarUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String,
      durationMs: (json['durationMs'] as num).toInt(),
      viewCount: (json['viewCount'] as num?)?.toInt(),
      uploadDate: json['uploadDate'] == null
          ? null
          : DateTime.parse(json['uploadDate'] as String),
      description: json['description'] as String?,
      videoStreams: (json['videoStreams'] as List<dynamic>)
          .map((e) => StreamInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      audioStreams: (json['audioStreams'] as List<dynamic>)
          .map((e) => StreamInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VideoMetadataModelToJson(_VideoMetadataModel instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'url': instance.url,
      'title': instance.title,
      'channelName': instance.channelName,
      'channelAvatarUrl': instance.channelAvatarUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'durationMs': instance.durationMs,
      'viewCount': instance.viewCount,
      'uploadDate': instance.uploadDate?.toIso8601String(),
      'description': instance.description,
      'videoStreams': instance.videoStreams,
      'audioStreams': instance.audioStreams,
    };
