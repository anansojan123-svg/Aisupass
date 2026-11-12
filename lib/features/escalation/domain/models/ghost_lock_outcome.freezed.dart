// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_outcome.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostLockOutcome {

/// 终局分类；[GhostLockKind.running] 表示还有后续块。
 GhostLockKind get kind;/// 会话标识；受理失败时为空串。
 String get sessionId;/// 自上次块以来新增的输出，直接写屏。
 String get output;/// 累积输出，只有终局块非空；判定依据就是它。
 String get log;/// 退出码；`0` 完成，`1` 失败，`255` 原生 `pr_error`，`70` 脏竞争。
 int get exitCode;/// 从受理到终局的耗时（毫秒）。
 int get durationMs;/// 是否因本侧取消或超时停止读取；**不代表设备侧进程已停止**。
 bool get timedOut;/// 受理失败原因码；受理成功时为空串。
 String get reason;
/// Create a copy of GhostLockOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockOutcomeCopyWith<GhostLockOutcome> get copyWith => _$GhostLockOutcomeCopyWithImpl<GhostLockOutcome>(this as GhostLockOutcome, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockOutcome&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.output, output) || other.output == output)&&(identical(other.log, log) || other.log == log)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,kind,sessionId,output,log,exitCode,durationMs,timedOut,reason);

@override
String toString() {
  return 'GhostLockOutcome(kind: $kind, sessionId: $sessionId, output: $output, log: $log, exitCode: $exitCode, durationMs: $durationMs, timedOut: $timedOut, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $GhostLockOutcomeCopyWith<$Res>  {
  factory $GhostLockOutcomeCopyWith(GhostLockOutcome value, $Res Function(GhostLockOutcome) _then) = _$GhostLockOutcomeCopyWithImpl;
@useResult
$Res call({
 GhostLockKind kind, String sessionId, String output, String log, int exitCode, int durationMs, bool timedOut, String reason
});




}
/// @nodoc
class _$GhostLockOutcomeCopyWithImpl<$Res>
    implements $GhostLockOutcomeCopyWith<$Res> {
  _$GhostLockOutcomeCopyWithImpl(this._self, this._then);

  final GhostLockOutcome _self;
  final $Res Function(GhostLockOutcome) _then;

/// Create a copy of GhostLockOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? sessionId = null,Object? output = null,Object? log = null,Object? exitCode = null,Object? durationMs = null,Object? timedOut = null,Object? reason = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as GhostLockKind,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockOutcome].
extension GhostLockOutcomePatterns on GhostLockOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockOutcome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockOutcome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockOutcome value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockOutcome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockOutcome value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockOutcome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GhostLockKind kind,  String sessionId,  String output,  String log,  int exitCode,  int durationMs,  bool timedOut,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockOutcome() when $default != null:
return $default(_that.kind,_that.sessionId,_that.output,_that.log,_that.exitCode,_that.durationMs,_that.timedOut,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GhostLockKind kind,  String sessionId,  String output,  String log,  int exitCode,  int durationMs,  bool timedOut,  String reason)  $default,) {final _that = this;
switch (_that) {
case _GhostLockOutcome():
return $default(_that.kind,_that.sessionId,_that.output,_that.log,_that.exitCode,_that.durationMs,_that.timedOut,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GhostLockKind kind,  String sessionId,  String output,  String log,  int exitCode,  int durationMs,  bool timedOut,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockOutcome() when $default != null:
return $default(_that.kind,_that.sessionId,_that.output,_that.log,_that.exitCode,_that.durationMs,_that.timedOut,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _GhostLockOutcome extends GhostLockOutcome {
  const _GhostLockOutcome({required this.kind, required this.sessionId, required this.output, required this.log, required this.exitCode, required this.durationMs, required this.timedOut, required this.reason}): super._();
  

/// 终局分类；[GhostLockKind.running] 表示还有后续块。
@override final  GhostLockKind kind;
/// 会话标识；受理失败时为空串。
@override final  String sessionId;
/// 自上次块以来新增的输出，直接写屏。
@override final  String output;
/// 累积输出，只有终局块非空；判定依据就是它。
@override final  String log;
/// 退出码；`0` 完成，`1` 失败，`255` 原生 `pr_error`，`70` 脏竞争。
@override final  int exitCode;
/// 从受理到终局的耗时（毫秒）。
@override final  int durationMs;
/// 是否因本侧取消或超时停止读取；**不代表设备侧进程已停止**。
@override final  bool timedOut;
/// 受理失败原因码；受理成功时为空串。
@override final  String reason;

/// Create a copy of GhostLockOutcome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockOutcomeCopyWith<_GhostLockOutcome> get copyWith => __$GhostLockOutcomeCopyWithImpl<_GhostLockOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockOutcome&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.output, output) || other.output == output)&&(identical(other.log, log) || other.log == log)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,kind,sessionId,output,log,exitCode,durationMs,timedOut,reason);

@override
String toString() {
  return 'GhostLockOutcome(kind: $kind, sessionId: $sessionId, output: $output, log: $log, exitCode: $exitCode, durationMs: $durationMs, timedOut: $timedOut, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$GhostLockOutcomeCopyWith<$Res> implements $GhostLockOutcomeCopyWith<$Res> {
  factory _$GhostLockOutcomeCopyWith(_GhostLockOutcome value, $Res Function(_GhostLockOutcome) _then) = __$GhostLockOutcomeCopyWithImpl;
@override @useResult
$Res call({
 GhostLockKind kind, String sessionId, String output, String log, int exitCode, int durationMs, bool timedOut, String reason
});




}
/// @nodoc
class __$GhostLockOutcomeCopyWithImpl<$Res>
    implements _$GhostLockOutcomeCopyWith<$Res> {
  __$GhostLockOutcomeCopyWithImpl(this._self, this._then);

  final _GhostLockOutcome _self;
  final $Res Function(_GhostLockOutcome) _then;

/// Create a copy of GhostLockOutcome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? sessionId = null,Object? output = null,Object? log = null,Object? exitCode = null,Object? durationMs = null,Object? timedOut = null,Object? reason = null,}) {
  return _then(_GhostLockOutcome(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as GhostLockKind,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
