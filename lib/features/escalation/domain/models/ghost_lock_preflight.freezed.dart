// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_preflight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostLockPreflight {

/// wire-ADB 是否已连接。
 bool get adbConnected;/// shell 身份；`2000` 可用，`-1` 表示没取到。
 int get shellUid;/// `/proc/$$/status` 的 `Seccomp`；`-1` 表示没取到。
 int get seccomp;/// 设备 `uname -r` 全串；取不到为空串。
 String get release;/// 命中的 profile release；未命中为空串。
 String get profileRelease;/// 命中的路由 token；未命中为空串。
 String get route;/// `nativeLibraryDir/libghostlock.so` 是否存在。
 bool get binaryPresent;/// 将传给 `GHOSTLOCK_KSUD` 的路径；空串表示没有可用 ksud。
 String get ksudPath;/// profile 编码失败的原因码；成功为空串。
 String get profileError;
/// Create a copy of GhostLockPreflight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockPreflightCopyWith<GhostLockPreflight> get copyWith => _$GhostLockPreflightCopyWithImpl<GhostLockPreflight>(this as GhostLockPreflight, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockPreflight&&(identical(other.adbConnected, adbConnected) || other.adbConnected == adbConnected)&&(identical(other.shellUid, shellUid) || other.shellUid == shellUid)&&(identical(other.seccomp, seccomp) || other.seccomp == seccomp)&&(identical(other.release, release) || other.release == release)&&(identical(other.profileRelease, profileRelease) || other.profileRelease == profileRelease)&&(identical(other.route, route) || other.route == route)&&(identical(other.binaryPresent, binaryPresent) || other.binaryPresent == binaryPresent)&&(identical(other.ksudPath, ksudPath) || other.ksudPath == ksudPath)&&(identical(other.profileError, profileError) || other.profileError == profileError));
}


@override
int get hashCode => Object.hash(runtimeType,adbConnected,shellUid,seccomp,release,profileRelease,route,binaryPresent,ksudPath,profileError);

@override
String toString() {
  return 'GhostLockPreflight(adbConnected: $adbConnected, shellUid: $shellUid, seccomp: $seccomp, release: $release, profileRelease: $profileRelease, route: $route, binaryPresent: $binaryPresent, ksudPath: $ksudPath, profileError: $profileError)';
}


}

