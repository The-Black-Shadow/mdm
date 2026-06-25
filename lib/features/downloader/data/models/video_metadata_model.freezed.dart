// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_metadata_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoMetadataModel {

 String get videoId; String get url; String get title; String get channelName; String? get channelAvatarUrl; String get thumbnailUrl; int get durationMs; int? get viewCount; DateTime? get uploadDate; String? get description; List<StreamInfoModel> get videoStreams; List<StreamInfoModel> get audioStreams;
/// Create a copy of VideoMetadataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoMetadataModelCopyWith<VideoMetadataModel> get copyWith => _$VideoMetadataModelCopyWithImpl<VideoMetadataModel>(this as VideoMetadataModel, _$identity);

  /// Serializes this VideoMetadataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoMetadataModel&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title)&&(identical(other.channelName, channelName) || other.channelName == channelName)&&(identical(other.channelAvatarUrl, channelAvatarUrl) || other.channelAvatarUrl == channelAvatarUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.uploadDate, uploadDate) || other.uploadDate == uploadDate)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.videoStreams, videoStreams)&&const DeepCollectionEquality().equals(other.audioStreams, audioStreams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,videoId,url,title,channelName,channelAvatarUrl,thumbnailUrl,durationMs,viewCount,uploadDate,description,const DeepCollectionEquality().hash(videoStreams),const DeepCollectionEquality().hash(audioStreams));

@override
String toString() {
  return 'VideoMetadataModel(videoId: $videoId, url: $url, title: $title, channelName: $channelName, channelAvatarUrl: $channelAvatarUrl, thumbnailUrl: $thumbnailUrl, durationMs: $durationMs, viewCount: $viewCount, uploadDate: $uploadDate, description: $description, videoStreams: $videoStreams, audioStreams: $audioStreams)';
}


}

/// @nodoc
abstract mixin class $VideoMetadataModelCopyWith<$Res>  {
  factory $VideoMetadataModelCopyWith(VideoMetadataModel value, $Res Function(VideoMetadataModel) _then) = _$VideoMetadataModelCopyWithImpl;
@useResult
$Res call({
 String videoId, String url, String title, String channelName, String? channelAvatarUrl, String thumbnailUrl, int durationMs, int? viewCount, DateTime? uploadDate, String? description, List<StreamInfoModel> videoStreams, List<StreamInfoModel> audioStreams
});




}
/// @nodoc
class _$VideoMetadataModelCopyWithImpl<$Res>
    implements $VideoMetadataModelCopyWith<$Res> {
  _$VideoMetadataModelCopyWithImpl(this._self, this._then);

  final VideoMetadataModel _self;
  final $Res Function(VideoMetadataModel) _then;

/// Create a copy of VideoMetadataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? videoId = null,Object? url = null,Object? title = null,Object? channelName = null,Object? channelAvatarUrl = freezed,Object? thumbnailUrl = null,Object? durationMs = null,Object? viewCount = freezed,Object? uploadDate = freezed,Object? description = freezed,Object? videoStreams = null,Object? audioStreams = null,}) {
  return _then(_self.copyWith(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,channelName: null == channelName ? _self.channelName : channelName // ignore: cast_nullable_to_non_nullable
as String,channelAvatarUrl: freezed == channelAvatarUrl ? _self.channelAvatarUrl : channelAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,viewCount: freezed == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int?,uploadDate: freezed == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as DateTime?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,videoStreams: null == videoStreams ? _self.videoStreams : videoStreams // ignore: cast_nullable_to_non_nullable
as List<StreamInfoModel>,audioStreams: null == audioStreams ? _self.audioStreams : audioStreams // ignore: cast_nullable_to_non_nullable
as List<StreamInfoModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoMetadataModel].
extension VideoMetadataModelPatterns on VideoMetadataModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoMetadataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoMetadataModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoMetadataModel value)  $default,){
final _that = this;
switch (_that) {
case _VideoMetadataModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoMetadataModel value)?  $default,){
final _that = this;
switch (_that) {
case _VideoMetadataModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String videoId,  String url,  String title,  String channelName,  String? channelAvatarUrl,  String thumbnailUrl,  int durationMs,  int? viewCount,  DateTime? uploadDate,  String? description,  List<StreamInfoModel> videoStreams,  List<StreamInfoModel> audioStreams)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoMetadataModel() when $default != null:
return $default(_that.videoId,_that.url,_that.title,_that.channelName,_that.channelAvatarUrl,_that.thumbnailUrl,_that.durationMs,_that.viewCount,_that.uploadDate,_that.description,_that.videoStreams,_that.audioStreams);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String videoId,  String url,  String title,  String channelName,  String? channelAvatarUrl,  String thumbnailUrl,  int durationMs,  int? viewCount,  DateTime? uploadDate,  String? description,  List<StreamInfoModel> videoStreams,  List<StreamInfoModel> audioStreams)  $default,) {final _that = this;
switch (_that) {
case _VideoMetadataModel():
return $default(_that.videoId,_that.url,_that.title,_that.channelName,_that.channelAvatarUrl,_that.thumbnailUrl,_that.durationMs,_that.viewCount,_that.uploadDate,_that.description,_that.videoStreams,_that.audioStreams);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String videoId,  String url,  String title,  String channelName,  String? channelAvatarUrl,  String thumbnailUrl,  int durationMs,  int? viewCount,  DateTime? uploadDate,  String? description,  List<StreamInfoModel> videoStreams,  List<StreamInfoModel> audioStreams)?  $default,) {final _that = this;
switch (_that) {
case _VideoMetadataModel() when $default != null:
return $default(_that.videoId,_that.url,_that.title,_that.channelName,_that.channelAvatarUrl,_that.thumbnailUrl,_that.durationMs,_that.viewCount,_that.uploadDate,_that.description,_that.videoStreams,_that.audioStreams);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoMetadataModel extends VideoMetadataModel {
  const _VideoMetadataModel({required this.videoId, required this.url, required this.title, required this.channelName, this.channelAvatarUrl, required this.thumbnailUrl, required this.durationMs, this.viewCount, this.uploadDate, this.description, required final  List<StreamInfoModel> videoStreams, required final  List<StreamInfoModel> audioStreams}): _videoStreams = videoStreams,_audioStreams = audioStreams,super._();
  factory _VideoMetadataModel.fromJson(Map<String, dynamic> json) => _$VideoMetadataModelFromJson(json);

@override final  String videoId;
@override final  String url;
@override final  String title;
@override final  String channelName;
@override final  String? channelAvatarUrl;
@override final  String thumbnailUrl;
@override final  int durationMs;
@override final  int? viewCount;
@override final  DateTime? uploadDate;
@override final  String? description;
 final  List<StreamInfoModel> _videoStreams;
@override List<StreamInfoModel> get videoStreams {
  if (_videoStreams is EqualUnmodifiableListView) return _videoStreams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videoStreams);
}

 final  List<StreamInfoModel> _audioStreams;
@override List<StreamInfoModel> get audioStreams {
  if (_audioStreams is EqualUnmodifiableListView) return _audioStreams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_audioStreams);
}


/// Create a copy of VideoMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoMetadataModelCopyWith<_VideoMetadataModel> get copyWith => __$VideoMetadataModelCopyWithImpl<_VideoMetadataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoMetadataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoMetadataModel&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title)&&(identical(other.channelName, channelName) || other.channelName == channelName)&&(identical(other.channelAvatarUrl, channelAvatarUrl) || other.channelAvatarUrl == channelAvatarUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.uploadDate, uploadDate) || other.uploadDate == uploadDate)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._videoStreams, _videoStreams)&&const DeepCollectionEquality().equals(other._audioStreams, _audioStreams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,videoId,url,title,channelName,channelAvatarUrl,thumbnailUrl,durationMs,viewCount,uploadDate,description,const DeepCollectionEquality().hash(_videoStreams),const DeepCollectionEquality().hash(_audioStreams));

@override
String toString() {
  return 'VideoMetadataModel(videoId: $videoId, url: $url, title: $title, channelName: $channelName, channelAvatarUrl: $channelAvatarUrl, thumbnailUrl: $thumbnailUrl, durationMs: $durationMs, viewCount: $viewCount, uploadDate: $uploadDate, description: $description, videoStreams: $videoStreams, audioStreams: $audioStreams)';
}


}

