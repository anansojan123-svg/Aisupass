// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_tool.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatToolDefinition {

 String get name; String get description;/// JSON Schema 形式的参数定义。
 Map<String, dynamic> get parameters; ChatToolExecutor get execute;
/// Create a copy of ChatToolDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatToolDefinitionCopyWith<ChatToolDefinition> get copyWith => _$ChatToolDefinitionCopyWithImpl<ChatToolDefinition>(this as ChatToolDefinition, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatToolDefinition&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.parameters, parameters)&&(identical(other.execute, execute) || other.execute == execute));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,const DeepCollectionEquality().hash(parameters),execute);

@override
String toString() {
  return 'ChatToolDefinition(name: $name, description: $description, parameters: $parameters, execute: $execute)';
}


}

/// @nodoc
abstract mixin class $ChatToolDefinitionCopyWith<$Res>  {
  factory $ChatToolDefinitionCopyWith(ChatToolDefinition value, $Res Function(ChatToolDefinition) _then) = _$ChatToolDefinitionCopyWithImpl;
@useResult
$Res call({
 String name, String description, Map<String, dynamic> parameters, ChatToolExecutor execute
});




}
/// @nodoc
class _$ChatToolDefinitionCopyWithImpl<$Res>
    implements $ChatToolDefinitionCopyWith<$Res> {
  _$ChatToolDefinitionCopyWithImpl(this._self, this._then);

  final ChatToolDefinition _self;
  final $Res Function(ChatToolDefinition) _then;

/// Create a copy of ChatToolDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? parameters = null,Object? execute = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,execute: null == execute ? _self.execute : execute // ignore: cast_nullable_to_non_nullable
as ChatToolExecutor,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatToolDefinition].
extension ChatToolDefinitionPatterns on ChatToolDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatToolDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatToolDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatToolDefinition value)  $default,){
final _that = this;
switch (_that) {
case _ChatToolDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatToolDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _ChatToolDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  Map<String, dynamic> parameters,  ChatToolExecutor execute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatToolDefinition() when $default != null:
return $default(_that.name,_that.description,_that.parameters,_that.execute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  Map<String, dynamic> parameters,  ChatToolExecutor execute)  $default,) {final _that = this;
switch (_that) {
case _ChatToolDefinition():
return $default(_that.name,_that.description,_that.parameters,_that.execute);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  Map<String, dynamic> parameters,  ChatToolExecutor execute)?  $default,) {final _that = this;
switch (_that) {
case _ChatToolDefinition() when $default != null:
return $default(_that.name,_that.description,_that.parameters,_that.execute);case _:
  return null;

}
}

}

/// @nodoc


class _ChatToolDefinition extends ChatToolDefinition {
  const _ChatToolDefinition({required this.name, required this.description, required this.parameters, required this.execute}): super._();
  

@override final  String name;
@override final  String description;
/// JSON Schema 形式的参数定义。
@override final  Map<String, dynamic> parameters;
@override final  ChatToolExecutor execute;

/// Create a copy of ChatToolDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatToolDefinitionCopyWith<_ChatToolDefinition> get copyWith => __$ChatToolDefinitionCopyWithImpl<_ChatToolDefinition>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatToolDefinition&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.parameters, parameters)&&(identical(other.execute, execute) || other.execute == execute));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,const DeepCollectionEquality().hash(parameters),execute);

@override
String toString() {
  return 'ChatToolDefinition(name: $name, description: $description, parameters: $parameters, execute: $execute)';
}


}

/// @nodoc
abstract mixin class _$ChatToolDefinitionCopyWith<$Res> implements $ChatToolDefinitionCopyWith<$Res> {
  factory _$ChatToolDefinitionCopyWith(_ChatToolDefinition value, $Res Function(_ChatToolDefinition) _then) = __$ChatToolDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, Map<String, dynamic> parameters, ChatToolExecutor execute
});




}
/// @nodoc
class __$ChatToolDefinitionCopyWithImpl<$Res>
    implements _$ChatToolDefinitionCopyWith<$Res> {
  __$ChatToolDefinitionCopyWithImpl(this._self, this._then);

  final _ChatToolDefinition _self;
  final $Res Function(_ChatToolDefinition) _then;

/// Create a copy of ChatToolDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? parameters = null,Object? execute = null,}) {
  return _then(_ChatToolDefinition(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,execute: null == execute ? _self.execute : execute // ignore: cast_nullable_to_non_nullable
as ChatToolExecutor,
  ));
}


}

// dart format on
