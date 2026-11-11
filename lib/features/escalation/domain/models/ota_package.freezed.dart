// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ota_package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtaPackage {

 String get device; String get model; String get version; String get build; String get url;
/// Create a copy of OtaPackage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtaPackageCopyWith<OtaPackage> get copyWith => _$OtaPackageCopyWithImpl<OtaPackage>(this as OtaPackage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtaPackage&&(identical(other.device, device) || other.device == device)&&(identical(other.model, model) || other.model == model)&&(identical(other.version, version) || other.version == version)&&(identical(other.build, build) || other.build == build)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,device,model,version,build,url);

@override
String toString() {
  return 'OtaPackage(device: $device, model: $model, version: $version, build: $build, url: $url)';
}


}

/// @nodoc
abstract mixin class $OtaPackageCopyWith<$Res>  {
  factory $OtaPackageCopyWith(OtaPackage value, $Res Function(OtaPackage) _then) = _$OtaPackageCopyWithImpl;
@useResult
$Res call({
 String device, String model, String version, String build, String url
});




}
/// @nodoc
class _$OtaPackageCopyWithImpl<$Res>
    implements $OtaPackageCopyWith<$Res> {
  _$OtaPackageCopyWithImpl(this._self, this._then);

  final OtaPackage _self;
  final $Res Function(OtaPackage) _then;

/// Create a copy of OtaPackage
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


/// Adds pattern-matching-related methods to [OtaPackage].
extension OtaPackagePatterns on OtaPackage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtaPackage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtaPackage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtaPackage value)  $default,){
final _that = this;
switch (_that) {
case _OtaPackage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtaPackage value)?  $default,){
final _that = this;
switch (_that) {
case _OtaPackage() when $default != null:
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
case _OtaPackage() when $default != null:
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
case _OtaPackage():
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
case _OtaPackage() when $default != null:
return $default(_that.device,_that.model,_that.version,_that.build,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _OtaPackage extends OtaPackage {
  const _OtaPackage({required this.device, required this.model, required this.version, required this.build, required this.url}): super._();
  

@override final  String device;
@override final  String model;
@override final  String version;
@override final  String build;
@override final  String url;

/// Create a copy of OtaPackage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtaPackageCopyWith<_OtaPackage> get copyWith => __$OtaPackageCopyWithImpl<_OtaPackage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtaPackage&&(identical(other.device, device) || other.device == device)&&(identical(other.model, model) || other.model == model)&&(identical(other.version, version) || other.version == version)&&(identical(other.build, build) || other.build == build)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,device,model,version,build,url);

@override
String toString() {
  return 'OtaPackage(device: $device, model: $model, version: $version, build: $build, url: $url)';
}


}

/// @nodoc
abstract mixin class _$OtaPackageCopyWith<$Res> implements $OtaPackageCopyWith<$Res> {
  factory _$OtaPackageCopyWith(_OtaPackage value, $Res Function(_OtaPackage) _then) = __$OtaPackageCopyWithImpl;
@override @useResult
$Res call({
 String device, String model, String version, String build, String url
});




}
/// @nodoc
class __$OtaPackageCopyWithImpl<$Res>
    implements _$OtaPackageCopyWith<$Res> {
  __$OtaPackageCopyWithImpl(this._self, this._then);

  final _OtaPackage _self;
  final $Res Function(_OtaPackage) _then;

/// Create a copy of OtaPackage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? model = null,Object? version = null,Object? build = null,Object? url = null,}) {
  return _then(_OtaPackage(
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
