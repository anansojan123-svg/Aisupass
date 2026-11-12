// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_profile_field_node_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GhostLockProfileFieldNodeDto {

 String get path; String get name; int get depth; int get value; bool get provided; bool get overridden;
/// Create a copy of GhostLockProfileFieldNodeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockProfileFieldNodeDtoCopyWith<GhostLockProfileFieldNodeDto> get copyWith => _$GhostLockProfileFieldNodeDtoCopyWithImpl<GhostLockProfileFieldNodeDto>(this as GhostLockProfileFieldNodeDto, _$identity);

  /// Serializes this GhostLockProfileFieldNodeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockProfileFieldNodeDto&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.value, value) || other.value == value)&&(identical(other.provided, provided) || other.provided == provided)&&(identical(other.overridden, overridden) || other.overridden == overridden));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,name,depth,value,provided,overridden);

@override
String toString() {
  return 'GhostLockProfileFieldNodeDto(path: $path, name: $name, depth: $depth, value: $value, provided: $provided, overridden: $overridden)';
}


}

/// @nodoc
abstract mixin class $GhostLockProfileFieldNodeDtoCopyWith<$Res>  {
  factory $GhostLockProfileFieldNodeDtoCopyWith(GhostLockProfileFieldNodeDto value, $Res Function(GhostLockProfileFieldNodeDto) _then) = _$GhostLockProfileFieldNodeDtoCopyWithImpl;
@useResult
$Res call({
 String path, String name, int depth, int value, bool provided, bool overridden
});




}
/// @nodoc
class _$GhostLockProfileFieldNodeDtoCopyWithImpl<$Res>
    implements $GhostLockProfileFieldNodeDtoCopyWith<$Res> {
  _$GhostLockProfileFieldNodeDtoCopyWithImpl(this._self, this._then);

  final GhostLockProfileFieldNodeDto _self;
  final $Res Function(GhostLockProfileFieldNodeDto) _then;

/// Create a copy of GhostLockProfileFieldNodeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? name = null,Object? depth = null,Object? value = null,Object? provided = null,Object? overridden = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,provided: null == provided ? _self.provided : provided // ignore: cast_nullable_to_non_nullable
as bool,overridden: null == overridden ? _self.overridden : overridden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockProfileFieldNodeDto].
extension GhostLockProfileFieldNodeDtoPatterns on GhostLockProfileFieldNodeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockProfileFieldNodeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockProfileFieldNodeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockProfileFieldNodeDto value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockProfileFieldNodeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockProfileFieldNodeDto value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockProfileFieldNodeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String name,  int depth,  int value,  bool provided,  bool overridden)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockProfileFieldNodeDto() when $default != null:
return $default(_that.path,_that.name,_that.depth,_that.value,_that.provided,_that.overridden);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String name,  int depth,  int value,  bool provided,  bool overridden)  $default,) {final _that = this;
switch (_that) {
case _GhostLockProfileFieldNodeDto():
return $default(_that.path,_that.name,_that.depth,_that.value,_that.provided,_that.overridden);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String name,  int depth,  int value,  bool provided,  bool overridden)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockProfileFieldNodeDto() when $default != null:
return $default(_that.path,_that.name,_that.depth,_that.value,_that.provided,_that.overridden);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GhostLockProfileFieldNodeDto extends GhostLockProfileFieldNodeDto {
  const _GhostLockProfileFieldNodeDto({this.path = '', this.name = '', this.depth = 0, this.value = 0, this.provided = false, this.overridden = false}): super._();
  factory _GhostLockProfileFieldNodeDto.fromJson(Map<String, dynamic> json) => _$GhostLockProfileFieldNodeDtoFromJson(json);

@override@JsonKey() final  String path;
@override@JsonKey() final  String name;
@override@JsonKey() final  int depth;
@override@JsonKey() final  int value;
@override@JsonKey() final  bool provided;
@override@JsonKey() final  bool overridden;

/// Create a copy of GhostLockProfileFieldNodeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockProfileFieldNodeDtoCopyWith<_GhostLockProfileFieldNodeDto> get copyWith => __$GhostLockProfileFieldNodeDtoCopyWithImpl<_GhostLockProfileFieldNodeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GhostLockProfileFieldNodeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockProfileFieldNodeDto&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.value, value) || other.value == value)&&(identical(other.provided, provided) || other.provided == provided)&&(identical(other.overridden, overridden) || other.overridden == overridden));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,name,depth,value,provided,overridden);

@override
String toString() {
  return 'GhostLockProfileFieldNodeDto(path: $path, name: $name, depth: $depth, value: $value, provided: $provided, overridden: $overridden)';
}


}

/// @nodoc
abstract mixin class _$GhostLockProfileFieldNodeDtoCopyWith<$Res> implements $GhostLockProfileFieldNodeDtoCopyWith<$Res> {
  factory _$GhostLockProfileFieldNodeDtoCopyWith(_GhostLockProfileFieldNodeDto value, $Res Function(_GhostLockProfileFieldNodeDto) _then) = __$GhostLockProfileFieldNodeDtoCopyWithImpl;
@override @useResult
$Res call({
 String path, String name, int depth, int value, bool provided, bool overridden
});




}
/// @nodoc
class __$GhostLockProfileFieldNodeDtoCopyWithImpl<$Res>
    implements _$GhostLockProfileFieldNodeDtoCopyWith<$Res> {
  __$GhostLockProfileFieldNodeDtoCopyWithImpl(this._self, this._then);

  final _GhostLockProfileFieldNodeDto _self;
  final $Res Function(_GhostLockProfileFieldNodeDto) _then;

/// Create a copy of GhostLockProfileFieldNodeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? name = null,Object? depth = null,Object? value = null,Object? provided = null,Object? overridden = null,}) {
  return _then(_GhostLockProfileFieldNodeDto(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,provided: null == provided ? _self.provided : provided // ignore: cast_nullable_to_non_nullable
as bool,overridden: null == overridden ? _self.overridden : overridden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
