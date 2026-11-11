// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_key_preflight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostKeyPreflight {

/// ADB 连接是否活着。
 bool get adbConnected;/// shell 身份 uid：`2000` = shell，`0` = root，`-1` = 取不到。
 int get shellUid;/// `/proc/$$/status` 的 `Seccomp` 字段：`0` = 无过滤器，`-1` = 取不到。
 int get seccomp;/// 设备内核 release（`uname -r` 原样）；空串表示取不到。
 String get release;/// 该 release 是否命中内置 profile 表。
 bool get profileMatched;/// `nativeLibraryDir/libcve98260.so` 是否存在。
 bool get binaryPresent;
/// Create a copy of GhostKeyPreflight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostKeyPreflightCopyWith<GhostKeyPreflight> get copyWith => _$GhostKeyPreflightCopyWithImpl<GhostKeyPreflight>(this as GhostKeyPreflight, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostKeyPreflight&&(identical(other.adbConnected, adbConnected) || other.adbConnected == adbConnected)&&(identical(other.shellUid, shellUid) || other.shellUid == shellUid)&&(identical(other.seccomp, seccomp) || other.seccomp == seccomp)&&(identical(other.release, release) || other.release == release)&&(identical(other.profileMatched, profileMatched) || other.profileMatched == profileMatched)&&(identical(other.binaryPresent, binaryPresent) || other.binaryPresent == binaryPresent));
}


@override
int get hashCode => Object.hash(runtimeType,adbConnected,shellUid,seccomp,release,profileMatched,binaryPresent);

@override
String toString() {
  return 'GhostKeyPreflight(adbConnected: $adbConnected, shellUid: $shellUid, seccomp: $seccomp, release: $release, profileMatched: $profileMatched, binaryPresent: $binaryPresent)';
}


}

