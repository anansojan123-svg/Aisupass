// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_user_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GhostLockUserProfileDto {

 String get name; String get release; int get sizeBytes; int get importedAtMs; bool get parseError;
/// Create a copy of GhostLockUserProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockUserProfileDtoCopyWith<GhostLockUserProfileDto> get copyWith => _$GhostLockUserProfileDtoCopyWithImpl<GhostLockUserProfileDto>(this as GhostLockUserProfileDto, _$identity);

  /// Serializes this GhostLockUserProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockUserProfileDto&&(identical(other.name, name) || other.name == name)&&(identical(other.release, release) || other.release == release)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.importedAtMs, importedAtMs) || other.importedAtMs == importedAtMs)&&(identical(other.parseError, parseError) || other.parseError == parseError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,release,sizeBytes,importedAtMs,parseError);

@override
String toString() {
  return 'GhostLockUserProfileDto(name: $name, release: $release, sizeBytes: $sizeBytes, importedAtMs: $importedAtMs, parseError: $parseError)';
}


}

/// @nodoc
abstract mixin class $GhostLockUserProfileDtoCopyWith<$Res>  {
  factory $GhostLockUserProfileDtoCopyWith(GhostLockUserProfileDto value, $Res Function(GhostLockUserProfileDto) _then) = _$GhostLockUserProfileDtoCopyWithImpl;
@useResult
$Res call({
 String name, String release, int sizeBytes, int importedAtMs, bool parseError
});




}
/// @nodoc
class _$GhostLockUserProfileDtoCopyWithImpl<$Res>
    implements $GhostLockUserProfileDtoCopyWith<$Res> {
  _$GhostLockUserProfileDtoCopyWithImpl(this._self, this._then);

  final GhostLockUserProfileDto _self;
  final $Res Function(GhostLockUserProfileDto) _then;

/// Create a copy of GhostLockUserProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? release = null,Object? sizeBytes = null,Object? importedAtMs = null,Object? parseError = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,importedAtMs: null == importedAtMs ? _self.importedAtMs : importedAtMs // ignore: cast_nullable_to_non_nullable
as int,parseError: null == parseError ? _self.parseError : parseError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockUserProfileDto].
extension GhostLockUserProfileDtoPatterns on GhostLockUserProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockUserProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockUserProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockUserProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockUserProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockUserProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockUserProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String release,  int sizeBytes,  int importedAtMs,  bool parseError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockUserProfileDto() when $default != null:
return $default(_that.name,_that.release,_that.sizeBytes,_that.importedAtMs,_that.parseError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String release,  int sizeBytes,  int importedAtMs,  bool parseError)  $default,) {final _that = this;
switch (_that) {
case _GhostLockUserProfileDto():
return $default(_that.name,_that.release,_that.sizeBytes,_that.importedAtMs,_that.parseError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String release,  int sizeBytes,  int importedAtMs,  bool parseError)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockUserProfileDto() when $default != null:
return $default(_that.name,_that.release,_that.sizeBytes,_that.importedAtMs,_that.parseError);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GhostLockUserProfileDto extends GhostLockUserProfileDto {
  const _GhostLockUserProfileDto({this.name = '', this.release = '', this.sizeBytes = 0, this.importedAtMs = 0, this.parseError = false}): super._();
  factory _GhostLockUserProfileDto.fromJson(Map<String, dynamic> json) => _$GhostLockUserProfileDtoFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String release;
@override@JsonKey() final  int sizeBytes;
@override@JsonKey() final  int importedAtMs;
@override@JsonKey() final  bool parseError;

/// Create a copy of GhostLockUserProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockUserProfileDtoCopyWith<_GhostLockUserProfileDto> get copyWith => __$GhostLockUserProfileDtoCopyWithImpl<_GhostLockUserProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GhostLockUserProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockUserProfileDto&&(identical(other.name, name) || other.name == name)&&(identical(other.release, release) || other.release == release)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.importedAtMs, importedAtMs) || other.importedAtMs == importedAtMs)&&(identical(other.parseError, parseError) || other.parseError == parseError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,release,sizeBytes,importedAtMs,parseError);

@override
String toString() {
  return 'GhostLockUserProfileDto(name: $name, release: $release, sizeBytes: $sizeBytes, importedAtMs: $importedAtMs, parseError: $parseError)';
}


}

/// @nodoc
abstract mixin class _$GhostLockUserProfileDtoCopyWith<$Res> implements $GhostLockUserProfileDtoCopyWith<$Res> {
  factory _$GhostLockUserProfileDtoCopyWith(_GhostLockUserProfileDto value, $Res Function(_GhostLockUserProfileDto) _then) = __$GhostLockUserProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, String release, int sizeBytes, int importedAtMs, bool parseError
});




}
/// @nodoc
class __$GhostLockUserProfileDtoCopyWithImpl<$Res>
    implements _$GhostLockUserProfileDtoCopyWith<$Res> {
  __$GhostLockUserProfileDtoCopyWithImpl(this._self, this._then);

  final _GhostLockUserProfileDto _self;
  final $Res Function(_GhostLockUserProfileDto) _then;

/// Create a copy of GhostLockUserProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? release = null,Object? sizeBytes = null,Object? importedAtMs = null,Object? parseError = null,}) {
  return _then(_GhostLockUserProfileDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,importedAtMs: null == importedAtMs ? _self.importedAtMs : importedAtMs // ignore: cast_nullable_to_non_nullable
as int,parseError: null == parseError ? _self.parseError : parseError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
