// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_log_diagnosis_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RunLogDiagnosisDto {

 String get ruleId; String get stage; List<String> get evidence; int get exitCode;
/// Create a copy of RunLogDiagnosisDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunLogDiagnosisDtoCopyWith<RunLogDiagnosisDto> get copyWith => _$RunLogDiagnosisDtoCopyWithImpl<RunLogDiagnosisDto>(this as RunLogDiagnosisDto, _$identity);

  /// Serializes this RunLogDiagnosisDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunLogDiagnosisDto&&(identical(other.ruleId, ruleId) || other.ruleId == ruleId)&&(identical(other.stage, stage) || other.stage == stage)&&const DeepCollectionEquality().equals(other.evidence, evidence)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ruleId,stage,const DeepCollectionEquality().hash(evidence),exitCode);

@override
String toString() {
  return 'RunLogDiagnosisDto(ruleId: $ruleId, stage: $stage, evidence: $evidence, exitCode: $exitCode)';
}


}

/// @nodoc
abstract mixin class $RunLogDiagnosisDtoCopyWith<$Res>  {
  factory $RunLogDiagnosisDtoCopyWith(RunLogDiagnosisDto value, $Res Function(RunLogDiagnosisDto) _then) = _$RunLogDiagnosisDtoCopyWithImpl;
@useResult
$Res call({
 String ruleId, String stage, List<String> evidence, int exitCode
});




}
/// @nodoc
class _$RunLogDiagnosisDtoCopyWithImpl<$Res>
    implements $RunLogDiagnosisDtoCopyWith<$Res> {
  _$RunLogDiagnosisDtoCopyWithImpl(this._self, this._then);

  final RunLogDiagnosisDto _self;
  final $Res Function(RunLogDiagnosisDto) _then;

/// Create a copy of RunLogDiagnosisDto
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


/// Adds pattern-matching-related methods to [RunLogDiagnosisDto].
extension RunLogDiagnosisDtoPatterns on RunLogDiagnosisDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunLogDiagnosisDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunLogDiagnosisDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunLogDiagnosisDto value)  $default,){
final _that = this;
switch (_that) {
case _RunLogDiagnosisDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunLogDiagnosisDto value)?  $default,){
final _that = this;
switch (_that) {
case _RunLogDiagnosisDto() when $default != null:
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
case _RunLogDiagnosisDto() when $default != null:
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
case _RunLogDiagnosisDto():
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
case _RunLogDiagnosisDto() when $default != null:
return $default(_that.ruleId,_that.stage,_that.evidence,_that.exitCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RunLogDiagnosisDto extends RunLogDiagnosisDto {
  const _RunLogDiagnosisDto({this.ruleId = '', this.stage = '', this.evidence = const <String>[], this.exitCode = -1}): super._();
  factory _RunLogDiagnosisDto.fromJson(Map<String, dynamic> json) => _$RunLogDiagnosisDtoFromJson(json);

@override@JsonKey() final  String ruleId;
@override@JsonKey() final  String stage;
@override@JsonKey() final  List<String> evidence;
@override@JsonKey() final  int exitCode;

/// Create a copy of RunLogDiagnosisDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunLogDiagnosisDtoCopyWith<_RunLogDiagnosisDto> get copyWith => __$RunLogDiagnosisDtoCopyWithImpl<_RunLogDiagnosisDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RunLogDiagnosisDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunLogDiagnosisDto&&(identical(other.ruleId, ruleId) || other.ruleId == ruleId)&&(identical(other.stage, stage) || other.stage == stage)&&const DeepCollectionEquality().equals(other.evidence, evidence)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ruleId,stage,const DeepCollectionEquality().hash(evidence),exitCode);

@override
String toString() {
  return 'RunLogDiagnosisDto(ruleId: $ruleId, stage: $stage, evidence: $evidence, exitCode: $exitCode)';
}


}

/// @nodoc
abstract mixin class _$RunLogDiagnosisDtoCopyWith<$Res> implements $RunLogDiagnosisDtoCopyWith<$Res> {
  factory _$RunLogDiagnosisDtoCopyWith(_RunLogDiagnosisDto value, $Res Function(_RunLogDiagnosisDto) _then) = __$RunLogDiagnosisDtoCopyWithImpl;
@override @useResult
$Res call({
 String ruleId, String stage, List<String> evidence, int exitCode
});




}
/// @nodoc
class __$RunLogDiagnosisDtoCopyWithImpl<$Res>
    implements _$RunLogDiagnosisDtoCopyWith<$Res> {
  __$RunLogDiagnosisDtoCopyWithImpl(this._self, this._then);

  final _RunLogDiagnosisDto _self;
  final $Res Function(_RunLogDiagnosisDto) _then;

/// Create a copy of RunLogDiagnosisDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ruleId = null,Object? stage = null,Object? evidence = null,Object? exitCode = null,}) {
  return _then(_RunLogDiagnosisDto(
ruleId: null == ruleId ? _self.ruleId : ruleId // ignore: cast_nullable_to_non_nullable
as String,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<String>,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