/// @nodoc
abstract mixin class $GhostKeyPreflightCopyWith<$Res>  {
  factory $GhostKeyPreflightCopyWith(GhostKeyPreflight value, $Res Function(GhostKeyPreflight) _then) = _$GhostKeyPreflightCopyWithImpl;
@useResult
$Res call({
 bool adbConnected, int shellUid, int seccomp, String release, bool profileMatched, bool binaryPresent
});




}
/// @nodoc
class _$GhostKeyPreflightCopyWithImpl<$Res>
    implements $GhostKeyPreflightCopyWith<$Res> {
  _$GhostKeyPreflightCopyWithImpl(this._self, this._then);

  final GhostKeyPreflight _self;
  final $Res Function(GhostKeyPreflight) _then;

/// Create a copy of GhostKeyPreflight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adbConnected = null,Object? shellUid = null,Object? seccomp = null,Object? release = null,Object? profileMatched = null,Object? binaryPresent = null,}) {
  return _then(_self.copyWith(
adbConnected: null == adbConnected ? _self.adbConnected : adbConnected // ignore: cast_nullable_to_non_nullable
as bool,shellUid: null == shellUid ? _self.shellUid : shellUid // ignore: cast_nullable_to_non_nullable
as int,seccomp: null == seccomp ? _self.seccomp : seccomp // ignore: cast_nullable_to_non_nullable
as int,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,profileMatched: null == profileMatched ? _self.profileMatched : profileMatched // ignore: cast_nullable_to_non_nullable
as bool,binaryPresent: null == binaryPresent ? _self.binaryPresent : binaryPresent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostKeyPreflight].
extension GhostKeyPreflightPatterns on GhostKeyPreflight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostKeyPreflight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostKeyPreflight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostKeyPreflight value)  $default,){
final _that = this;
switch (_that) {
case _GhostKeyPreflight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostKeyPreflight value)?  $default,){
final _that = this;
switch (_that) {
case _GhostKeyPreflight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool adbConnected,  int shellUid,  int seccomp,  String release,  bool profileMatched,  bool binaryPresent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostKeyPreflight() when $default != null:
return $default(_that.adbConnected,_that.shellUid,_that.seccomp,_that.release,_that.profileMatched,_that.binaryPresent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool adbConnected,  int shellUid,  int seccomp,  String release,  bool profileMatched,  bool binaryPresent)  $default,) {final _that = this;
switch (_that) {
case _GhostKeyPreflight():
return $default(_that.adbConnected,_that.shellUid,_that.seccomp,_that.release,_that.profileMatched,_that.binaryPresent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool adbConnected,  int shellUid,  int seccomp,  String release,  bool profileMatched,  bool binaryPresent)?  $default,) {final _that = this;
switch (_that) {
case _GhostKeyPreflight() when $default != null:
return $default(_that.adbConnected,_that.shellUid,_that.seccomp,_that.release,_that.profileMatched,_that.binaryPresent);case _:
  return null;

}
}

}

/// @nodoc


class _GhostKeyPreflight extends GhostKeyPreflight {
  const _GhostKeyPreflight({required this.adbConnected, required this.shellUid, required this.seccomp, required this.release, required this.profileMatched, required this.binaryPresent}): super._();
  

/// ADB 连接是否活着。
@override final  bool adbConnected;
/// shell 身份 uid：`2000` = shell，`0` = root，`-1` = 取不到。
@override final  int shellUid;
/// `/proc/$$/status` 的 `Seccomp` 字段：`0` = 无过滤器，`-1` = 取不到。
@override final  int seccomp;
/// 设备内核 release（`uname -r` 原样）；空串表示取不到。
@override final  String release;
/// 该 release 是否命中内置 profile 表。
@override final  bool profileMatched;
/// `nativeLibraryDir/libcve98260.so` 是否存在。
@override final  bool binaryPresent;

/// Create a copy of GhostKeyPreflight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostKeyPreflightCopyWith<_GhostKeyPreflight> get copyWith => __$GhostKeyPreflightCopyWithImpl<_GhostKeyPreflight>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostKeyPreflight&&(identical(other.adbConnected, adbConnected) || other.adbConnected == adbConnected)&&(identical(other.shellUid, shellUid) || other.shellUid == shellUid)&&(identical(other.seccomp, seccomp) || other.seccomp == seccomp)&&(identical(other.release, release) || other.release == release)&&(identical(other.profileMatched, profileMatched) || other.profileMatched == profileMatched)&&(identical(other.binaryPresent, binaryPresent) || other.binaryPresent == binaryPresent));
}


@override
int get hashCode => Object.hash(runtimeType,adbConnected,shellUid,seccomp,release,profileMatched,binaryPresent);

@override
String toString() {
  return 'GhostKeyPreflight(adbConnected: $adbConnected, shellUid: $shellUid, seccomp: $seccomp, release: $release, profileMatched: $profileMatched, binaryPresent: $binaryPresent)';
}


}

/// @nodoc
abstract mixin class _$GhostKeyPreflightCopyWith<$Res> implements $GhostKeyPreflightCopyWith<$Res> {
  factory _$GhostKeyPreflightCopyWith(_GhostKeyPreflight value, $Res Function(_GhostKeyPreflight) _then) = __$GhostKeyPreflightCopyWithImpl;
@override @useResult
$Res call({
 bool adbConnected, int shellUid, int seccomp, String release, bool profileMatched, bool binaryPresent
});




}
/// @nodoc
class __$GhostKeyPreflightCopyWithImpl<$Res>
    implements _$GhostKeyPreflightCopyWith<$Res> {
  __$GhostKeyPreflightCopyWithImpl(this._self, this._then);

  final _GhostKeyPreflight _self;
  final $Res Function(_GhostKeyPreflight) _then;

/// Create a copy of GhostKeyPreflight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adbConnected = null,Object? shellUid = null,Object? seccomp = null,Object? release = null,Object? profileMatched = null,Object? binaryPresent = null,}) {
  return _then(_GhostKeyPreflight(
adbConnected: null == adbConnected ? _self.adbConnected : adbConnected // ignore: cast_nullable_to_non_nullable
as bool,shellUid: null == shellUid ? _self.shellUid : shellUid // ignore: cast_nullable_to_non_nullable
as int,seccomp: null == seccomp ? _self.seccomp : seccomp // ignore: cast_nullable_to_non_nullable
as int,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,profileMatched: null == profileMatched ? _self.profileMatched : profileMatched // ignore: cast_nullable_to_non_nullable
as bool,binaryPresent: null == binaryPresent ? _self.binaryPresent : binaryPresent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
