// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stream_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StreamInfoModel {

 String get itag; String get type; String? get resolution; int? get fps; String get codec; String get container; int? get bitrate; int? get estimatedSizeBytes; bool get requiresMerge;
/// Create a copy of StreamInfoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreamInfoModelCopyWith<StreamInfoModel> get copyWith => _$StreamInfoModelCopyWithImpl<StreamInfoModel>(this as StreamInfoModel, _$identity);

  /// Serializes this StreamInfoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreamInfoModel&&(identical(other.itag, itag) || other.itag == itag)&&(identical(other.type, type) || other.type == type)&&(identical(other.resolution, resolution) || other.resolution == resolution)&&(identical(other.fps, fps) || other.fps == fps)&&(identical(other.codec, codec) || other.codec == codec)&&(identical(other.container, container) || other.container == container)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.estimatedSizeBytes, estimatedSizeBytes) || other.estimatedSizeBytes == estimatedSizeBytes)&&(identical(other.requiresMerge, requiresMerge) || other.requiresMerge == requiresMerge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itag,type,resolution,fps,codec,container,bitrate,estimatedSizeBytes,requiresMerge);

@override
String toString() {
  return 'StreamInfoModel(itag: $itag, type: $type, resolution: $resolution, fps: $fps, codec: $codec, container: $container, bitrate: $bitrate, estimatedSizeBytes: $estimatedSizeBytes, requiresMerge: $requiresMerge)';
}


}

