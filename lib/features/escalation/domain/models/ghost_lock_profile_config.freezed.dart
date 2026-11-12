// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_profile_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostLockProfileConfig {

/// 设备内核 release。
 String get release;/// 是否解析到可用 profile。
 bool get hasProfile;/// 高级字段树。
 List<GhostLockProfileFieldNode> get roots;/// 通用参数。
 List<GhostLockExecutionField> get general;/// 当前 route；空串表示未声明。
 String get route;/// fallback 目标；空串表示未声明，`none` 表示显式关闭。
 String get fallbackTo;/// 违规字段路径；UI 标红。
 List<String> get invalidPaths;/// 内置表里的全部 release，升序；供「指定生效表」的下拉使用。
 List<String> get builtinReleases;
/// Create a copy of GhostLockProfileConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockProfileConfigCopyWith<GhostLockProfileConfig> get copyWith => _$GhostLockProfileConfigCopyWithImpl<GhostLockProfileConfig>(this as GhostLockProfileConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockProfileConfig&&(identical(other.release, release) || other.release == release)&&(identical(other.hasProfile, hasProfile) || other.hasProfile == hasProfile)&&const DeepCollectionEquality().equals(other.roots, roots)&&const DeepCollectionEquality().equals(other.general, general)&&(identical(other.route, route) || other.route == route)&&(identical(other.fallbackTo, fallbackTo) || other.fallbackTo == fallbackTo)&&const DeepCollectionEquality().equals(other.invalidPaths, invalidPaths)&&const DeepCollectionEquality().equals(other.builtinReleases, builtinReleases));
}


@override
int get hashCode => Object.hash(runtimeType,release,hasProfile,const DeepCollectionEquality().hash(roots),const DeepCollectionEquality().hash(general),route,fallbackTo,const DeepCollectionEquality().hash(invalidPaths),const DeepCollectionEquality().hash(builtinReleases));

@override
String toString() {
  return 'GhostLockProfileConfig(release: $release, hasProfile: $hasProfile, roots: $roots, general: $general, route: $route, fallbackTo: $fallbackTo, invalidPaths: $invalidPaths, builtinReleases: $builtinReleases)';
}


}

/// @nodoc
abstract mixin class $GhostLockProfileConfigCopyWith<$Res>  {
  factory $GhostLockProfileConfigCopyWith(GhostLockProfileConfig value, $Res Function(GhostLockProfileConfig) _then) = _$GhostLockProfileConfigCopyWithImpl;
@useResult
$Res call({
 String release, bool hasProfile, List<GhostLockProfileFieldNode> roots, List<GhostLockExecutionField> general, String route, String fallbackTo, List<String> invalidPaths, List<String> builtinReleases
});




}
/// @nodoc
class _$GhostLockProfileConfigCopyWithImpl<$Res>
    implements $GhostLockProfileConfigCopyWith<$Res> {
  _$GhostLockProfileConfigCopyWithImpl(this._self, this._then);

  final GhostLockProfileConfig _self;
  final $Res Function(GhostLockProfileConfig) _then;

/// Create a copy of GhostLockProfileConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? release = null,Object? hasProfile = null,Object? roots = null,Object? general = null,Object? route = null,Object? fallbackTo = null,Object? invalidPaths = null,Object? builtinReleases = null,}) {
  return _then(_self.copyWith(
release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,hasProfile: null == hasProfile ? _self.hasProfile : hasProfile // ignore: cast_nullable_to_non_nullable
as bool,roots: null == roots ? _self.roots : roots // ignore: cast_nullable_to_non_nullable
as List<GhostLockProfileFieldNode>,general: null == general ? _self.general : general // ignore: cast_nullable_to_non_nullable
as List<GhostLockExecutionField>,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,fallbackTo: null == fallbackTo ? _self.fallbackTo : fallbackTo // ignore: cast_nullable_to_non_nullable
as String,invalidPaths: null == invalidPaths ? _self.invalidPaths : invalidPaths // ignore: cast_nullable_to_non_nullable
as List<String>,builtinReleases: null == builtinReleases ? _self.builtinReleases : builtinReleases // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockProfileConfig].
extension GhostLockProfileConfigPatterns on GhostLockProfileConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockProfileConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockProfileConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockProfileConfig value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockProfileConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockProfileConfig value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockProfileConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String release,  bool hasProfile,  List<GhostLockProfileFieldNode> roots,  List<GhostLockExecutionField> general,  String route,  String fallbackTo,  List<String> invalidPaths,  List<String> builtinReleases)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockProfileConfig() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String release,  bool hasProfile,  List<GhostLockProfileFieldNode> roots,  List<GhostLockExecutionField> general,  String route,  String fallbackTo,  List<String> invalidPaths,  List<String> builtinReleases)  $default,) {final _that = this;
switch (_that) {
case _GhostLockProfileConfig():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String release,  bool hasProfile,  List<GhostLockProfileFieldNode> roots,  List<GhostLockExecutionField> general,  String route,  String fallbackTo,  List<String> invalidPaths,  List<String> builtinReleases)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockProfileConfig() when $default != null:
return $default(_that.release,_that.hasProfile,_that.roots,_that.general,_that.route,_that.fallbackTo,_that.invalidPaths,_that.builtinReleases);case _:
  return null;

}
}

}

