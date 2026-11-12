// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_preflight_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GhostLockPreflightDto {

 bool get adbConnected; int get shellUid; int get seccomp; String get release; String get profileRelease; String get route; bool get binaryPresent; String get ksudPath; String get profileError;
/// Create a copy of GhostLockPreflightDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockPreflightDtoCopyWith<GhostLockPreflightDto> get copyWith => _$GhostLockPreflightDtoCopyWithImpl<GhostLockPreflightDto>(this as GhostLockPreflightDto, _$identity);

  /// Serializes this GhostLockPreflightDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockPreflightDto&&(identical(other.adbConnected, adbConnected) || other.adbConnected == adbConnected)&&(identical(other.shellUid, shellUid) || other.shellUid == shellUid)&&(identical(other.seccomp, seccomp) || other.seccomp == seccomp)&&(identical(other.release, release) || other.release == release)&&(identical(other.profileRelease, profileRelease) || other.profileRelease == profileRelease)&&(identical(other.route, route) || other.route == route)&&(identical(other.binaryPresent, binaryPresent) || other.binaryPresent == binaryPresent)&&(identical(other.ksudPath, ksudPath) || other.ksudPath == ksudPath)&&(identical(other.profileError, profileError) || other.profileError == profileError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adbConnected,shellUid,seccomp,release,profileRelease,route,binaryPresent,ksudPath,profileError);

@override
String toString() {
  return 'GhostLockPreflightDto(adbConnected: $adbConnected, shellUid: $shellUid, seccomp: $seccomp, release: $release, profileRelease: $profileRelease, route: $route, binaryPresent: $binaryPresent, ksudPath: $ksudPath, profileError: $profileError)';
}


}

/// @nodoc
abstract mixin class $GhostLockPreflightDtoCopyWith<$Res>  {
  factory $GhostLockPreflightDtoCopyWith(GhostLockPreflightDto value, $Res Function(GhostLockPreflightDto) _then) = _$GhostLockPreflightDtoCopyWithImpl;
@useResult
$Res call({
 bool adbConnected, int shellUid, int seccomp, String release, String profileRelease, String route, bool binaryPresent, String ksudPath, String profileError
});




}
/// @nodoc
class _$GhostLockPreflightDtoCopyWithImpl<$Res>
    implements $GhostLockPreflightDtoCopyWith<$Res> {
  _$GhostLockPreflightDtoCopyWithImpl(this._self, this._then);

  final GhostLockPreflightDto _self;
  final $Res Function(GhostLockPreflightDto) _then;

/// Create a copy of GhostLockPreflightDto
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


/// Adds pattern-matching-related methods to [GhostLockPreflightDto].
extension GhostLockPreflightDtoPatterns on GhostLockPreflightDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockPreflightDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockPreflightDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockPreflightDto value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockPreflightDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockPreflightDto value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockPreflightDto() when $default != null:
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
case _GhostLockPreflightDto() when $default != null:
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
case _GhostLockPreflightDto():
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
case _GhostLockPreflightDto() when $default != null:
return $default(_that.adbConnected,_that.shellUid,_that.seccomp,_that.release,_that.profileRelease,_that.route,_that.binaryPresent,_that.ksudPath,_that.profileError);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GhostLockPreflightDto extends GhostLockPreflightDto {
  const _GhostLockPreflightDto({this.adbConnected = false, this.shellUid = -1, this.seccomp = -1, this.release = '', this.profileRelease = '', this.route = '', this.binaryPresent = false, this.ksudPath = '', this.profileError = ''}): super._();
  factory _GhostLockPreflightDto.fromJson(Map<String, dynamic> json) => _$GhostLockPreflightDtoFromJson(json);

@override@JsonKey() final  bool adbConnected;
@override@JsonKey() final  int shellUid;
@override@JsonKey() final  int seccomp;
@override@JsonKey() final  String release;
@override@JsonKey() final  String profileRelease;
@override@JsonKey() final  String route;
@override@JsonKey() final  bool binaryPresent;
@override@JsonKey() final  String ksudPath;
@override@JsonKey() final  String profileError;

/// Create a copy of GhostLockPreflightDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockPreflightDtoCopyWith<_GhostLockPreflightDto> get copyWith => __$GhostLockPreflightDtoCopyWithImpl<_GhostLockPreflightDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GhostLockPreflightDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockPreflightDto&&(identical(other.adbConnected, adbConnected) || other.adbConnected == adbConnected)&&(identical(other.shellUid, shellUid) || other.shellUid == shellUid)&&(identical(other.seccomp, seccomp) || other.seccomp == seccomp)&&(identical(other.release, release) || other.release == release)&&(identical(other.profileRelease, profileRelease) || other.profileRelease == profileRelease)&&(identical(other.route, route) || other.route == route)&&(identical(other.binaryPresent, binaryPresent) || other.binaryPresent == binaryPresent)&&(identical(other.ksudPath, ksudPath) || other.ksudPath == ksudPath)&&(identical(other.profileError, profileError) || other.profileError == profileError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adbConnected,shellUid,seccomp,release,profileRelease,route,binaryPresent,ksudPath,profileError);

@override
String toString() {
  return 'GhostLockPreflightDto(adbConnected: $adbConnected, shellUid: $shellUid, seccomp: $seccomp, release: $release, profileRelease: $profileRelease, route: $route, binaryPresent: $binaryPresent, ksudPath: $ksudPath, profileError: $profileError)';
}


}

/// @nodoc
abstract mixin class _$GhostLockPreflightDtoCopyWith<$Res> implements $GhostLockPreflightDtoCopyWith<$Res> {
  factory _$GhostLockPreflightDtoCopyWith(_GhostLockPreflightDto value, $Res Function(_GhostLockPreflightDto) _then) = __$GhostLockPreflightDtoCopyWithImpl;
@override @useResult
$Res call({
 bool adbConnected, int shellUid, int seccomp, String release, String profileRelease, String route, bool binaryPresent, String ksudPath, String profileError
});




}
/// @nodoc
class __$GhostLockPreflightDtoCopyWithImpl<$Res>
    implements _$GhostLockPreflightDtoCopyWith<$Res> {
  __$GhostLockPreflightDtoCopyWithImpl(this._self, this._then);

  final _GhostLockPreflightDto _self;
  final $Res Function(_GhostLockPreflightDto) _then;

/// Create a copy of GhostLockPreflightDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adbConnected = null,Object? shellUid = null,Object? seccomp = null,Object? release = null,Object? profileRelease = null,Object? route = null,Object? binaryPresent = null,Object? ksudPath = null,Object? profileError = null,}) {
  return _then(_GhostLockPreflightDto(
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