/// @nodoc
abstract mixin class $StreamInfoModelCopyWith<$Res>  {
  factory $StreamInfoModelCopyWith(StreamInfoModel value, $Res Function(StreamInfoModel) _then) = _$StreamInfoModelCopyWithImpl;
@useResult
$Res call({
 String itag, String type, String? resolution, int? fps, String codec, String container, int? bitrate, int? estimatedSizeBytes, bool requiresMerge
});




}
/// @nodoc
class _$StreamInfoModelCopyWithImpl<$Res>
    implements $StreamInfoModelCopyWith<$Res> {
  _$StreamInfoModelCopyWithImpl(this._self, this._then);

  final StreamInfoModel _self;
  final $Res Function(StreamInfoModel) _then;

/// Create a copy of StreamInfoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itag = null,Object? type = null,Object? resolution = freezed,Object? fps = freezed,Object? codec = null,Object? container = null,Object? bitrate = freezed,Object? estimatedSizeBytes = freezed,Object? requiresMerge = null,}) {
  return _then(_self.copyWith(
itag: null == itag ? _self.itag : itag // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,fps: freezed == fps ? _self.fps : fps // ignore: cast_nullable_to_non_nullable
as int?,codec: null == codec ? _self.codec : codec // ignore: cast_nullable_to_non_nullable
as String,container: null == container ? _self.container : container // ignore: cast_nullable_to_non_nullable
as String,bitrate: freezed == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int?,estimatedSizeBytes: freezed == estimatedSizeBytes ? _self.estimatedSizeBytes : estimatedSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,requiresMerge: null == requiresMerge ? _self.requiresMerge : requiresMerge // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StreamInfoModel].
extension StreamInfoModelPatterns on StreamInfoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreamInfoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreamInfoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreamInfoModel value)  $default,){
final _that = this;
switch (_that) {
case _StreamInfoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreamInfoModel value)?  $default,){
final _that = this;
switch (_that) {
case _StreamInfoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itag,  String type,  String? resolution,  int? fps,  String codec,  String container,  int? bitrate,  int? estimatedSizeBytes,  bool requiresMerge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreamInfoModel() when $default != null:
return $default(_that.itag,_that.type,_that.resolution,_that.fps,_that.codec,_that.container,_that.bitrate,_that.estimatedSizeBytes,_that.requiresMerge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itag,  String type,  String? resolution,  int? fps,  String codec,  String container,  int? bitrate,  int? estimatedSizeBytes,  bool requiresMerge)  $default,) {final _that = this;
switch (_that) {
case _StreamInfoModel():
return $default(_that.itag,_that.type,_that.resolution,_that.fps,_that.codec,_that.container,_that.bitrate,_that.estimatedSizeBytes,_that.requiresMerge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itag,  String type,  String? resolution,  int? fps,  String codec,  String container,  int? bitrate,  int? estimatedSizeBytes,  bool requiresMerge)?  $default,) {final _that = this;
switch (_that) {
case _StreamInfoModel() when $default != null:
return $default(_that.itag,_that.type,_that.resolution,_that.fps,_that.codec,_that.container,_that.bitrate,_that.estimatedSizeBytes,_that.requiresMerge);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StreamInfoModel extends StreamInfoModel {
  const _StreamInfoModel({required this.itag, required this.type, this.resolution, this.fps, required this.codec, required this.container, this.bitrate, this.estimatedSizeBytes, required this.requiresMerge}): super._();
  factory _StreamInfoModel.fromJson(Map<String, dynamic> json) => _$StreamInfoModelFromJson(json);

@override final  String itag;
@override final  String type;
@override final  String? resolution;
@override final  int? fps;
@override final  String codec;
@override final  String container;
@override final  int? bitrate;
@override final  int? estimatedSizeBytes;
@override final  bool requiresMerge;

/// Create a copy of StreamInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreamInfoModelCopyWith<_StreamInfoModel> get copyWith => __$StreamInfoModelCopyWithImpl<_StreamInfoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreamInfoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreamInfoModel&&(identical(other.itag, itag) || other.itag == itag)&&(identical(other.type, type) || other.type == type)&&(identical(other.resolution, resolution) || other.resolution == resolution)&&(identical(other.fps, fps) || other.fps == fps)&&(identical(other.codec, codec) || other.codec == codec)&&(identical(other.container, container) || other.container == container)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.estimatedSizeBytes, estimatedSizeBytes) || other.estimatedSizeBytes == estimatedSizeBytes)&&(identical(other.requiresMerge, requiresMerge) || other.requiresMerge == requiresMerge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itag,type,resolution,fps,codec,container,bitrate,estimatedSizeBytes,requiresMerge);

@override
String toString() {
  return 'StreamInfoModel(itag: $itag, type: $type, resolution: $resolution, fps: $fps, codec: $codec, container: $container, bitrate: $bitrate, estimatedSizeBytes: $estimatedSizeBytes, requiresMerge: $requiresMerge)';
}


}

/// @nodoc
abstract mixin class _$StreamInfoModelCopyWith<$Res> implements $StreamInfoModelCopyWith<$Res> {
  factory _$StreamInfoModelCopyWith(_StreamInfoModel value, $Res Function(_StreamInfoModel) _then) = __$StreamInfoModelCopyWithImpl;
@override @useResult
$Res call({
 String itag, String type, String? resolution, int? fps, String codec, String container, int? bitrate, int? estimatedSizeBytes, bool requiresMerge
});




}
/// @nodoc
class __$StreamInfoModelCopyWithImpl<$Res>
    implements _$StreamInfoModelCopyWith<$Res> {
  __$StreamInfoModelCopyWithImpl(this._self, this._then);

  final _StreamInfoModel _self;
  final $Res Function(_StreamInfoModel) _then;

/// Create a copy of StreamInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itag = null,Object? type = null,Object? resolution = freezed,Object? fps = freezed,Object? codec = null,Object? container = null,Object? bitrate = freezed,Object? estimatedSizeBytes = freezed,Object? requiresMerge = null,}) {
  return _then(_StreamInfoModel(
itag: null == itag ? _self.itag : itag // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,fps: freezed == fps ? _self.fps : fps // ignore: cast_nullable_to_non_nullable
as int?,codec: null == codec ? _self.codec : codec // ignore: cast_nullable_to_non_nullable
as String,container: null == container ? _self.container : container // ignore: cast_nullable_to_non_nullable
as String,bitrate: freezed == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int?,estimatedSizeBytes: freezed == estimatedSizeBytes ? _self.estimatedSizeBytes : estimatedSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,requiresMerge: null == requiresMerge ? _self.requiresMerge : requiresMerge // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
