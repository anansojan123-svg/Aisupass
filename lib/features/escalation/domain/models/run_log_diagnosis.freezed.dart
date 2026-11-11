// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_log_diagnosis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RunLogDiagnosis {

 String get ruleId; String get stage; List<String> get evidence; int get exitCode;
/// Create a copy of RunLogDiagnosis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunLogDiagnosisCopyWith<RunLogDiagnosis> get copyWith => _$RunLogDiagnosisCopyWithImpl<RunLogDiagnosis>(this as RunLogDiagnosis, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunLogDiagnosis&&(identical(other.ruleId, ruleId) || other.ruleId == ruleId)&&(identical(other.stage, stage) || other.stage == stage)&&const DeepCollectionEquality().equals(other.evidence, evidence)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode));
}


@override
int get hashCode => Object.hash(runtimeType,ruleId,stage,const DeepCollectionEquality().hash(evidence),exitCode);

@override
String toString() {
  return 'RunLogDiagnosis(ruleId: $ruleId, stage: $stage, evidence: $evidence, exitCode: $exitCode)';
}


}

/// @nodoc
abstract mixin class $RunLogDiagnosisCopyWith<$Res>  {
  factory $RunLogDiagnosisCopyWith(RunLogDiagnosis value, $Res Function(RunLogDiagnosis) _then) = _$RunLogDiagnosisCopyWithImpl;
@useResult
$Res call({
 String ruleId, String stage, List<String> evidence, int exitCode
});




}
/// @nodoc
class _$RunLogDiagnosisCopyWithImpl<$Res>
    implements $RunLogDiagnosisCopyWith<$Res> {
  _$RunLogDiagnosisCopyWithImpl(this._self, this._then);

  final RunLogDiagnosis _self;
  final $Res Function(RunLogDiagnosis) _then;

/// Create a copy of RunLogDiagnosis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ruleId = null,Object? stage = null,Object? evidence = null,Object? exitCode = null,}) {
  return _then(_self.copyWith(
ruleId: null == ruleId ? _self.ruleId : ruleId // ignore: cast_nullable_to_non_nullable
as String,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<String>,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RunLogDiagnosis].
extension RunLogDiagnosisPatterns on RunLogDiagnosis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunLogDiagnosis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunLogDiagnosis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunLogDiagnosis value)  $default,){
final _that = this;
switch (_that) {
case _RunLogDiagnosis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunLogDiagnosis value)?  $default,){
final _that = this;
switch (_that) {
case _RunLogDiagnosis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ruleId,  String stage,  List<String> evidence,  int exitCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunLogDiagnosis() when $default != null:
return $default(_that.ruleId,_that.stage,_that.evidence,_that.exitCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ruleId,  String stage,  List<String> evidence,  int exitCode)  $default,) {final _that = this;
switch (_that) {
case _RunLogDiagnosis():
return $default(_that.ruleId,_that.stage,_that.evidence,_that.exitCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ruleId,  String stage,  List<String> evidence,  int exitCode)?  $default,) {final _that = this;
switch (_that) {
case _RunLogDiagnosis() when $default != null:
return $default(_that.ruleId,_that.stage,_that.evidence,_that.exitCode);case _:
  return null;

}
}

}

/// @nodoc


class _RunLogDiagnosis extends RunLogDiagnosis {
  const _RunLogDiagnosis({required this.ruleId, required this.stage, required this.evidence, required this.exitCode}): super._();
  

@override final  String ruleId;
@override final  String stage;
@override final  List<String> evidence;
@override final  int exitCode;

/// Create a copy of RunLogDiagnosis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunLogDiagnosisCopyWith<_RunLogDiagnosis> get copyWith => __$RunLogDiagnosisCopyWithImpl<_RunLogDiagnosis>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunLogDiagnosis&&(identical(other.ruleId, ruleId) || other.ruleId == ruleId)&&(identical(other.stage, stage) || other.stage == stage)&&const DeepCollectionEquality().equals(other.evidence, evidence)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode));
}


@override
int get hashCode => Object.hash(runtimeType,ruleId,stage,const DeepCollectionEquality().hash(evidence),exitCode);

@override
String toString() {
  return 'RunLogDiagnosis(ruleId: $ruleId, stage: $stage, evidence: $evidence, exitCode: $exitCode)';
}


}

/// @nodoc
abstract mixin class _$RunLogDiagnosisCopyWith<$Res> implements $RunLogDiagnosisCopyWith<$Res> {
  factory _$RunLogDiagnosisCopyWith(_RunLogDiagnosis value, $Res Function(_RunLogDiagnosis) _then) = __$RunLogDiagnosisCopyWithImpl;
@override @useResult
$Res call({
 String ruleId, String stage, List<String> evidence, int exitCode
});




}
/// @nodoc
class __$RunLogDiagnosisCopyWithImpl<$Res>
    implements _$RunLogDiagnosisCopyWith<$Res> {
  __$RunLogDiagnosisCopyWithImpl(this._self, this._then);

  final _RunLogDiagnosis _self;
  final $Res Function(_RunLogDiagnosis) _then;

/// Create a copy of RunLogDiagnosis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ruleId = null,Object? stage = null,Object? evidence = null,Object? exitCode = null,}) {
  return _then(_RunLogDiagnosis(
ruleId: null == ruleId ? _self.ruleId : ruleId // ignore: cast_nullable_to_non_nullable
as String,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<String>,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
