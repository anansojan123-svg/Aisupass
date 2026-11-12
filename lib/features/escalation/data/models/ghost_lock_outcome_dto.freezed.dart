// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_outcome_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GhostLockOutcomeDto {

 String get sessionId; String get output; int get exitCode; int get durationMs; bool get timedOut;/// 原生侧异常类名或本侧诊断码；空串表示无异常。
 String get failure;/// 终局分类。默认 [GhostLockKind.running]，由仓储实现覆盖。
 GhostLockKind get kind;/// 累积输出。中间块为空串，终局块由仓储实现填入。
 String get log;/// 受理失败原因码；受理成功时为空串。
 String get reason;
/// Create a copy of GhostLockOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockOutcomeDtoCopyWith<GhostLockOutcomeDto> get copyWith => _$GhostLockOutcomeDtoCopyWithImpl<GhostLockOutcomeDto>(this as GhostLockOutcomeDto, _$identity);

  /// Serializes this GhostLockOutcomeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockOutcomeDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.output, output) || other.output == output)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.log, log) || other.log == log)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,output,exitCode,durationMs,timedOut,failure,kind,log,reason);

@override
String toString() {
  return 'GhostLockOutcomeDto(sessionId: $sessionId, output: $output, exitCode: $exitCode, durationMs: $durationMs, timedOut: $timedOut, failure: $failure, kind: $kind, log: $log, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $GhostLockOutcomeDtoCopyWith<$Res>  {
  factory $GhostLockOutcomeDtoCopyWith(GhostLockOutcomeDto value, $Res Function(GhostLockOutcomeDto) _then) = _$GhostLockOutcomeDtoCopyWithImpl;
@useResult
$Res call({
 String sessionId, String output, int exitCode, int durationMs, bool timedOut, String failure, GhostLockKind kind, String log, String reason
});




}
/// @nodoc
class _$GhostLockOutcomeDtoCopyWithImpl<$Res>
    implements $GhostLockOutcomeDtoCopyWith<$Res> {
  _$GhostLockOutcomeDtoCopyWithImpl(this._self, this._then);

  final GhostLockOutcomeDto _self;
  final $Res Function(GhostLockOutcomeDto) _then;

/// Create a copy of GhostLockOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? output = null,Object? exitCode = null,Object? durationMs = null,Object? timedOut = null,Object? failure = null,Object? kind = null,Object? log = null,Object? reason = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as GhostLockKind,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockOutcomeDto].
extension GhostLockOutcomeDtoPatterns on GhostLockOutcomeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockOutcomeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockOutcomeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockOutcomeDto value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockOutcomeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockOutcomeDto value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockOutcomeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String output,  int exitCode,  int durationMs,  bool timedOut,  String failure,  GhostLockKind kind,  String log,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockOutcomeDto() when $default != null:
return $default(_that.sessionId,_that.output,_that.exitCode,_that.durationMs,_that.timedOut,_that.failure,_that.kind,_that.log,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String output,  int exitCode,  int durationMs,  bool timedOut,  String failure,  GhostLockKind kind,  String log,  String reason)  $default,) {final _that = this;
switch (_that) {
case _GhostLockOutcomeDto():
return $default(_that.sessionId,_that.output,_that.exitCode,_that.durationMs,_that.timedOut,_that.failure,_that.kind,_that.log,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String output,  int exitCode,  int durationMs,  bool timedOut,  String failure,  GhostLockKind kind,  String log,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockOutcomeDto() when $default != null:
return $default(_that.sessionId,_that.output,_that.exitCode,_that.durationMs,_that.timedOut,_that.failure,_that.kind,_that.log,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GhostLockOutcomeDto extends GhostLockOutcomeDto {
  const _GhostLockOutcomeDto({this.sessionId = '', this.output = '', this.exitCode = -1, this.durationMs = 0, this.timedOut = false, this.failure = '', this.kind = GhostLockKind.running, this.log = '', this.reason = ''}): super._();
  factory _GhostLockOutcomeDto.fromJson(Map<String, dynamic> json) => _$GhostLockOutcomeDtoFromJson(json);

@override@JsonKey() final  String sessionId;
@override@JsonKey() final  String output;
@override@JsonKey() final  int exitCode;
@override@JsonKey() final  int durationMs;
@override@JsonKey() final  bool timedOut;
/// 原生侧异常类名或本侧诊断码；空串表示无异常。
@override@JsonKey() final  String failure;
/// 终局分类。默认 [GhostLockKind.running]，由仓储实现覆盖。
@override@JsonKey() final  GhostLockKind kind;
/// 累积输出。中间块为空串，终局块由仓储实现填入。
@override@JsonKey() final  String log;
/// 受理失败原因码；受理成功时为空串。
@override@JsonKey() final  String reason;

/// Create a copy of GhostLockOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockOutcomeDtoCopyWith<_GhostLockOutcomeDto> get copyWith => __$GhostLockOutcomeDtoCopyWithImpl<_GhostLockOutcomeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GhostLockOutcomeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockOutcomeDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.output, output) || other.output == output)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.log, log) || other.log == log)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,output,exitCode,durationMs,timedOut,failure,kind,log,reason);

@override
String toString() {
  return 'GhostLockOutcomeDto(sessionId: $sessionId, output: $output, exitCode: $exitCode, durationMs: $durationMs, timedOut: $timedOut, failure: $failure, kind: $kind, log: $log, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$GhostLockOutcomeDtoCopyWith<$Res> implements $GhostLockOutcomeDtoCopyWith<$Res> {
  factory _$GhostLockOutcomeDtoCopyWith(_GhostLockOutcomeDto value, $Res Function(_GhostLockOutcomeDto) _then) = __$GhostLockOutcomeDtoCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String output, int exitCode, int durationMs, bool timedOut, String failure, GhostLockKind kind, String log, String reason
});




}
/// @nodoc
class __$GhostLockOutcomeDtoCopyWithImpl<$Res>
    implements _$GhostLockOutcomeDtoCopyWith<$Res> {
  __$GhostLockOutcomeDtoCopyWithImpl(this._self, this._then);

  final _GhostLockOutcomeDto _self;
  final $Res Function(_GhostLockOutcomeDto) _then;

/// Create a copy of GhostLockOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? output = null,Object? exitCode = null,Object? durationMs = null,Object? timedOut = null,Object? failure = null,Object? kind = null,Object? log = null,Object? reason = null,}) {
  return _then(_GhostLockOutcomeDto(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as GhostLockKind,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