/// @nodoc


class _GhostLockProfileConfig extends GhostLockProfileConfig {
  const _GhostLockProfileConfig({required this.release, required this.hasProfile, required this.roots, required this.general, required this.route, required this.fallbackTo, required this.invalidPaths, required this.builtinReleases}): super._();
  

/// 设备内核 release。
@override final  String release;
/// 是否解析到可用 profile。
@override final  bool hasProfile;
/// 高级字段树。
@override final  List<GhostLockProfileFieldNode> roots;
/// 通用参数。
@override final  List<GhostLockExecutionField> general;
/// 当前 route；空串表示未声明。
@override final  String route;
/// fallback 目标；空串表示未声明，`none` 表示显式关闭。
@override final  String fallbackTo;
/// 违规字段路径；UI 标红。
@override final  List<String> invalidPaths;
/// 内置表里的全部 release，升序；供「指定生效表」的下拉使用。
@override final  List<String> builtinReleases;

/// Create a copy of GhostLockProfileConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockProfileConfigCopyWith<_GhostLockProfileConfig> get copyWith => __$GhostLockProfileConfigCopyWithImpl<_GhostLockProfileConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockProfileConfig&&(identical(other.release, release) || other.release == release)&&(identical(other.hasProfile, hasProfile) || other.hasProfile == hasProfile)&&const DeepCollectionEquality().equals(other.roots, roots)&&const DeepCollectionEquality().equals(other.general, general)&&(identical(other.route, route) || other.route == route)&&(identical(other.fallbackTo, fallbackTo) || other.fallbackTo == fallbackTo)&&const DeepCollectionEquality().equals(other.invalidPaths, invalidPaths)&&const DeepCollectionEquality().equals(other.builtinReleases, builtinReleases));
}


@override
int get hashCode => Object.hash(runtimeType,release,hasProfile,const DeepCollectionEquality().hash(roots),const DeepCollectionEquality().hash(general),route,fallbackTo,const DeepCollectionEquality().hash(invalidPaths),const DeepCollectionEquality().hash(builtinReleases));

@override
String toString() {
  return 'GhostLockProfileConfig(release: $release, hasProfile: $hasProfile, roots: $roots, general: $general, route: $route, fallbackTo: $fallbackTo, invalidPaths: $invalidPaths, builtinReleases: $builtinReleases)';
}


}

/// @nodoc
abstract mixin class _$GhostLockProfileConfigCopyWith<$Res> implements $GhostLockProfileConfigCopyWith<$Res> {
  factory _$GhostLockProfileConfigCopyWith(_GhostLockProfileConfig value, $Res Function(_GhostLockProfileConfig) _then) = __$GhostLockProfileConfigCopyWithImpl;
@override @useResult
$Res call({
 String release, bool hasProfile, List<GhostLockProfileFieldNode> roots, List<GhostLockExecutionField> general, String route, String fallbackTo, List<String> invalidPaths, List<String> builtinReleases
});




}
/// @nodoc
class __$GhostLockProfileConfigCopyWithImpl<$Res>
    implements _$GhostLockProfileConfigCopyWith<$Res> {
  __$GhostLockProfileConfigCopyWithImpl(this._self, this._then);

  final _GhostLockProfileConfig _self;
  final $Res Function(_GhostLockProfileConfig) _then;

/// Create a copy of GhostLockProfileConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? release = null,Object? hasProfile = null,Object? roots = null,Object? general = null,Object? route = null,Object? fallbackTo = null,Object? invalidPaths = null,Object? builtinReleases = null,}) {
  return _then(_GhostLockProfileConfig(
release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,hasProfile: null == hasProfile ? _self.hasProfile : hasProfile // ignore: cast_nullable_to_non_nullable
as bool,roots: null == roots ? _self.roots : roots // ignore: cast_nullable_to_non_nullable
as List<GhostLockProfileFieldNode>,general: null == general ? _self.general : general // ignore: cast_nullable_to_non_nullable
as List<GhostLockExecutionField>,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,fallbackTo: null == fallbackTo ? _self.fallbackTo : fallbackTo // ignore: cast_nullable_to_non_nullable
as String,invalidPaths: null == invalidPaths ? _self.invalidPaths : invalidPaths // ignore: cast_nullable_to_non_nullable
as List<String>,builtinReleases: null == builtinReleases ? _self.builtinReleases : builtinReleases // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
