// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_profile_config_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GhostLockProfileConfigDto {

 String get release; bool get hasProfile; List<GhostLockProfileFieldNodeDto> get roots; List<GhostLockExecutionFieldDto> get general; String get route; String get fallbackTo; List<String> get invalidPaths; List<String> get builtinReleases;
/// Create a copy of GhostLockProfileConfigDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockProfileConfigDtoCopyWith<GhostLockProfileConfigDto> get copyWith => _$GhostLockProfileConfigDtoCopyWithImpl<GhostLockProfileConfigDto>(this as GhostLockProfileConfigDto, _$identity);

  /// Serializes this GhostLockProfileConfigDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockProfileConfigDto&&(identical(other.release, release) || other.release == release)&&(identical(other.hasProfile, hasProfile) || other.hasProfile == hasProfile)&&const DeepCollectionEquality().equals(other.roots, roots)&&const DeepCollectionEquality().equals(other.general, general)&&(identical(other.route, route) || other.route == route)&&(identical(other.fallbackTo, fallbackTo) || other.fallbackTo == fallbackTo)&&const DeepCollectionEquality().equals(other.invalidPaths, invalidPaths)&&const DeepCollectionEquality().equals(other.builtinReleases, builtinReleases));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,release,hasProfile,const DeepCollectionEquality().hash(roots),const DeepCollectionEquality().hash(general),route,fallbackTo,const DeepCollectionEquality().hash(invalidPaths),const DeepCollectionEquality().hash(builtinReleases));

@override
String toString() {
  return 'GhostLockProfileConfigDto(release: $release, hasProfile: $hasProfile, roots: $roots, general: $general, route: $route, fallbackTo: $fallbackTo, invalidPaths: $invalidPaths, builtinReleases: $builtinReleases)';
}


}

