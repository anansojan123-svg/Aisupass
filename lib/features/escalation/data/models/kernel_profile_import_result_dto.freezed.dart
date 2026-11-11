// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kernel_profile_import_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KernelProfileImportResultDto {

 bool get ok; String get release; List<String> get missing; String get errorCode; String get error;
/// Create a copy of KernelProfileImportResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KernelProfileImportResultDtoCopyWith<KernelProfileImportResultDto> get copyWith => _$KernelProfileImportResultDtoCopyWithImpl<KernelProfileImportResultDto>(this as KernelProfileImportResultDto, _$identity);

  /// Serializes this KernelProfileImportResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KernelProfileImportResultDto&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&const DeepCollectionEquality().equals(other.missing, missing)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,release,const DeepCollectionEquality().hash(missing),errorCode,error);

@override
String toString() {
  return 'KernelProfileImportResultDto(ok: $ok, release: $release, missing: $missing, errorCode: $errorCode, error: $error)';
}


}

/// @nodoc
abstract mixin class $KernelProfileImportResultDtoCopyWith<$Res>  {
  factory $KernelProfileImportResultDtoCopyWith(KernelProfileImportResultDto value, $Res Function(KernelProfileImportResultDto) _then) = _$KernelProfileImportResultDtoCopyWithImpl;
@useResult
$Res call({
 bool ok, String release, List<String> missing, String errorCode, String error
});




}
/// @nodoc
class _$KernelProfileImportResultDtoCopyWithImpl<$Res>
    implements $KernelProfileImportResultDtoCopyWith<$Res> {
  _$KernelProfileImportResultDtoCopyWithImpl(this._self, this._then);

  final KernelProfileImportResultDto _self;
  final $Res Function(KernelProfileImportResultDto) _then;

/// Create a copy of KernelProfileImportResultDto
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


/// Adds pattern-matching-related methods to [KernelProfileImportResultDto].
extension KernelProfileImportResultDtoPatterns on KernelProfileImportResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KernelProfileImportResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KernelProfileImportResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KernelProfileImportResultDto value)  $default,){
final _that = this;
switch (_that) {
case _KernelProfileImportResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KernelProfileImportResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _KernelProfileImportResultDto() when $default != null:
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
case _KernelProfileImportResultDto() when $default != null:
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
case _KernelProfileImportResultDto():
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
case _KernelProfileImportResultDto() when $default != null:
return $default(_that.ok,_that.release,_that.missing,_that.errorCode,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KernelProfileImportResultDto extends KernelProfileImportResultDto {
  const _KernelProfileImportResultDto({this.ok = false, this.release = '', this.missing = const <String>[], this.errorCode = '', this.error = ''}): super._();
  factory _KernelProfileImportResultDto.fromJson(Map<String, dynamic> json) => _$KernelProfileImportResultDtoFromJson(json);

@override@JsonKey() final  bool ok;
@override@JsonKey() final  String release;
@override@JsonKey() final  List<String> missing;
@override@JsonKey() final  String errorCode;
@override@JsonKey() final  String error;

/// Create a copy of KernelProfileImportResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KernelProfileImportResultDtoCopyWith<_KernelProfileImportResultDto> get copyWith => __$KernelProfileImportResultDtoCopyWithImpl<_KernelProfileImportResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KernelProfileImportResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KernelProfileImportResultDto&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&const DeepCollectionEquality().equals(other.missing, missing)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,release,const DeepCollectionEquality().hash(missing),errorCode,error);

@override
String toString() {
  return 'KernelProfileImportResultDto(ok: $ok, release: $release, missing: $missing, errorCode: $errorCode, error: $error)';
}


}

/// @nodoc
abstract mixin class _$KernelProfileImportResultDtoCopyWith<$Res> implements $KernelProfileImportResultDtoCopyWith<$Res> {
  factory _$KernelProfileImportResultDtoCopyWith(_KernelProfileImportResultDto value, $Res Function(_KernelProfileImportResultDto) _then) = __$KernelProfileImportResultDtoCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String release, List<String> missing, String errorCode, String error
});




}
/// @nodoc
class __$KernelProfileImportResultDtoCopyWithImpl<$Res>
    implements _$KernelProfileImportResultDtoCopyWith<$Res> {
  __$KernelProfileImportResultDtoCopyWithImpl(this._self, this._then);

  final _KernelProfileImportResultDto _self;
  final $Res Function(_KernelProfileImportResultDto) _then;

/// Create a copy of KernelProfileImportResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? release = null,Object? missing = null,Object? errorCode = null,Object? error = null,}) {
  return _then(_KernelProfileImportResultDto(
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
