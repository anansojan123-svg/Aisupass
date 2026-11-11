// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kernel_profile_import_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KernelProfileImportResult {

 bool get ok; String get release; List<String> get missing; String get errorCode; String get error;
/// Create a copy of KernelProfileImportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KernelProfileImportResultCopyWith<KernelProfileImportResult> get copyWith => _$KernelProfileImportResultCopyWithImpl<KernelProfileImportResult>(this as KernelProfileImportResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KernelProfileImportResult&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&const DeepCollectionEquality().equals(other.missing, missing)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,ok,release,const DeepCollectionEquality().hash(missing),errorCode,error);

@override
String toString() {
  return 'KernelProfileImportResult(ok: $ok, release: $release, missing: $missing, errorCode: $errorCode, error: $error)';
}


}

/// @nodoc
abstract mixin class $KernelProfileImportResultCopyWith<$Res>  {
  factory $KernelProfileImportResultCopyWith(KernelProfileImportResult value, $Res Function(KernelProfileImportResult) _then) = _$KernelProfileImportResultCopyWithImpl;
@useResult
$Res call({
 bool ok, String release, List<String> missing, String errorCode, String error
});




}
/// @nodoc
class _$KernelProfileImportResultCopyWithImpl<$Res>
    implements $KernelProfileImportResultCopyWith<$Res> {
  _$KernelProfileImportResultCopyWithImpl(this._self, this._then);

  final KernelProfileImportResult _self;
  final $Res Function(KernelProfileImportResult) _then;

/// Create a copy of KernelProfileImportResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? release = null,Object? missing = null,Object? errorCode = null,Object? error = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,missing: null == missing ? _self.missing : missing // ignore: cast_nullable_to_non_nullable
as List<String>,errorCode: null == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KernelProfileImportResult].
extension KernelProfileImportResultPatterns on KernelProfileImportResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KernelProfileImportResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KernelProfileImportResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KernelProfileImportResult value)  $default,){
final _that = this;
switch (_that) {
case _KernelProfileImportResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KernelProfileImportResult value)?  $default,){
final _that = this;
switch (_that) {
case _KernelProfileImportResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String release,  List<String> missing,  String errorCode,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KernelProfileImportResult() when $default != null:
return $default(_that.ok,_that.release,_that.missing,_that.errorCode,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String release,  List<String> missing,  String errorCode,  String error)  $default,) {final _that = this;
switch (_that) {
case _KernelProfileImportResult():
return $default(_that.ok,_that.release,_that.missing,_that.errorCode,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String release,  List<String> missing,  String errorCode,  String error)?  $default,) {final _that = this;
switch (_that) {
case _KernelProfileImportResult() when $default != null:
return $default(_that.ok,_that.release,_that.missing,_that.errorCode,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _KernelProfileImportResult extends KernelProfileImportResult {
  const _KernelProfileImportResult({required this.ok, required this.release, required this.missing, required this.errorCode, required this.error}): super._();
  

@override final  bool ok;
@override final  String release;
@override final  List<String> missing;
@override final  String errorCode;
@override final  String error;

/// Create a copy of KernelProfileImportResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KernelProfileImportResultCopyWith<_KernelProfileImportResult> get copyWith => __$KernelProfileImportResultCopyWithImpl<_KernelProfileImportResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KernelProfileImportResult&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&const DeepCollectionEquality().equals(other.missing, missing)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,ok,release,const DeepCollectionEquality().hash(missing),errorCode,error);

@override
String toString() {
  return 'KernelProfileImportResult(ok: $ok, release: $release, missing: $missing, errorCode: $errorCode, error: $error)';
}


}

/// @nodoc
abstract mixin class _$KernelProfileImportResultCopyWith<$Res> implements $KernelProfileImportResultCopyWith<$Res> {
  factory _$KernelProfileImportResultCopyWith(_KernelProfileImportResult value, $Res Function(_KernelProfileImportResult) _then) = __$KernelProfileImportResultCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String release, List<String> missing, String errorCode, String error
});




}
/// @nodoc
class __$KernelProfileImportResultCopyWithImpl<$Res>
    implements _$KernelProfileImportResultCopyWith<$Res> {
  __$KernelProfileImportResultCopyWithImpl(this._self, this._then);

  final _KernelProfileImportResult _self;
  final $Res Function(_KernelProfileImportResult) _then;

/// Create a copy of KernelProfileImportResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? release = null,Object? missing = null,Object? errorCode = null,Object? error = null,}) {
  return _then(_KernelProfileImportResult(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,missing: null == missing ? _self.missing : missing // ignore: cast_nullable_to_non_nullable
as List<String>,errorCode: null == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
