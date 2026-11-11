// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_log_meta_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RunLogMetaDto {

 String get fileName; int get runId; int get startedAt; String get result; int get exitCode; int get durationMs; int get lineCount; String get device; String get kernel; String get profile;
/// Create a copy of RunLogMetaDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunLogMetaDtoCopyWith<RunLogMetaDto> get copyWith => _$RunLogMetaDtoCopyWithImpl<RunLogMetaDto>(this as RunLogMetaDto, _$identity);

  /// Serializes this RunLogMetaDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunLogMetaDto&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.result, result) || other.result == result)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.lineCount, lineCount) || other.lineCount == lineCount)&&(identical(other.device, device) || other.device == device)&&(identical(other.kernel, kernel) || other.kernel == kernel)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,runId,startedAt,result,exitCode,durationMs,lineCount,device,kernel,profile);

@override
String toString() {
  return 'RunLogMetaDto(fileName: $fileName, runId: $runId, startedAt: $startedAt, result: $result, exitCode: $exitCode, durationMs: $durationMs, lineCount: $lineCount, device: $device, kernel: $kernel, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $RunLogMetaDtoCopyWith<$Res>  {
  factory $RunLogMetaDtoCopyWith(RunLogMetaDto value, $Res Function(RunLogMetaDto) _then) = _$RunLogMetaDtoCopyWithImpl;
@useResult
$Res call({
 String fileName, int runId, int startedAt, String result, int exitCode, int durationMs, int lineCount, String device, String kernel, String profile
});




}
/// @nodoc
class _$RunLogMetaDtoCopyWithImpl<$Res>
    implements $RunLogMetaDtoCopyWith<$Res> {
  _$RunLogMetaDtoCopyWithImpl(this._self, this._then);

  final RunLogMetaDto _self;
  final $Res Function(RunLogMetaDto) _then;

/// Create a copy of RunLogMetaDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? runId = null,Object? startedAt = null,Object? result = null,Object? exitCode = null,Object? durationMs = null,Object? lineCount = null,Object? device = null,Object? kernel = null,Object? profile = null,}) {
  return _then(_self.copyWith(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,lineCount: null == lineCount ? _self.lineCount : lineCount // ignore: cast_nullable_to_non_nullable
as int,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,kernel: null == kernel ? _self.kernel : kernel // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RunLogMetaDto].
extension RunLogMetaDtoPatterns on RunLogMetaDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunLogMetaDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunLogMetaDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunLogMetaDto value)  $default,){
final _that = this;
switch (_that) {
case _RunLogMetaDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunLogMetaDto value)?  $default,){
final _that = this;
switch (_that) {
case _RunLogMetaDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileName,  int runId,  int startedAt,  String result,  int exitCode,  int durationMs,  int lineCount,  String device,  String kernel,  String profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunLogMetaDto() when $default != null:
return $default(_that.fileName,_that.runId,_that.startedAt,_that.result,_that.exitCode,_that.durationMs,_that.lineCount,_that.device,_that.kernel,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileName,  int runId,  int startedAt,  String result,  int exitCode,  int durationMs,  int lineCount,  String device,  String kernel,  String profile)  $default,) {final _that = this;
switch (_that) {
case _RunLogMetaDto():
return $default(_that.fileName,_that.runId,_that.startedAt,_that.result,_that.exitCode,_that.durationMs,_that.lineCount,_that.device,_that.kernel,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileName,  int runId,  int startedAt,  String result,  int exitCode,  int durationMs,  int lineCount,  String device,  String kernel,  String profile)?  $default,) {final _that = this;
switch (_that) {
case _RunLogMetaDto() when $default != null:
return $default(_that.fileName,_that.runId,_that.startedAt,_that.result,_that.exitCode,_that.durationMs,_that.lineCount,_that.device,_that.kernel,_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RunLogMetaDto extends RunLogMetaDto {
  const _RunLogMetaDto({this.fileName = '', this.runId = 0, this.startedAt = 0, this.result = '', this.exitCode = -1, this.durationMs = 0, this.lineCount = -1, this.device = '', this.kernel = '', this.profile = ''}): super._();
  factory _RunLogMetaDto.fromJson(Map<String, dynamic> json) => _$RunLogMetaDtoFromJson(json);

@override@JsonKey() final  String fileName;
@override@JsonKey() final  int runId;
@override@JsonKey() final  int startedAt;
@override@JsonKey() final  String result;
@override@JsonKey() final  int exitCode;
@override@JsonKey() final  int durationMs;
@override@JsonKey() final  int lineCount;
@override@JsonKey() final  String device;
@override@JsonKey() final  String kernel;
@override@JsonKey() final  String profile;

/// Create a copy of RunLogMetaDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunLogMetaDtoCopyWith<_RunLogMetaDto> get copyWith => __$RunLogMetaDtoCopyWithImpl<_RunLogMetaDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RunLogMetaDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunLogMetaDto&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.result, result) || other.result == result)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.lineCount, lineCount) || other.lineCount == lineCount)&&(identical(other.device, device) || other.device == device)&&(identical(other.kernel, kernel) || other.kernel == kernel)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,runId,startedAt,result,exitCode,durationMs,lineCount,device,kernel,profile);

@override
String toString() {
  return 'RunLogMetaDto(fileName: $fileName, runId: $runId, startedAt: $startedAt, result: $result, exitCode: $exitCode, durationMs: $durationMs, lineCount: $lineCount, device: $device, kernel: $kernel, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$RunLogMetaDtoCopyWith<$Res> implements $RunLogMetaDtoCopyWith<$Res> {
  factory _$RunLogMetaDtoCopyWith(_RunLogMetaDto value, $Res Function(_RunLogMetaDto) _then) = __$RunLogMetaDtoCopyWithImpl;
@override @useResult
$Res call({
 String fileName, int runId, int startedAt, String result, int exitCode, int durationMs, int lineCount, String device, String kernel, String profile
});




}
/// @nodoc
class __$RunLogMetaDtoCopyWithImpl<$Res>
    implements _$RunLogMetaDtoCopyWith<$Res> {
  __$RunLogMetaDtoCopyWithImpl(this._self, this._then);

  final _RunLogMetaDto _self;
  final $Res Function(_RunLogMetaDto) _then;

/// Create a copy of RunLogMetaDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? runId = null,Object? startedAt = null,Object? result = null,Object? exitCode = null,Object? durationMs = null,Object? lineCount = null,Object? device = null,Object? kernel = null,Object? profile = null,}) {
  return _then(_RunLogMetaDto(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,lineCount: null == lineCount ? _self.lineCount : lineCount // ignore: cast_nullable_to_non_nullable
as int,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,kernel: null == kernel ? _self.kernel : kernel // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
