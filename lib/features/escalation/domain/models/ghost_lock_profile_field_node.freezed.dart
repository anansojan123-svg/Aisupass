// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_profile_field_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostLockProfileFieldNode {

/// 完整点分路径，如 `task_struct.cred`。
 String get path;/// 末段键名，用于显示。
 String get name;/// 当前值；[provided] 为 false 时这个 0 不代表真实值。
 int get value;/// 该字段在 profile 里是否提供了值。
 bool get provided;/// 该字段或任一子孙是否被 override。
 bool get overridden;/// 子节点；叶子为空列表。
 List<GhostLockProfileFieldNode> get children;
/// Create a copy of GhostLockProfileFieldNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockProfileFieldNodeCopyWith<GhostLockProfileFieldNode> get copyWith => _$GhostLockProfileFieldNodeCopyWithImpl<GhostLockProfileFieldNode>(this as GhostLockProfileFieldNode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockProfileFieldNode&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.provided, provided) || other.provided == provided)&&(identical(other.overridden, overridden) || other.overridden == overridden)&&const DeepCollectionEquality().equals(other.children, children));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,value,provided,overridden,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'GhostLockProfileFieldNode(path: $path, name: $name, value: $value, provided: $provided, overridden: $overridden, children: $children)';
}


}

/// @nodoc
abstract mixin class $GhostLockProfileFieldNodeCopyWith<$Res>  {
  factory $GhostLockProfileFieldNodeCopyWith(GhostLockProfileFieldNode value, $Res Function(GhostLockProfileFieldNode) _then) = _$GhostLockProfileFieldNodeCopyWithImpl;
@useResult
$Res call({
 String path, String name, int value, bool provided, bool overridden, List<GhostLockProfileFieldNode> children
});




}
/// @nodoc
class _$GhostLockProfileFieldNodeCopyWithImpl<$Res>
    implements $GhostLockProfileFieldNodeCopyWith<$Res> {
  _$GhostLockProfileFieldNodeCopyWithImpl(this._self, this._then);

  final GhostLockProfileFieldNode _self;
  final $Res Function(GhostLockProfileFieldNode) _then;

/// Create a copy of GhostLockProfileFieldNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? name = null,Object? value = null,Object? provided = null,Object? overridden = null,Object? children = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,provided: null == provided ? _self.provided : provided // ignore: cast_nullable_to_non_nullable
as bool,overridden: null == overridden ? _self.overridden : overridden // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<GhostLockProfileFieldNode>,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockProfileFieldNode].
extension GhostLockProfileFieldNodePatterns on GhostLockProfileFieldNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockProfileFieldNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockProfileFieldNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockProfileFieldNode value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockProfileFieldNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockProfileFieldNode value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockProfileFieldNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String name,  int value,  bool provided,  bool overridden,  List<GhostLockProfileFieldNode> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockProfileFieldNode() when $default != null:
return $default(_that.path,_that.name,_that.value,_that.provided,_that.overridden,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String name,  int value,  bool provided,  bool overridden,  List<GhostLockProfileFieldNode> children)  $default,) {final _that = this;
switch (_that) {
case _GhostLockProfileFieldNode():
return $default(_that.path,_that.name,_that.value,_that.provided,_that.overridden,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String name,  int value,  bool provided,  bool overridden,  List<GhostLockProfileFieldNode> children)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockProfileFieldNode() when $default != null:
return $default(_that.path,_that.name,_that.value,_that.provided,_that.overridden,_that.children);case _:
  return null;

}
}

}

/// @nodoc


class _GhostLockProfileFieldNode extends GhostLockProfileFieldNode {
  const _GhostLockProfileFieldNode({required this.path, required this.name, required this.value, required this.provided, required this.overridden, required this.children}): super._();
  

/// 完整点分路径，如 `task_struct.cred`。
@override final  String path;
/// 末段键名，用于显示。
@override final  String name;
/// 当前值；[provided] 为 false 时这个 0 不代表真实值。
@override final  int value;
/// 该字段在 profile 里是否提供了值。
@override final  bool provided;
/// 该字段或任一子孙是否被 override。
@override final  bool overridden;
/// 子节点；叶子为空列表。
@override final  List<GhostLockProfileFieldNode> children;

/// Create a copy of GhostLockProfileFieldNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockProfileFieldNodeCopyWith<_GhostLockProfileFieldNode> get copyWith => __$GhostLockProfileFieldNodeCopyWithImpl<_GhostLockProfileFieldNode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockProfileFieldNode&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.provided, provided) || other.provided == provided)&&(identical(other.overridden, overridden) || other.overridden == overridden)&&const DeepCollectionEquality().equals(other.children, children));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,value,provided,overridden,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'GhostLockProfileFieldNode(path: $path, name: $name, value: $value, provided: $provided, overridden: $overridden, children: $children)';
}


}

/// @nodoc
abstract mixin class _$GhostLockProfileFieldNodeCopyWith<$Res> implements $GhostLockProfileFieldNodeCopyWith<$Res> {
  factory _$GhostLockProfileFieldNodeCopyWith(_GhostLockProfileFieldNode value, $Res Function(_GhostLockProfileFieldNode) _then) = __$GhostLockProfileFieldNodeCopyWithImpl;
@override @useResult
$Res call({
 String path, String name, int value, bool provided, bool overridden, List<GhostLockProfileFieldNode> children
});




}
/// @nodoc
class __$GhostLockProfileFieldNodeCopyWithImpl<$Res>
    implements _$GhostLockProfileFieldNodeCopyWith<$Res> {
  __$GhostLockProfileFieldNodeCopyWithImpl(this._self, this._then);

  final _GhostLockProfileFieldNode _self;
  final $Res Function(_GhostLockProfileFieldNode) _then;

/// Create a copy of GhostLockProfileFieldNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? name = null,Object? value = null,Object? provided = null,Object? overridden = null,Object? children = null,}) {
  return _then(_GhostLockProfileFieldNode(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,provided: null == provided ? _self.provided : provided // ignore: cast_nullable_to_non_nullable
as bool,overridden: null == overridden ? _self.overridden : overridden // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<GhostLockProfileFieldNode>,
  ));
}


}

// dart format on
