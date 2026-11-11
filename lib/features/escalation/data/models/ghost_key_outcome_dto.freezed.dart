// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_key_outcome_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GhostKeyOutcomeDto {

 String get sessionId; String get output; int get exitCode; bool get timedOut; int get durationMs; String get failure; GhostKeyKind get kind; String get log; String get reason; double get fraction; List<GhostKeyStageStatus> get stageStatuses; List<int> get stageDurations;
/// Create a copy of GhostKeyOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostKeyOutcomeDtoCopyWith<GhostKeyOutcomeDto> get copyWith => _$GhostKeyOutcomeDtoCopyWithImpl<GhostKeyOutcomeDto>(this as GhostKeyOutcomeDto, _$identity);

  /// Serializes this GhostKeyOutcomeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostKeyOutcomeDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.output, output) || other.output == output)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.log, log) || other.log == log)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.fraction, fraction) || other.fraction == fraction)&&const DeepCollectionEquality().equals(other.stageStatuses, stageStatuses)&&const DeepCollectionEquality().equals(other.stageDurations, stageDurations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,output,exitCode,timedOut,durationMs,failure,kind,log,reason,fraction,const DeepCollectionEquality().hash(stageStatuses),const DeepCollectionEquality().hash(stageDurations));

@override
String toString() {
  return 'GhostKeyOutcomeDto(sessionId: $sessionId, output: $output, exitCode: $exitCode, timedOut: $timedOut, durationMs: $durationMs, failure: $failure, kind: $kind, log: $log, reason: $reason, fraction: $fraction, stageStatuses: $stageStatuses, stageDurations: $stageDurations)';
}


}

