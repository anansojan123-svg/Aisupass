// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_log_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RunLogMeta {

 String get fileName; int get runId; int get startedAt; RunLogResult get result; int get exitCode; int get durationMs; int get lineCount; String get device; String get kernel; String get profile;
/// Create a copy of RunLogMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunLogMetaCopyWith<RunLogMeta> get copyWith => _$RunLogMetaCopyWithImpl<RunLogMeta>(this as RunLogMeta, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunLogMeta&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.result, result) || other.result == result)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.lineCount, lineCount) || other.lineCount == lineCount)&&(identical(other.device, device) || other.device == device)&&(identical(other.kernel, kernel) || other.kernel == kernel)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,runId,startedAt,result,exitCode,durationMs,lineCount,device,kernel,profile);

@override
String toString() {
  return 'RunLogMeta(fileName: $fileName, runId: $runId, startedAt: $startedAt, result: $result, exitCode: $exitCode, durationMs: $durationMs, lineCount: $lineCount, device: $device, kernel: $kernel, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $RunLogMetaCopyWith<$Res>  {
  factory $RunLogMetaCopyWith(RunLogMeta value, $Res Function(RunLogMeta) _then) = _$RunLogMetaCopyWithImpl;
@useResult
$Res call({
 String fileName, int runId, int startedAt, RunLogResult result, int exitCode, int durationMs, int lineCount, String device, String kernel, String profile
});




}
/// @nodoc
class _$RunLogMetaCopyWithImpl<$Res>
    implements $RunLogMetaCopyWith<$Res> {
  _$RunLogMetaCopyWithImpl(this._self, this._then);

  final RunLogMeta _self;
  final $Res Function(RunLogMeta) _then;

/// Create a copy of RunLogMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? runId = null,Object? startedAt = null,Object? result = null,Object? exitCode = null,Object? durationMs = null,Object? lineCount = null,Object? device = null,Object? kernel = null,Object? profile = null,}) {
  return _then(_self.copyWith(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as RunLogResult,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,lineCount: null == lineCount ? _self.lineCount : lineCount // ignore: cast_nullable_to_non_nullable
as int,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,kernel: null == kernel ? _self.kernel : kernel // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RunLogMeta].
extension RunLogMetaPatterns on RunLogMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunLogMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunLogMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunLogMeta value)  $default,){
final _that = this;
switch (_that) {
case _RunLogMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunLogMeta value)?  $default,){
final _that = this;
switch (_that) {
case _RunLogMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileName,  int runId,  int startedAt,  RunLogResult result,  int exitCode,  int durationMs,  int lineCount,  String device,  String kernel,  String profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunLogMeta() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileName,  int runId,  int startedAt,  RunLogResult result,  int exitCode,  int durationMs,  int lineCount,  String device,  String kernel,  String profile)  $default,) {final _that = this;
switch (_that) {
case _RunLogMeta():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileName,  int runId,  int startedAt,  RunLogResult result,  int exitCode,  int durationMs,  int lineCount,  String device,  String kernel,  String profile)?  $default,) {final _that = this;
switch (_that) {
case _RunLogMeta() when $default != null:
return $default(_that.fileName,_that.runId,_that.startedAt,_that.result,_that.exitCode,_that.durationMs,_that.lineCount,_that.device,_that.kernel,_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class _RunLogMeta extends RunLogMeta {
  const _RunLogMeta({required this.fileName, required this.runId, required this.startedAt, required this.result, required this.exitCode, required this.durationMs, required this.lineCount, required this.device, required this.kernel, required this.profile}): super._();
  

@override final  String fileName;
@override final  int runId;
@override final  int startedAt;
@override final  RunLogResult result;
@override final  int exitCode;
@override final  int durationMs;
@override final  int lineCount;
@override final  String device;
@override final  String kernel;
@override final  String profile;

/// Create a copy of RunLogMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunLogMetaCopyWith<_RunLogMeta> get copyWith => __$RunLogMetaCopyWithImpl<_RunLogMeta>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunLogMeta&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.result, result) || other.result == result)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.lineCount, lineCount) || other.lineCount == lineCount)&&(identical(other.device, device) || other.device == device)&&(identical(other.kernel, kernel) || other.kernel == kernel)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,runId,startedAt,result,exitCode,durationMs,lineCount,device,kernel,profile);

@override
String toString() {
  return 'RunLogMeta(fileName: $fileName, runId: $runId, startedAt: $startedAt, result: $result, exitCode: $exitCode, durationMs: $durationMs, lineCount: $lineCount, device: $device, kernel: $kernel, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$RunLogMetaCopyWith<$Res> implements $RunLogMetaCopyWith<$Res> {
  factory _$RunLogMetaCopyWith(_RunLogMeta value, $Res Function(_RunLogMeta) _then) = __$RunLogMetaCopyWithImpl;
@override @useResult
$Res call({
 String fileName, int runId, int startedAt, RunLogResult result, int exitCode, int durationMs, int lineCount, String device, String kernel, String profile
});




}
/// @nodoc
class __$RunLogMetaCopyWithImpl<$Res>
    implements _$RunLogMetaCopyWith<$Res> {
  __$RunLogMetaCopyWithImpl(this._self, this._then);

  final _RunLogMeta _self;
  final $Res Function(_RunLogMeta) _then;

/// Create a copy of RunLogMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? runId = null,Object? startedAt = null,Object? result = null,Object? exitCode = null,Object? durationMs = null,Object? lineCount = null,Object? device = null,Object? kernel = null,Object? profile = null,}) {
  return _then(_RunLogMeta(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as int,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as RunLogResult,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
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