/// @nodoc
abstract mixin class $GhostLockPreflightCopyWith<$Res>  {
  factory $GhostLockPreflightCopyWith(GhostLockPreflight value, $Res Function(GhostLockPreflight) _then) = _$GhostLockPreflightCopyWithImpl;
@useResult
$Res call({
 bool adbConnected, int shellUid, int seccomp, String release, String profileRelease, String route, bool binaryPresent, String ksudPath, String profileError
});




}
/// @nodoc
class _$GhostLockPreflightCopyWithImpl<$Res>
    implements $GhostLockPreflightCopyWith<$Res> {
  _$GhostLockPreflightCopyWithImpl(this._self, this._then);

  final GhostLockPreflight _self;
  final $Res Function(GhostLockPreflight) _then;

/// Create a copy of GhostLockPreflight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adbConnected = null,Object? shellUid = null,Object? seccomp = null,Object? release = null,Object? profileRelease = null,Object? route = null,Object? binaryPresent = null,Object? ksudPath = null,Object? profileError = null,}) {
  return _then(_self.copyWith(
adbConnected: null == adbConnected ? _self.adbConnected : adbConnected // ignore: cast_nullable_to_non_nullable
as bool,shellUid: null == shellUid ? _self.shellUid : shellUid // ignore: cast_nullable_to_non_nullable
as int,seccomp: null == seccomp ? _self.seccomp : seccomp // ignore: cast_nullable_to_non_nullable
as int,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,profileRelease: null == profileRelease ? _self.profileRelease : profileRelease // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,binaryPresent: null == binaryPresent ? _self.binaryPresent : binaryPresent // ignore: cast_nullable_to_non_nullable
as bool,ksudPath: null == ksudPath ? _self.ksudPath : ksudPath // ignore: cast_nullable_to_non_nullable
as String,profileError: null == profileError ? _self.profileError : profileError // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockPreflight].
extension GhostLockPreflightPatterns on GhostLockPreflight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockPreflight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockPreflight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockPreflight value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockPreflight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockPreflight value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockPreflight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool adbConnected,  int shellUid,  int seccomp,  String release,  String profileRelease,  String route,  bool binaryPresent,  String ksudPath,  String profileError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockPreflight() when $default != null:
return $default(_that.adbConnected,_that.shellUid,_that.seccomp,_that.release,_that.profileRelease,_that.route,_that.binaryPresent,_that.ksudPath,_that.profileError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool adbConnected,  int shellUid,  int seccomp,  String release,  String profileRelease,  String route,  bool binaryPresent,  String ksudPath,  String profileError)  $default,) {final _that = this;
switch (_that) {
case _GhostLockPreflight():
return $default(_that.adbConnected,_that.shellUid,_that.seccomp,_that.release,_that.profileRelease,_that.route,_that.binaryPresent,_that.ksudPath,_that.profileError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool adbConnected,  int shellUid,  int seccomp,  String release,  String profileRelease,  String route,  bool binaryPresent,  String ksudPath,  String profileError)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockPreflight() when $default != null:
return $default(_that.adbConnected,_that.shellUid,_that.seccomp,_that.release,_that.profileRelease,_that.route,_that.binaryPresent,_that.ksudPath,_that.profileError);case _:
  return null;

}
}

}

/// @nodoc


class _GhostLockPreflight extends GhostLockPreflight {
  const _GhostLockPreflight({required this.adbConnected, required this.shellUid, required this.seccomp, required this.release, required this.profileRelease, required this.route, required this.binaryPresent, required this.ksudPath, required this.profileError}): super._();
  

/// wire-ADB 是否已连接。
@override final  bool adbConnected;
/// shell 身份；`2000` 可用，`-1` 表示没取到。
@override final  int shellUid;
/// `/proc/$$/status` 的 `Seccomp`；`-1` 表示没取到。
@override final  int seccomp;
/// 设备 `uname -r` 全串；取不到为空串。
@override final  String release;
/// 命中的 profile release；未命中为空串。
@override final  String profileRelease;
/// 命中的路由 token；未命中为空串。
@override final  String route;
/// `nativeLibraryDir/libghostlock.so` 是否存在。
@override final  bool binaryPresent;
/// 将传给 `GHOSTLOCK_KSUD` 的路径；空串表示没有可用 ksud。
@override final  String ksudPath;
/// profile 编码失败的原因码；成功为空串。
@override final  String profileError;

/// Create a copy of GhostLockPreflight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockPreflightCopyWith<_GhostLockPreflight> get copyWith => __$GhostLockPreflightCopyWithImpl<_GhostLockPreflight>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockPreflight&&(identical(other.adbConnected, adbConnected) || other.adbConnected == adbConnected)&&(identical(other.shellUid, shellUid) || other.shellUid == shellUid)&&(identical(other.seccomp, seccomp) || other.seccomp == seccomp)&&(identical(other.release, release) || other.release == release)&&(identical(other.profileRelease, profileRelease) || other.profileRelease == profileRelease)&&(identical(other.route, route) || other.route == route)&&(identical(other.binaryPresent, binaryPresent) || other.binaryPresent == binaryPresent)&&(identical(other.ksudPath, ksudPath) || other.ksudPath == ksudPath)&&(identical(other.profileError, profileError) || other.profileError == profileError));
}


@override
int get hashCode => Object.hash(runtimeType,adbConnected,shellUid,seccomp,release,profileRelease,route,binaryPresent,ksudPath,profileError);

@override
String toString() {
  return 'GhostLockPreflight(adbConnected: $adbConnected, shellUid: $shellUid, seccomp: $seccomp, release: $release, profileRelease: $profileRelease, route: $route, binaryPresent: $binaryPresent, ksudPath: $ksudPath, profileError: $profileError)';
}


}

/// @nodoc
abstract mixin class _$GhostLockPreflightCopyWith<$Res> implements $GhostLockPreflightCopyWith<$Res> {
  factory _$GhostLockPreflightCopyWith(_GhostLockPreflight value, $Res Function(_GhostLockPreflight) _then) = __$GhostLockPreflightCopyWithImpl;
@override @useResult
$Res call({
 bool adbConnected, int shellUid, int seccomp, String release, String profileRelease, String route, bool binaryPresent, String ksudPath, String profileError
});




}
/// @nodoc
class __$GhostLockPreflightCopyWithImpl<$Res>
    implements _$GhostLockPreflightCopyWith<$Res> {
  __$GhostLockPreflightCopyWithImpl(this._self, this._then);

  final _GhostLockPreflight _self;
  final $Res Function(_GhostLockPreflight) _then;

/// Create a copy of GhostLockPreflight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adbConnected = null,Object? shellUid = null,Object? seccomp = null,Object? release = null,Object? profileRelease = null,Object? route = null,Object? binaryPresent = null,Object? ksudPath = null,Object? profileError = null,}) {
  return _then(_GhostLockPreflight(
adbConnected: null == adbConnected ? _self.adbConnected : adbConnected // ignore: cast_nullable_to_non_nullable
as bool,shellUid: null == shellUid ? _self.shellUid : shellUid // ignore: cast_nullable_to_non_nullable
as int,seccomp: null == seccomp ? _self.seccomp : seccomp // ignore: cast_nullable_to_non_nullable
as int,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,profileRelease: null == profileRelease ? _self.profileRelease : profileRelease // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,binaryPresent: null == binaryPresent ? _self.binaryPresent : binaryPresent // ignore: cast_nullable_to_non_nullable
as bool,ksudPath: null == ksudPath ? _self.ksudPath : ksudPath // ignore: cast_nullable_to_non_nullable
as String,profileError: null == profileError ? _self.profileError : profileError // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
