// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_execution_field_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GhostLockExecutionFieldDto {

 String get path; int get value; bool get overridden;
/// Create a copy of GhostLockExecutionFieldDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockExecutionFieldDtoCopyWith<GhostLockExecutionFieldDto> get copyWith => _$GhostLockExecutionFieldDtoCopyWithImpl<GhostLockExecutionFieldDto>(this as GhostLockExecutionFieldDto, _$identity);

  /// Serializes this GhostLockExecutionFieldDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockExecutionFieldDto&&(identical(other.path, path) || other.path == path)&&(identical(other.value, value) || other.value == value)&&(identical(other.overridden, overridden) || other.overridden == overridden));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,value,overridden);

@override
String toString() {
  return 'GhostLockExecutionFieldDto(path: $path, value: $value, overridden: $overridden)';
}


}

/// @nodoc
abstract mixin class $GhostLockExecutionFieldDtoCopyWith<$Res>  {
  factory $GhostLockExecutionFieldDtoCopyWith(GhostLockExecutionFieldDto value, $Res Function(GhostLockExecutionFieldDto) _then) = _$GhostLockExecutionFieldDtoCopyWithImpl;
@useResult
$Res call({
 String path, int value, bool overridden
});




}
/// @nodoc
class _$GhostLockExecutionFieldDtoCopyWithImpl<$Res>
    implements $GhostLockExecutionFieldDtoCopyWith<$Res> {
  _$GhostLockExecutionFieldDtoCopyWithImpl(this._self, this._then);

  final GhostLockExecutionFieldDto _self;
  final $Res Function(GhostLockExecutionFieldDto) _then;

/// Create a copy of GhostLockExecutionFieldDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? value = null,Object? overridden = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,overridden: null == overridden ? _self.overridden : overridden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockExecutionFieldDto].
extension GhostLockExecutionFieldDtoPatterns on GhostLockExecutionFieldDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockExecutionFieldDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockExecutionFieldDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockExecutionFieldDto value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockExecutionFieldDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockExecutionFieldDto value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockExecutionFieldDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  int value,  bool overridden)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockExecutionFieldDto() when $default != null:
return $default(_that.path,_that.value,_that.overridden);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  int value,  bool overridden)  $default,) {final _that = this;
switch (_that) {
case _GhostLockExecutionFieldDto():
return $default(_that.path,_that.value,_that.overridden);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  int value,  bool overridden)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockExecutionFieldDto() when $default != null:
return $default(_that.path,_that.value,_that.overridden);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GhostLockExecutionFieldDto extends GhostLockExecutionFieldDto {
  const _GhostLockExecutionFieldDto({this.path = '', this.value = 0, this.overridden = false}): super._();
  factory _GhostLockExecutionFieldDto.fromJson(Map<String, dynamic> json) => _$GhostLockExecutionFieldDtoFromJson(json);

@override@JsonKey() final  String path;
@override@JsonKey() final  int value;
@override@JsonKey() final  bool overridden;

/// Create a copy of GhostLockExecutionFieldDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockExecutionFieldDtoCopyWith<_GhostLockExecutionFieldDto> get copyWith => __$GhostLockExecutionFieldDtoCopyWithImpl<_GhostLockExecutionFieldDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GhostLockExecutionFieldDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockExecutionFieldDto&&(identical(other.path, path) || other.path == path)&&(identical(other.value, value) || other.value == value)&&(identical(other.overridden, overridden) || other.overridden == overridden));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,value,overridden);

@override
String toString() {
  return 'GhostLockExecutionFieldDto(path: $path, value: $value, overridden: $overridden)';
}


}

/// @nodoc
abstract mixin class _$GhostLockExecutionFieldDtoCopyWith<$Res> implements $GhostLockExecutionFieldDtoCopyWith<$Res> {
  factory _$GhostLockExecutionFieldDtoCopyWith(_GhostLockExecutionFieldDto value, $Res Function(_GhostLockExecutionFieldDto) _then) = __$GhostLockExecutionFieldDtoCopyWithImpl;
@override @useResult
$Res call({
 String path, int value, bool overridden
});




}
/// @nodoc
class __$GhostLockExecutionFieldDtoCopyWithImpl<$Res>
    implements _$GhostLockExecutionFieldDtoCopyWith<$Res> {
  __$GhostLockExecutionFieldDtoCopyWithImpl(this._self, this._then);

  final _GhostLockExecutionFieldDto _self;
  final $Res Function(_GhostLockExecutionFieldDto) _then;

/// Create a copy of GhostLockExecutionFieldDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? value = null,Object? overridden = null,}) {
  return _then(_GhostLockExecutionFieldDto(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,overridden: null == overridden ? _self.overridden : overridden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
