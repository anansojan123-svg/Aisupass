// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_key_preflight_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GhostKeyPreflightDto {

 bool get adbConnected; int get shellUid; int get seccomp; String get release; bool get profileMatched; bool get binaryPresent;
/// Create a copy of GhostKeyPreflightDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostKeyPreflightDtoCopyWith<GhostKeyPreflightDto> get copyWith => _$GhostKeyPreflightDtoCopyWithImpl<GhostKeyPreflightDto>(this as GhostKeyPreflightDto, _$identity);

  /// Serializes this GhostKeyPreflightDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostKeyPreflightDto&&(identical(other.adbConnected, adbConnected) || other.adbConnected == adbConnected)&&(identical(other.shellUid, shellUid) || other.shellUid == shellUid)&&(identical(other.seccomp, seccomp) || other.seccomp == seccomp)&&(identical(other.release, release) || other.release == release)&&(identical(other.profileMatched, profileMatched) || other.profileMatched == profileMatched)&&(identical(other.binaryPresent, binaryPresent) || other.binaryPresent == binaryPresent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adbConnected,shellUid,seccomp,release,profileMatched,binaryPresent);

@override
String toString() {
  return 'GhostKeyPreflightDto(adbConnected: $adbConnected, shellUid: $shellUid, seccomp: $seccomp, release: $release, profileMatched: $profileMatched, binaryPresent: $binaryPresent)';
}


}

/// @nodoc
abstract mixin class $GhostKeyPreflightDtoCopyWith<$Res>  {
  factory $GhostKeyPreflightDtoCopyWith(GhostKeyPreflightDto value, $Res Function(GhostKeyPreflightDto) _then) = _$GhostKeyPreflightDtoCopyWithImpl;
@useResult
$Res call({
 bool adbConnected, int shellUid, int seccomp, String release, bool profileMatched, bool binaryPresent
});




}
/// @nodoc
class _$GhostKeyPreflightDtoCopyWithImpl<$Res>
    implements $GhostKeyPreflightDtoCopyWith<$Res> {
  _$GhostKeyPreflightDtoCopyWithImpl(this._self, this._then);

  final GhostKeyPreflightDto _self;
  final $Res Function(GhostKeyPreflightDto) _then;

/// Create a copy of GhostKeyPreflightDto
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


/// Adds pattern-matching-related methods to [GhostKeyPreflightDto].
extension GhostKeyPreflightDtoPatterns on GhostKeyPreflightDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostKeyPreflightDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostKeyPreflightDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostKeyPreflightDto value)  $default,){
final _that = this;
switch (_that) {
case _GhostKeyPreflightDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostKeyPreflightDto value)?  $default,){
final _that = this;
switch (_that) {
case _GhostKeyPreflightDto() when $default != null:
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
case _GhostKeyPreflightDto() when $default != null:
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
case _GhostKeyPreflightDto():
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
case _GhostKeyPreflightDto() when $default != null:
return $default(_that.adbConnected,_that.shellUid,_that.seccomp,_that.release,_that.profileMatched,_that.binaryPresent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GhostKeyPreflightDto extends GhostKeyPreflightDto {
  const _GhostKeyPreflightDto({this.adbConnected = false, this.shellUid = -1, this.seccomp = -1, this.release = '', this.profileMatched = false, this.binaryPresent = false}): super._();
  factory _GhostKeyPreflightDto.fromJson(Map<String, dynamic> json) => _$GhostKeyPreflightDtoFromJson(json);

@override@JsonKey() final  bool adbConnected;
@override@JsonKey() final  int shellUid;
@override@JsonKey() final  int seccomp;
@override@JsonKey() final  String release;
@override@JsonKey() final  bool profileMatched;
@override@JsonKey() final  bool binaryPresent;

/// Create a copy of GhostKeyPreflightDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostKeyPreflightDtoCopyWith<_GhostKeyPreflightDto> get copyWith => __$GhostKeyPreflightDtoCopyWithImpl<_GhostKeyPreflightDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GhostKeyPreflightDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostKeyPreflightDto&&(identical(other.adbConnected, adbConnected) || other.adbConnected == adbConnected)&&(identical(other.shellUid, shellUid) || other.shellUid == shellUid)&&(identical(other.seccomp, seccomp) || other.seccomp == seccomp)&&(identical(other.release, release) || other.release == release)&&(identical(other.profileMatched, profileMatched) || other.profileMatched == profileMatched)&&(identical(other.binaryPresent, binaryPresent) || other.binaryPresent == binaryPresent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adbConnected,shellUid,seccomp,release,profileMatched,binaryPresent);

@override
String toString() {
  return 'GhostKeyPreflightDto(adbConnected: $adbConnected, shellUid: $shellUid, seccomp: $seccomp, release: $release, profileMatched: $profileMatched, binaryPresent: $binaryPresent)';
}


}

/// @nodoc
abstract mixin class _$GhostKeyPreflightDtoCopyWith<$Res> implements $GhostKeyPreflightDtoCopyWith<$Res> {
  factory _$GhostKeyPreflightDtoCopyWith(_GhostKeyPreflightDto value, $Res Function(_GhostKeyPreflightDto) _then) = __$GhostKeyPreflightDtoCopyWithImpl;
@override @useResult
$Res call({
 bool adbConnected, int shellUid, int seccomp, String release, bool profileMatched, bool binaryPresent
});




}
/// @nodoc
class __$GhostKeyPreflightDtoCopyWithImpl<$Res>
    implements _$GhostKeyPreflightDtoCopyWith<$Res> {
  __$GhostKeyPreflightDtoCopyWithImpl(this._self, this._then);

  final _GhostKeyPreflightDto _self;
  final $Res Function(_GhostKeyPreflightDto) _then;

/// Create a copy of GhostKeyPreflightDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adbConnected = null,Object? shellUid = null,Object? seccomp = null,Object? release = null,Object? profileMatched = null,Object? binaryPresent = null,}) {
  return _then(_GhostKeyPreflightDto(
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
