// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_execution_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostLockExecutionField {

/// 完整点分路径，如 `execution.race.route_wait_ms`。
 String get path;/// 当前值。
 int get value;/// 该字段是否被本地 override。
 bool get overridden;
/// Create a copy of GhostLockExecutionField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockExecutionFieldCopyWith<GhostLockExecutionField> get copyWith => _$GhostLockExecutionFieldCopyWithImpl<GhostLockExecutionField>(this as GhostLockExecutionField, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockExecutionField&&(identical(other.path, path) || other.path == path)&&(identical(other.value, value) || other.value == value)&&(identical(other.overridden, overridden) || other.overridden == overridden));
}


@override
int get hashCode => Object.hash(runtimeType,path,value,overridden);

@override
String toString() {
  return 'GhostLockExecutionField(path: $path, value: $value, overridden: $overridden)';
}


}

/// @nodoc
abstract mixin class $GhostLockExecutionFieldCopyWith<$Res>  {
  factory $GhostLockExecutionFieldCopyWith(GhostLockExecutionField value, $Res Function(GhostLockExecutionField) _then) = _$GhostLockExecutionFieldCopyWithImpl;
@useResult
$Res call({
 String path, int value, bool overridden
});




}
/// @nodoc
class _$GhostLockExecutionFieldCopyWithImpl<$Res>
    implements $GhostLockExecutionFieldCopyWith<$Res> {
  _$GhostLockExecutionFieldCopyWithImpl(this._self, this._then);

  final GhostLockExecutionField _self;
  final $Res Function(GhostLockExecutionField) _then;

/// Create a copy of GhostLockExecutionField
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


/// Adds pattern-matching-related methods to [GhostLockExecutionField].
extension GhostLockExecutionFieldPatterns on GhostLockExecutionField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockExecutionField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockExecutionField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockExecutionField value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockExecutionField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockExecutionField value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockExecutionField() when $default != null:
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
case _GhostLockExecutionField() when $default != null:
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
case _GhostLockExecutionField():
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
case _GhostLockExecutionField() when $default != null:
return $default(_that.path,_that.value,_that.overridden);case _:
  return null;

}
}

}

/// @nodoc


class _GhostLockExecutionField extends GhostLockExecutionField {
  const _GhostLockExecutionField({required this.path, required this.value, required this.overridden}): super._();
  

/// 完整点分路径，如 `execution.race.route_wait_ms`。
@override final  String path;
/// 当前值。
@override final  int value;
/// 该字段是否被本地 override。
@override final  bool overridden;

/// Create a copy of GhostLockExecutionField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockExecutionFieldCopyWith<_GhostLockExecutionField> get copyWith => __$GhostLockExecutionFieldCopyWithImpl<_GhostLockExecutionField>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockExecutionField&&(identical(other.path, path) || other.path == path)&&(identical(other.value, value) || other.value == value)&&(identical(other.overridden, overridden) || other.overridden == overridden));
}


@override
int get hashCode => Object.hash(runtimeType,path,value,overridden);

@override
String toString() {
  return 'GhostLockExecutionField(path: $path, value: $value, overridden: $overridden)';
}


}

/// @nodoc
abstract mixin class _$GhostLockExecutionFieldCopyWith<$Res> implements $GhostLockExecutionFieldCopyWith<$Res> {
  factory _$GhostLockExecutionFieldCopyWith(_GhostLockExecutionField value, $Res Function(_GhostLockExecutionField) _then) = __$GhostLockExecutionFieldCopyWithImpl;
@override @useResult
$Res call({
 String path, int value, bool overridden
});




}
/// @nodoc
class __$GhostLockExecutionFieldCopyWithImpl<$Res>
    implements _$GhostLockExecutionFieldCopyWith<$Res> {
  __$GhostLockExecutionFieldCopyWithImpl(this._self, this._then);

  final _GhostLockExecutionField _self;
  final $Res Function(_GhostLockExecutionField) _then;

/// Create a copy of GhostLockExecutionField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? value = null,Object? overridden = null,}) {
  return _then(_GhostLockExecutionField(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,overridden: null == overridden ? _self.overridden : overridden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
