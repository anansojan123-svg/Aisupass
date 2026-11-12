// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_probe_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GhostLockProbeDto {

 bool get ok; String get release; String get conf; List<String> get warnings; String get bootPath; String get reason;
/// Create a copy of GhostLockProbeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockProbeDtoCopyWith<GhostLockProbeDto> get copyWith => _$GhostLockProbeDtoCopyWithImpl<GhostLockProbeDto>(this as GhostLockProbeDto, _$identity);

  /// Serializes this GhostLockProbeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockProbeDto&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&(identical(other.conf, conf) || other.conf == conf)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&(identical(other.bootPath, bootPath) || other.bootPath == bootPath)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,release,conf,const DeepCollectionEquality().hash(warnings),bootPath,reason);

@override
String toString() {
  return 'GhostLockProbeDto(ok: $ok, release: $release, conf: $conf, warnings: $warnings, bootPath: $bootPath, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $GhostLockProbeDtoCopyWith<$Res>  {
  factory $GhostLockProbeDtoCopyWith(GhostLockProbeDto value, $Res Function(GhostLockProbeDto) _then) = _$GhostLockProbeDtoCopyWithImpl;
@useResult
$Res call({
 bool ok, String release, String conf, List<String> warnings, String bootPath, String reason
});




}
/// @nodoc
class _$GhostLockProbeDtoCopyWithImpl<$Res>
    implements $GhostLockProbeDtoCopyWith<$Res> {
  _$GhostLockProbeDtoCopyWithImpl(this._self, this._then);

  final GhostLockProbeDto _self;
  final $Res Function(GhostLockProbeDto) _then;

/// Create a copy of GhostLockProbeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? release = null,Object? conf = null,Object? warnings = null,Object? bootPath = null,Object? reason = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,conf: null == conf ? _self.conf : conf // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,bootPath: null == bootPath ? _self.bootPath : bootPath // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockProbeDto].
extension GhostLockProbeDtoPatterns on GhostLockProbeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockProbeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockProbeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockProbeDto value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockProbeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockProbeDto value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockProbeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String release,  String conf,  List<String> warnings,  String bootPath,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockProbeDto() when $default != null:
return $default(_that.ok,_that.release,_that.conf,_that.warnings,_that.bootPath,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String release,  String conf,  List<String> warnings,  String bootPath,  String reason)  $default,) {final _that = this;
switch (_that) {
case _GhostLockProbeDto():
return $default(_that.ok,_that.release,_that.conf,_that.warnings,_that.bootPath,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String release,  String conf,  List<String> warnings,  String bootPath,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockProbeDto() when $default != null:
return $default(_that.ok,_that.release,_that.conf,_that.warnings,_that.bootPath,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GhostLockProbeDto extends GhostLockProbeDto {
  const _GhostLockProbeDto({this.ok = false, this.release = '', this.conf = '', this.warnings = const <String>[], this.bootPath = '', this.reason = ''}): super._();
  factory _GhostLockProbeDto.fromJson(Map<String, dynamic> json) => _$GhostLockProbeDtoFromJson(json);

@override@JsonKey() final  bool ok;
@override@JsonKey() final  String release;
@override@JsonKey() final  String conf;
@override@JsonKey() final  List<String> warnings;
@override@JsonKey() final  String bootPath;
@override@JsonKey() final  String reason;

/// Create a copy of GhostLockProbeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockProbeDtoCopyWith<_GhostLockProbeDto> get copyWith => __$GhostLockProbeDtoCopyWithImpl<_GhostLockProbeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GhostLockProbeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockProbeDto&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&(identical(other.conf, conf) || other.conf == conf)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&(identical(other.bootPath, bootPath) || other.bootPath == bootPath)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,release,conf,const DeepCollectionEquality().hash(warnings),bootPath,reason);

@override
String toString() {
  return 'GhostLockProbeDto(ok: $ok, release: $release, conf: $conf, warnings: $warnings, bootPath: $bootPath, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$GhostLockProbeDtoCopyWith<$Res> implements $GhostLockProbeDtoCopyWith<$Res> {
  factory _$GhostLockProbeDtoCopyWith(_GhostLockProbeDto value, $Res Function(_GhostLockProbeDto) _then) = __$GhostLockProbeDtoCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String release, String conf, List<String> warnings, String bootPath, String reason
});




}
/// @nodoc
class __$GhostLockProbeDtoCopyWithImpl<$Res>
    implements _$GhostLockProbeDtoCopyWith<$Res> {
  __$GhostLockProbeDtoCopyWithImpl(this._self, this._then);

  final _GhostLockProbeDto _self;
  final $Res Function(_GhostLockProbeDto) _then;

/// Create a copy of GhostLockProbeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? release = null,Object? conf = null,Object? warnings = null,Object? bootPath = null,Object? reason = null,}) {
  return _then(_GhostLockProbeDto(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,conf: null == conf ? _self.conf : conf // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,bootPath: null == bootPath ? _self.bootPath : bootPath // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
