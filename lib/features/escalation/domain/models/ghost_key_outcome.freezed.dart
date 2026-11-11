// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_key_outcome.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostKeyOutcome {

/// 终局分类；[GhostKeyKind.running] 表示还有后续块。
 GhostKeyKind get kind;/// 自上次块以来新增的输出（stdout 与 stderr 合并），直接写屏。
 String get output;/// 累积输出，只有终局块非空；判定依据就是它。
 String get log;/// 五阶段总进度，`0`～`1`。
 double get fraction;/// 五阶段状态，长度恒为 5，下标对应 `GhostKeyStage.index`。
 List<GhostKeyStageStatus> get stageStatuses;/// 五阶段耗时（毫秒），长度恒为 5，下标同上。
 List<int> get stageDurations;/// 会话级退出码；`-1` 表示没拿到。
 int get exitCode;/// 是否因超时或本侧取消而掐断了某个阶段。
 bool get timedOut;/// 从受理到本次轮询的耗时（毫秒）。
 int get durationMs;/// 原生侧异常类名，或 `"<stage>: exit frame missing"`；空串表示无异常。
 String get failure;/// 被拒原因码；空串表示已受理。
 String get reason;
/// Create a copy of GhostKeyOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostKeyOutcomeCopyWith<GhostKeyOutcome> get copyWith => _$GhostKeyOutcomeCopyWithImpl<GhostKeyOutcome>(this as GhostKeyOutcome, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostKeyOutcome&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.output, output) || other.output == output)&&(identical(other.log, log) || other.log == log)&&(identical(other.fraction, fraction) || other.fraction == fraction)&&const DeepCollectionEquality().equals(other.stageStatuses, stageStatuses)&&const DeepCollectionEquality().equals(other.stageDurations, stageDurations)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,kind,output,log,fraction,const DeepCollectionEquality().hash(stageStatuses),const DeepCollectionEquality().hash(stageDurations),exitCode,timedOut,durationMs,failure,reason);

