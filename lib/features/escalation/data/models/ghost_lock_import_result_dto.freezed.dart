// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_import_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GhostLockImportResultDto {

 bool get ok; String get release; String get fileName; String get reason; bool get requiresOverwrite;
/// Create a copy of GhostLockImportResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockImportResultDtoCopyWith<GhostLockImportResultDto> get copyWith => _$GhostLockImportResultDtoCopyWithImpl<GhostLockImportResultDto>(this as GhostLockImportResultDto, _$identity);

  /// Serializes this GhostLockImportResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockImportResultDto&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.requiresOverwrite, requiresOverwrite) || other.requiresOverwrite == requiresOverwrite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,release,fileName,reason,requiresOverwrite);

@override
String toString() {
  return 'GhostLockImportResultDto(ok: $ok, release: $release, fileName: $fileName, reason: $reason, requiresOverwrite: $requiresOverwrite)';
}


}

/// @nodoc
abstract mixin class $GhostLockImportResultDtoCopyWith<$Res>  {
  factory $GhostLockImportResultDtoCopyWith(GhostLockImportResultDto value, $Res Function(GhostLockImportResultDto) _then) = _$GhostLockImportResultDtoCopyWithImpl;
@useResult
$Res call({
 bool ok, String release, String fileName, String reason, bool requiresOverwrite
});




}
/// @nodoc
class _$GhostLockImportResultDtoCopyWithImpl<$Res>
    implements $GhostLockImportResultDtoCopyWith<$Res> {
  _$GhostLockImportResultDtoCopyWithImpl(this._self, this._then);

  final GhostLockImportResultDto _self;
  final $Res Function(GhostLockImportResultDto) _then;

/// Create a copy of GhostLockImportResultDto
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


/// Adds pattern-matching-related methods to [GhostLockImportResultDto].
extension GhostLockImportResultDtoPatterns on GhostLockImportResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockImportResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockImportResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockImportResultDto value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockImportResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockImportResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockImportResultDto() when $default != null:
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
case _GhostLockImportResultDto() when $default != null:
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
case _GhostLockImportResultDto():
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
case _GhostLockImportResultDto() when $default != null:
return $default(_that.ok,_that.release,_that.fileName,_that.reason,_that.requiresOverwrite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GhostLockImportResultDto extends GhostLockImportResultDto {
  const _GhostLockImportResultDto({this.ok = false, this.release = '', this.fileName = '', this.reason = '', this.requiresOverwrite = false}): super._();
  factory _GhostLockImportResultDto.fromJson(Map<String, dynamic> json) => _$GhostLockImportResultDtoFromJson(json);

@override@JsonKey() final  bool ok;
@override@JsonKey() final  String release;
@override@JsonKey() final  String fileName;
@override@JsonKey() final  String reason;
@override@JsonKey() final  bool requiresOverwrite;

/// Create a copy of GhostLockImportResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockImportResultDtoCopyWith<_GhostLockImportResultDto> get copyWith => __$GhostLockImportResultDtoCopyWithImpl<_GhostLockImportResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GhostLockImportResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockImportResultDto&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.requiresOverwrite, requiresOverwrite) || other.requiresOverwrite == requiresOverwrite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,release,fileName,reason,requiresOverwrite);

@override
String toString() {
  return 'GhostLockImportResultDto(ok: $ok, release: $release, fileName: $fileName, reason: $reason, requiresOverwrite: $requiresOverwrite)';
}


}

/// @nodoc
abstract mixin class _$GhostLockImportResultDtoCopyWith<$Res> implements $GhostLockImportResultDtoCopyWith<$Res> {
  factory _$GhostLockImportResultDtoCopyWith(_GhostLockImportResultDto value, $Res Function(_GhostLockImportResultDto) _then) = __$GhostLockImportResultDtoCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String release, String fileName, String reason, bool requiresOverwrite
});




}
/// @nodoc
class __$GhostLockImportResultDtoCopyWithImpl<$Res>
    implements _$GhostLockImportResultDtoCopyWith<$Res> {
  __$GhostLockImportResultDtoCopyWithImpl(this._self, this._then);

  final _GhostLockImportResultDto _self;
  final $Res Function(_GhostLockImportResultDto) _then;

/// Create a copy of GhostLockImportResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? release = null,Object? fileName = null,Object? reason = null,Object? requiresOverwrite = null,}) {
  return _then(_GhostLockImportResultDto(
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