/// @nodoc
abstract mixin class _$VideoMetadataModelCopyWith<$Res> implements $VideoMetadataModelCopyWith<$Res> {
  factory _$VideoMetadataModelCopyWith(_VideoMetadataModel value, $Res Function(_VideoMetadataModel) _then) = __$VideoMetadataModelCopyWithImpl;
@override @useResult
$Res call({
 String videoId, String url, String title, String channelName, String? channelAvatarUrl, String thumbnailUrl, int durationMs, int? viewCount, DateTime? uploadDate, String? description, List<StreamInfoModel> videoStreams, List<StreamInfoModel> audioStreams
});




}
/// @nodoc
class __$VideoMetadataModelCopyWithImpl<$Res>
    implements _$VideoMetadataModelCopyWith<$Res> {
  __$VideoMetadataModelCopyWithImpl(this._self, this._then);

  final _VideoMetadataModel _self;
  final $Res Function(_VideoMetadataModel) _then;

/// Create a copy of VideoMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? videoId = null,Object? url = null,Object? title = null,Object? channelName = null,Object? channelAvatarUrl = freezed,Object? thumbnailUrl = null,Object? durationMs = null,Object? viewCount = freezed,Object? uploadDate = freezed,Object? description = freezed,Object? videoStreams = null,Object? audioStreams = null,}) {
  return _then(_VideoMetadataModel(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,channelName: null == channelName ? _self.channelName : channelName // ignore: cast_nullable_to_non_nullable
as String,channelAvatarUrl: freezed == channelAvatarUrl ? _self.channelAvatarUrl : channelAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,viewCount: freezed == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int?,uploadDate: freezed == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as DateTime?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,videoStreams: null == videoStreams ? _self._videoStreams : videoStreams // ignore: cast_nullable_to_non_nullable
as List<StreamInfoModel>,audioStreams: null == audioStreams ? _self._audioStreams : audioStreams // ignore: cast_nullable_to_non_nullable
as List<StreamInfoModel>,
  ));
}


}

// dart format on
