// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_import_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostLockImportResult {

/// 是否成功。
 bool get ok;/// 生成的 profile 对应的内核 release。
 String get release;/// 落盘文件名；失败为空串。
 String get fileName;/// 失败原因码；成功为空串。
 String get reason;/// 需要用户确认覆盖。
 bool get requiresOverwrite;
/// Create a copy of GhostLockImportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockImportResultCopyWith<GhostLockImportResult> get copyWith => _$GhostLockImportResultCopyWithImpl<GhostLockImportResult>(this as GhostLockImportResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockImportResult&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.requiresOverwrite, requiresOverwrite) || other.requiresOverwrite == requiresOverwrite));
}


@override
int get hashCode => Object.hash(runtimeType,ok,release,fileName,reason,requiresOverwrite);

@override
String toString() {
  return 'GhostLockImportResult(ok: $ok, release: $release, fileName: $fileName, reason: $reason, requiresOverwrite: $requiresOverwrite)';
}


}

/// @nodoc
abstract mixin class $GhostLockImportResultCopyWith<$Res>  {
  factory $GhostLockImportResultCopyWith(GhostLockImportResult value, $Res Function(GhostLockImportResult) _then) = _$GhostLockImportResultCopyWithImpl;
@useResult
$Res call({
 bool ok, String release, String fileName, String reason, bool requiresOverwrite
});




}
/// @nodoc
class _$GhostLockImportResultCopyWithImpl<$Res>
    implements $GhostLockImportResultCopyWith<$Res> {
  _$GhostLockImportResultCopyWithImpl(this._self, this._then);

  final GhostLockImportResult _self;
  final $Res Function(GhostLockImportResult) _then;

/// Create a copy of GhostLockImportResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? release = null,Object? fileName = null,Object? reason = null,Object? requiresOverwrite = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,requiresOverwrite: null == requiresOverwrite ? _self.requiresOverwrite : requiresOverwrite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockImportResult].
extension GhostLockImportResultPatterns on GhostLockImportResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockImportResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockImportResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockImportResult value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockImportResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockImportResult value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockImportResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String release,  String fileName,  String reason,  bool requiresOverwrite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockImportResult() when $default != null:
return $default(_that.ok,_that.release,_that.fileName,_that.reason,_that.requiresOverwrite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String release,  String fileName,  String reason,  bool requiresOverwrite)  $default,) {final _that = this;
switch (_that) {
case _GhostLockImportResult():
return $default(_that.ok,_that.release,_that.fileName,_that.reason,_that.requiresOverwrite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String release,  String fileName,  String reason,  bool requiresOverwrite)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockImportResult() when $default != null:
return $default(_that.ok,_that.release,_that.fileName,_that.reason,_that.requiresOverwrite);case _:
  return null;

}
}

}

/// @nodoc


class _GhostLockImportResult extends GhostLockImportResult {
  const _GhostLockImportResult({required this.ok, required this.release, required this.fileName, required this.reason, required this.requiresOverwrite}): super._();
  

/// 是否成功。
@override final  bool ok;
/// 生成的 profile 对应的内核 release。
@override final  String release;
/// 落盘文件名；失败为空串。
@override final  String fileName;
/// 失败原因码；成功为空串。
@override final  String reason;
/// 需要用户确认覆盖。
@override final  bool requiresOverwrite;

/// Create a copy of GhostLockImportResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockImportResultCopyWith<_GhostLockImportResult> get copyWith => __$GhostLockImportResultCopyWithImpl<_GhostLockImportResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockImportResult&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.requiresOverwrite, requiresOverwrite) || other.requiresOverwrite == requiresOverwrite));
}


@override
int get hashCode => Object.hash(runtimeType,ok,release,fileName,reason,requiresOverwrite);

@override
String toString() {
  return 'GhostLockImportResult(ok: $ok, release: $release, fileName: $fileName, reason: $reason, requiresOverwrite: $requiresOverwrite)';
}


}

/// @nodoc
abstract mixin class _$GhostLockImportResultCopyWith<$Res> implements $GhostLockImportResultCopyWith<$Res> {
  factory _$GhostLockImportResultCopyWith(_GhostLockImportResult value, $Res Function(_GhostLockImportResult) _then) = __$GhostLockImportResultCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String release, String fileName, String reason, bool requiresOverwrite
});




}
/// @nodoc
class __$GhostLockImportResultCopyWithImpl<$Res>
    implements _$GhostLockImportResultCopyWith<$Res> {
  __$GhostLockImportResultCopyWithImpl(this._self, this._then);

  final _GhostLockImportResult _self;
  final $Res Function(_GhostLockImportResult) _then;

/// Create a copy of GhostLockImportResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? release = null,Object? fileName = null,Object? reason = null,Object? requiresOverwrite = null,}) {
  return _then(_GhostLockImportResult(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,requiresOverwrite: null == requiresOverwrite ? _self.requiresOverwrite : requiresOverwrite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