/// @nodoc
abstract mixin class $GhostLockProfileConfigDtoCopyWith<$Res>  {
  factory $GhostLockProfileConfigDtoCopyWith(GhostLockProfileConfigDto value, $Res Function(GhostLockProfileConfigDto) _then) = _$GhostLockProfileConfigDtoCopyWithImpl;
@useResult
$Res call({
 String release, bool hasProfile, List<GhostLockProfileFieldNodeDto> roots, List<GhostLockExecutionFieldDto> general, String route, String fallbackTo, List<String> invalidPaths, List<String> builtinReleases
});




}
/// @nodoc
class _$GhostLockProfileConfigDtoCopyWithImpl<$Res>
    implements $GhostLockProfileConfigDtoCopyWith<$Res> {
  _$GhostLockProfileConfigDtoCopyWithImpl(this._self, this._then);

  final GhostLockProfileConfigDto _self;
  final $Res Function(GhostLockProfileConfigDto) _then;

/// Create a copy of GhostLockProfileConfigDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? release = null,Object? hasProfile = null,Object? roots = null,Object? general = null,Object? route = null,Object? fallbackTo = null,Object? invalidPaths = null,Object? builtinReleases = null,}) {
  return _then(_self.copyWith(
release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,hasProfile: null == hasProfile ? _self.hasProfile : hasProfile // ignore: cast_nullable_to_non_nullable
as bool,roots: null == roots ? _self.roots : roots // ignore: cast_nullable_to_non_nullable
as List<GhostLockProfileFieldNodeDto>,general: null == general ? _self.general : general // ignore: cast_nullable_to_non_nullable
as List<GhostLockExecutionFieldDto>,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,fallbackTo: null == fallbackTo ? _self.fallbackTo : fallbackTo // ignore: cast_nullable_to_non_nullable
as String,invalidPaths: null == invalidPaths ? _self.invalidPaths : invalidPaths // ignore: cast_nullable_to_non_nullable
as List<String>,builtinReleases: null == builtinReleases ? _self.builtinReleases : builtinReleases // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockProfileConfigDto].
extension GhostLockProfileConfigDtoPatterns on GhostLockProfileConfigDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockProfileConfigDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockProfileConfigDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockProfileConfigDto value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockProfileConfigDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockProfileConfigDto value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockProfileConfigDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String release,  bool hasProfile,  List<GhostLockProfileFieldNodeDto> roots,  List<GhostLockExecutionFieldDto> general,  String route,  String fallbackTo,  List<String> invalidPaths,  List<String> builtinReleases)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockProfileConfigDto() when $default != null:
return $default(_that.release,_that.hasProfile,_that.roots,_that.general,_that.route,_that.fallbackTo,_that.invalidPaths,_that.builtinReleases);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String release,  bool hasProfile,  List<GhostLockProfileFieldNodeDto> roots,  List<GhostLockExecutionFieldDto> general,  String route,  String fallbackTo,  List<String> invalidPaths,  List<String> builtinReleases)  $default,) {final _that = this;
switch (_that) {
case _GhostLockProfileConfigDto():
return $default(_that.release,_that.hasProfile,_that.roots,_that.general,_that.route,_that.fallbackTo,_that.invalidPaths,_that.builtinReleases);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String release,  bool hasProfile,  List<GhostLockProfileFieldNodeDto> roots,  List<GhostLockExecutionFieldDto> general,  String route,  String fallbackTo,  List<String> invalidPaths,  List<String> builtinReleases)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockProfileConfigDto() when $default != null:
return $default(_that.release,_that.hasProfile,_that.roots,_that.general,_that.route,_that.fallbackTo,_that.invalidPaths,_that.builtinReleases);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GhostLockProfileConfigDto extends GhostLockProfileConfigDto {
  const _GhostLockProfileConfigDto({this.release = '', this.hasProfile = false, this.roots = const <GhostLockProfileFieldNodeDto>[], this.general = const <GhostLockExecutionFieldDto>[], this.route = '', this.fallbackTo = '', this.invalidPaths = const <String>[], this.builtinReleases = const <String>[]}): super._();
  factory _GhostLockProfileConfigDto.fromJson(Map<String, dynamic> json) => _$GhostLockProfileConfigDtoFromJson(json);

@override@JsonKey() final  String release;
@override@JsonKey() final  bool hasProfile;
@override@JsonKey() final  List<GhostLockProfileFieldNodeDto> roots;
@override@JsonKey() final  List<GhostLockExecutionFieldDto> general;
@override@JsonKey() final  String route;
@override@JsonKey() final  String fallbackTo;
@override@JsonKey() final  List<String> invalidPaths;
@override@JsonKey() final  List<String> builtinReleases;

/// Create a copy of GhostLockProfileConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockProfileConfigDtoCopyWith<_GhostLockProfileConfigDto> get copyWith => __$GhostLockProfileConfigDtoCopyWithImpl<_GhostLockProfileConfigDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GhostLockProfileConfigDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockProfileConfigDto&&(identical(other.release, release) || other.release == release)&&(identical(other.hasProfile, hasProfile) || other.hasProfile == hasProfile)&&const DeepCollectionEquality().equals(other.roots, roots)&&const DeepCollectionEquality().equals(other.general, general)&&(identical(other.route, route) || other.route == route)&&(identical(other.fallbackTo, fallbackTo) || other.fallbackTo == fallbackTo)&&const DeepCollectionEquality().equals(other.invalidPaths, invalidPaths)&&const DeepCollectionEquality().equals(other.builtinReleases, builtinReleases));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,release,hasProfile,const DeepCollectionEquality().hash(roots),const DeepCollectionEquality().hash(general),route,fallbackTo,const DeepCollectionEquality().hash(invalidPaths),const DeepCollectionEquality().hash(builtinReleases));

@override
String toString() {
  return 'GhostLockProfileConfigDto(release: $release, hasProfile: $hasProfile, roots: $roots, general: $general, route: $route, fallbackTo: $fallbackTo, invalidPaths: $invalidPaths, builtinReleases: $builtinReleases)';
}


}

/// @nodoc
abstract mixin class _$GhostLockProfileConfigDtoCopyWith<$Res> implements $GhostLockProfileConfigDtoCopyWith<$Res> {
  factory _$GhostLockProfileConfigDtoCopyWith(_GhostLockProfileConfigDto value, $Res Function(_GhostLockProfileConfigDto) _then) = __$GhostLockProfileConfigDtoCopyWithImpl;
@override @useResult
$Res call({
 String release, bool hasProfile, List<GhostLockProfileFieldNodeDto> roots, List<GhostLockExecutionFieldDto> general, String route, String fallbackTo, List<String> invalidPaths, List<String> builtinReleases
});




}
/// @nodoc
class __$GhostLockProfileConfigDtoCopyWithImpl<$Res>
    implements _$GhostLockProfileConfigDtoCopyWith<$Res> {
  __$GhostLockProfileConfigDtoCopyWithImpl(this._self, this._then);

  final _GhostLockProfileConfigDto _self;
  final $Res Function(_GhostLockProfileConfigDto) _then;

/// Create a copy of GhostLockProfileConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? release = null,Object? hasProfile = null,Object? roots = null,Object? general = null,Object? route = null,Object? fallbackTo = null,Object? invalidPaths = null,Object? builtinReleases = null,}) {
  return _then(_GhostLockProfileConfigDto(
release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,hasProfile: null == hasProfile ? _self.hasProfile : hasProfile // ignore: cast_nullable_to_non_nullable
as bool,roots: null == roots ? _self.roots : roots // ignore: cast_nullable_to_non_nullable
as List<GhostLockProfileFieldNodeDto>,general: null == general ? _self.general : general // ignore: cast_nullable_to_non_nullable
as List<GhostLockExecutionFieldDto>,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,fallbackTo: null == fallbackTo ? _self.fallbackTo : fallbackTo // ignore: cast_nullable_to_non_nullable
as String,invalidPaths: null == invalidPaths ? _self.invalidPaths : invalidPaths // ignore: cast_nullable_to_non_nullable
as List<String>,builtinReleases: null == builtinReleases ? _self.builtinReleases : builtinReleases // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
