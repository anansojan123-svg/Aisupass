// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ota_package_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OtaPackageDto {

 String get device; String get model; String get version; String get build; String get url;
/// Create a copy of OtaPackageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtaPackageDtoCopyWith<OtaPackageDto> get copyWith => _$OtaPackageDtoCopyWithImpl<OtaPackageDto>(this as OtaPackageDto, _$identity);

  /// Serializes this OtaPackageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtaPackageDto&&(identical(other.device, device) || other.device == device)&&(identical(other.model, model) || other.model == model)&&(identical(other.version, version) || other.version == version)&&(identical(other.build, build) || other.build == build)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,device,model,version,build,url);

@override
String toString() {
  return 'OtaPackageDto(device: $device, model: $model, version: $version, build: $build, url: $url)';
}


}

/// @nodoc
abstract mixin class $OtaPackageDtoCopyWith<$Res>  {
  factory $OtaPackageDtoCopyWith(OtaPackageDto value, $Res Function(OtaPackageDto) _then) = _$OtaPackageDtoCopyWithImpl;
@useResult
$Res call({
 String device, String model, String version, String build, String url
});




}
/// @nodoc
class _$OtaPackageDtoCopyWithImpl<$Res>
    implements $OtaPackageDtoCopyWith<$Res> {
  _$OtaPackageDtoCopyWithImpl(this._self, this._then);

  final OtaPackageDto _self;
  final $Res Function(OtaPackageDto) _then;

/// Create a copy of OtaPackageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? model = null,Object? version = null,Object? build = null,Object? url = null,}) {
  return _then(_self.copyWith(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,build: null == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OtaPackageDto].
extension OtaPackageDtoPatterns on OtaPackageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtaPackageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtaPackageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtaPackageDto value)  $default,){
final _that = this;
switch (_that) {
case _OtaPackageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtaPackageDto value)?  $default,){
final _that = this;
switch (_that) {
case _OtaPackageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String device,  String model,  String version,  String build,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtaPackageDto() when $default != null:
return $default(_that.device,_that.model,_that.version,_that.build,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String device,  String model,  String version,  String build,  String url)  $default,) {final _that = this;
switch (_that) {
case _OtaPackageDto():
return $default(_that.device,_that.model,_that.version,_that.build,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String device,  String model,  String version,  String build,  String url)?  $default,) {final _that = this;
switch (_that) {
case _OtaPackageDto() when $default != null:
return $default(_that.device,_that.model,_that.version,_that.build,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OtaPackageDto extends OtaPackageDto {
  const _OtaPackageDto({this.device = '', this.model = '', this.version = '', this.build = '', this.url = ''}): super._();
  factory _OtaPackageDto.fromJson(Map<String, dynamic> json) => _$OtaPackageDtoFromJson(json);

@override@JsonKey() final  String device;
@override@JsonKey() final  String model;
@override@JsonKey() final  String version;
@override@JsonKey() final  String build;
@override@JsonKey() final  String url;

/// Create a copy of OtaPackageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtaPackageDtoCopyWith<_OtaPackageDto> get copyWith => __$OtaPackageDtoCopyWithImpl<_OtaPackageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OtaPackageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtaPackageDto&&(identical(other.device, device) || other.device == device)&&(identical(other.model, model) || other.model == model)&&(identical(other.version, version) || other.version == version)&&(identical(other.build, build) || other.build == build)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,device,model,version,build,url);

@override
String toString() {
  return 'OtaPackageDto(device: $device, model: $model, version: $version, build: $build, url: $url)';
}


}

/// @nodoc
abstract mixin class _$OtaPackageDtoCopyWith<$Res> implements $OtaPackageDtoCopyWith<$Res> {
  factory _$OtaPackageDtoCopyWith(_OtaPackageDto value, $Res Function(_OtaPackageDto) _then) = __$OtaPackageDtoCopyWithImpl;
@override @useResult
$Res call({
 String device, String model, String version, String build, String url
});




}
/// @nodoc
class __$OtaPackageDtoCopyWithImpl<$Res>
    implements _$OtaPackageDtoCopyWith<$Res> {
  __$OtaPackageDtoCopyWithImpl(this._self, this._then);

  final _OtaPackageDto _self;
  final $Res Function(_OtaPackageDto) _then;

/// Create a copy of OtaPackageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? model = null,Object? version = null,Object? build = null,Object? url = null,}) {
  return _then(_OtaPackageDto(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,build: null == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