@override
String toString() {
  return 'GhostKeyOutcome(kind: $kind, output: $output, log: $log, fraction: $fraction, stageStatuses: $stageStatuses, stageDurations: $stageDurations, exitCode: $exitCode, timedOut: $timedOut, durationMs: $durationMs, failure: $failure, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $GhostKeyOutcomeCopyWith<$Res>  {
  factory $GhostKeyOutcomeCopyWith(GhostKeyOutcome value, $Res Function(GhostKeyOutcome) _then) = _$GhostKeyOutcomeCopyWithImpl;
@useResult
$Res call({
 GhostKeyKind kind, String output, String log, double fraction, List<GhostKeyStageStatus> stageStatuses, List<int> stageDurations, int exitCode, bool timedOut, int durationMs, String failure, String reason
});




}
/// @nodoc
class _$GhostKeyOutcomeCopyWithImpl<$Res>
    implements $GhostKeyOutcomeCopyWith<$Res> {
  _$GhostKeyOutcomeCopyWithImpl(this._self, this._then);

  final GhostKeyOutcome _self;
  final $Res Function(GhostKeyOutcome) _then;

/// Create a copy of GhostKeyOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? output = null,Object? log = null,Object? fraction = null,Object? stageStatuses = null,Object? stageDurations = null,Object? exitCode = null,Object? timedOut = null,Object? durationMs = null,Object? failure = null,Object? reason = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as GhostKeyKind,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,fraction: null == fraction ? _self.fraction : fraction // ignore: cast_nullable_to_non_nullable
as double,stageStatuses: null == stageStatuses ? _self.stageStatuses : stageStatuses // ignore: cast_nullable_to_non_nullable
as List<GhostKeyStageStatus>,stageDurations: null == stageDurations ? _self.stageDurations : stageDurations // ignore: cast_nullable_to_non_nullable
as List<int>,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostKeyOutcome].
extension GhostKeyOutcomePatterns on GhostKeyOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostKeyOutcome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostKeyOutcome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostKeyOutcome value)  $default,){
final _that = this;
switch (_that) {
case _GhostKeyOutcome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostKeyOutcome value)?  $default,){
final _that = this;
switch (_that) {
case _GhostKeyOutcome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GhostKeyKind kind,  String output,  String log,  double fraction,  List<GhostKeyStageStatus> stageStatuses,  List<int> stageDurations,  int exitCode,  bool timedOut,  int durationMs,  String failure,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostKeyOutcome() when $default != null:
return $default(_that.kind,_that.output,_that.log,_that.fraction,_that.stageStatuses,_that.stageDurations,_that.exitCode,_that.timedOut,_that.durationMs,_that.failure,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GhostKeyKind kind,  String output,  String log,  double fraction,  List<GhostKeyStageStatus> stageStatuses,  List<int> stageDurations,  int exitCode,  bool timedOut,  int durationMs,  String failure,  String reason)  $default,) {final _that = this;
switch (_that) {
case _GhostKeyOutcome():
return $default(_that.kind,_that.output,_that.log,_that.fraction,_that.stageStatuses,_that.stageDurations,_that.exitCode,_that.timedOut,_that.durationMs,_that.failure,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GhostKeyKind kind,  String output,  String log,  double fraction,  List<GhostKeyStageStatus> stageStatuses,  List<int> stageDurations,  int exitCode,  bool timedOut,  int durationMs,  String failure,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _GhostKeyOutcome() when $default != null:
return $default(_that.kind,_that.output,_that.log,_that.fraction,_that.stageStatuses,_that.stageDurations,_that.exitCode,_that.timedOut,_that.durationMs,_that.failure,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _GhostKeyOutcome extends GhostKeyOutcome {
  const _GhostKeyOutcome({required this.kind, required this.output, required this.log, required this.fraction, required this.stageStatuses, required this.stageDurations, required this.exitCode, required this.timedOut, required this.durationMs, required this.failure, required this.reason}): super._();
  

/// 终局分类；[GhostKeyKind.running] 表示还有后续块。
@override final  GhostKeyKind kind;
/// 自上次块以来新增的输出（stdout 与 stderr 合并），直接写屏。
@override final  String output;
/// 累积输出，只有终局块非空；判定依据就是它。
@override final  String log;
/// 五阶段总进度，`0`～`1`。
@override final  double fraction;
/// 五阶段状态，长度恒为 5，下标对应 `GhostKeyStage.index`。
@override final  List<GhostKeyStageStatus> stageStatuses;
/// 五阶段耗时（毫秒），长度恒为 5，下标同上。
@override final  List<int> stageDurations;
/// 会话级退出码；`-1` 表示没拿到。
@override final  int exitCode;
/// 是否因超时或本侧取消而掐断了某个阶段。
@override final  bool timedOut;
/// 从受理到本次轮询的耗时（毫秒）。
@override final  int durationMs;
/// 原生侧异常类名，或 `"<stage>: exit frame missing"`；空串表示无异常。
@override final  String failure;
/// 被拒原因码；空串表示已受理。
@override final  String reason;

/// Create a copy of GhostKeyOutcome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostKeyOutcomeCopyWith<_GhostKeyOutcome> get copyWith => __$GhostKeyOutcomeCopyWithImpl<_GhostKeyOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostKeyOutcome&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.output, output) || other.output == output)&&(identical(other.log, log) || other.log == log)&&(identical(other.fraction, fraction) || other.fraction == fraction)&&const DeepCollectionEquality().equals(other.stageStatuses, stageStatuses)&&const DeepCollectionEquality().equals(other.stageDurations, stageDurations)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,kind,output,log,fraction,const DeepCollectionEquality().hash(stageStatuses),const DeepCollectionEquality().hash(stageDurations),exitCode,timedOut,durationMs,failure,reason);

@override
String toString() {
  return 'GhostKeyOutcome(kind: $kind, output: $output, log: $log, fraction: $fraction, stageStatuses: $stageStatuses, stageDurations: $stageDurations, exitCode: $exitCode, timedOut: $timedOut, durationMs: $durationMs, failure: $failure, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$GhostKeyOutcomeCopyWith<$Res> implements $GhostKeyOutcomeCopyWith<$Res> {
  factory _$GhostKeyOutcomeCopyWith(_GhostKeyOutcome value, $Res Function(_GhostKeyOutcome) _then) = __$GhostKeyOutcomeCopyWithImpl;
@override @useResult
$Res call({
 GhostKeyKind kind, String output, String log, double fraction, List<GhostKeyStageStatus> stageStatuses, List<int> stageDurations, int exitCode, bool timedOut, int durationMs, String failure, String reason
});




}
/// @nodoc
class __$GhostKeyOutcomeCopyWithImpl<$Res>
    implements _$GhostKeyOutcomeCopyWith<$Res> {
  __$GhostKeyOutcomeCopyWithImpl(this._self, this._then);

  final _GhostKeyOutcome _self;
  final $Res Function(_GhostKeyOutcome) _then;

/// Create a copy of GhostKeyOutcome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? output = null,Object? log = null,Object? fraction = null,Object? stageStatuses = null,Object? stageDurations = null,Object? exitCode = null,Object? timedOut = null,Object? durationMs = null,Object? failure = null,Object? reason = null,}) {
  return _then(_GhostKeyOutcome(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as GhostKeyKind,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,fraction: null == fraction ? _self.fraction : fraction // ignore: cast_nullable_to_non_nullable
as double,stageStatuses: null == stageStatuses ? _self.stageStatuses : stageStatuses // ignore: cast_nullable_to_non_nullable
as List<GhostKeyStageStatus>,stageDurations: null == stageDurations ? _self.stageDurations : stageDurations // ignore: cast_nullable_to_non_nullable
as List<int>,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