/// @nodoc
abstract mixin class $GhostKeyOutcomeDtoCopyWith<$Res>  {
  factory $GhostKeyOutcomeDtoCopyWith(GhostKeyOutcomeDto value, $Res Function(GhostKeyOutcomeDto) _then) = _$GhostKeyOutcomeDtoCopyWithImpl;
@useResult
$Res call({
 String sessionId, String output, int exitCode, bool timedOut, int durationMs, String failure, GhostKeyKind kind, String log, String reason, double fraction, List<GhostKeyStageStatus> stageStatuses, List<int> stageDurations
});




}
/// @nodoc
class _$GhostKeyOutcomeDtoCopyWithImpl<$Res>
    implements $GhostKeyOutcomeDtoCopyWith<$Res> {
  _$GhostKeyOutcomeDtoCopyWithImpl(this._self, this._then);

  final GhostKeyOutcomeDto _self;
  final $Res Function(GhostKeyOutcomeDto) _then;

/// Create a copy of GhostKeyOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? output = null,Object? exitCode = null,Object? timedOut = null,Object? durationMs = null,Object? failure = null,Object? kind = null,Object? log = null,Object? reason = null,Object? fraction = null,Object? stageStatuses = null,Object? stageDurations = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as GhostKeyKind,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,fraction: null == fraction ? _self.fraction : fraction // ignore: cast_nullable_to_non_nullable
as double,stageStatuses: null == stageStatuses ? _self.stageStatuses : stageStatuses // ignore: cast_nullable_to_non_nullable
as List<GhostKeyStageStatus>,stageDurations: null == stageDurations ? _self.stageDurations : stageDurations // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostKeyOutcomeDto].
extension GhostKeyOutcomeDtoPatterns on GhostKeyOutcomeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostKeyOutcomeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostKeyOutcomeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostKeyOutcomeDto value)  $default,){
final _that = this;
switch (_that) {
case _GhostKeyOutcomeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostKeyOutcomeDto value)?  $default,){
final _that = this;
switch (_that) {
case _GhostKeyOutcomeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String output,  int exitCode,  bool timedOut,  int durationMs,  String failure,  GhostKeyKind kind,  String log,  String reason,  double fraction,  List<GhostKeyStageStatus> stageStatuses,  List<int> stageDurations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostKeyOutcomeDto() when $default != null:
return $default(_that.sessionId,_that.output,_that.exitCode,_that.timedOut,_that.durationMs,_that.failure,_that.kind,_that.log,_that.reason,_that.fraction,_that.stageStatuses,_that.stageDurations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String output,  int exitCode,  bool timedOut,  int durationMs,  String failure,  GhostKeyKind kind,  String log,  String reason,  double fraction,  List<GhostKeyStageStatus> stageStatuses,  List<int> stageDurations)  $default,) {final _that = this;
switch (_that) {
case _GhostKeyOutcomeDto():
return $default(_that.sessionId,_that.output,_that.exitCode,_that.timedOut,_that.durationMs,_that.failure,_that.kind,_that.log,_that.reason,_that.fraction,_that.stageStatuses,_that.stageDurations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String output,  int exitCode,  bool timedOut,  int durationMs,  String failure,  GhostKeyKind kind,  String log,  String reason,  double fraction,  List<GhostKeyStageStatus> stageStatuses,  List<int> stageDurations)?  $default,) {final _that = this;
switch (_that) {
case _GhostKeyOutcomeDto() when $default != null:
return $default(_that.sessionId,_that.output,_that.exitCode,_that.timedOut,_that.durationMs,_that.failure,_that.kind,_that.log,_that.reason,_that.fraction,_that.stageStatuses,_that.stageDurations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GhostKeyOutcomeDto extends GhostKeyOutcomeDto {
  const _GhostKeyOutcomeDto({this.sessionId = '', this.output = '', this.exitCode = -1, this.timedOut = false, this.durationMs = 0, this.failure = '', this.kind = GhostKeyKind.running, this.log = '', this.reason = '', this.fraction = 0.0, this.stageStatuses = const <GhostKeyStageStatus>[], this.stageDurations = const <int>[]}): super._();
  factory _GhostKeyOutcomeDto.fromJson(Map<String, dynamic> json) => _$GhostKeyOutcomeDtoFromJson(json);

@override@JsonKey() final  String sessionId;
@override@JsonKey() final  String output;
@override@JsonKey() final  int exitCode;
@override@JsonKey() final  bool timedOut;
@override@JsonKey() final  int durationMs;
@override@JsonKey() final  String failure;
@override@JsonKey() final  GhostKeyKind kind;
@override@JsonKey() final  String log;
@override@JsonKey() final  String reason;
@override@JsonKey() final  double fraction;
@override@JsonKey() final  List<GhostKeyStageStatus> stageStatuses;
@override@JsonKey() final  List<int> stageDurations;

/// Create a copy of GhostKeyOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostKeyOutcomeDtoCopyWith<_GhostKeyOutcomeDto> get copyWith => __$GhostKeyOutcomeDtoCopyWithImpl<_GhostKeyOutcomeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GhostKeyOutcomeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostKeyOutcomeDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.output, output) || other.output == output)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.log, log) || other.log == log)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.fraction, fraction) || other.fraction == fraction)&&const DeepCollectionEquality().equals(other.stageStatuses, stageStatuses)&&const DeepCollectionEquality().equals(other.stageDurations, stageDurations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,output,exitCode,timedOut,durationMs,failure,kind,log,reason,fraction,const DeepCollectionEquality().hash(stageStatuses),const DeepCollectionEquality().hash(stageDurations));

@override
String toString() {
  return 'GhostKeyOutcomeDto(sessionId: $sessionId, output: $output, exitCode: $exitCode, timedOut: $timedOut, durationMs: $durationMs, failure: $failure, kind: $kind, log: $log, reason: $reason, fraction: $fraction, stageStatuses: $stageStatuses, stageDurations: $stageDurations)';
}


}

/// @nodoc
abstract mixin class _$GhostKeyOutcomeDtoCopyWith<$Res> implements $GhostKeyOutcomeDtoCopyWith<$Res> {
  factory _$GhostKeyOutcomeDtoCopyWith(_GhostKeyOutcomeDto value, $Res Function(_GhostKeyOutcomeDto) _then) = __$GhostKeyOutcomeDtoCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String output, int exitCode, bool timedOut, int durationMs, String failure, GhostKeyKind kind, String log, String reason, double fraction, List<GhostKeyStageStatus> stageStatuses, List<int> stageDurations
});




}
/// @nodoc
class __$GhostKeyOutcomeDtoCopyWithImpl<$Res>
    implements _$GhostKeyOutcomeDtoCopyWith<$Res> {
  __$GhostKeyOutcomeDtoCopyWithImpl(this._self, this._then);

  final _GhostKeyOutcomeDto _self;
  final $Res Function(_GhostKeyOutcomeDto) _then;

/// Create a copy of GhostKeyOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? output = null,Object? exitCode = null,Object? timedOut = null,Object? durationMs = null,Object? failure = null,Object? kind = null,Object? log = null,Object? reason = null,Object? fraction = null,Object? stageStatuses = null,Object? stageDurations = null,}) {
  return _then(_GhostKeyOutcomeDto(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as GhostKeyKind,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,fraction: null == fraction ? _self.fraction : fraction // ignore: cast_nullable_to_non_nullable
as double,stageStatuses: null == stageStatuses ? _self.stageStatuses : stageStatuses // ignore: cast_nullable_to_non_nullable
as List<GhostKeyStageStatus>,stageDurations: null == stageDurations ? _self.stageDurations : stageDurations // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
