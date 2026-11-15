// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_prompt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatPrompt {

 String get id; String get title; String get content; DateTime get createdAt;
/// Create a copy of ChatPrompt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatPromptCopyWith<ChatPrompt> get copyWith => _$ChatPromptCopyWithImpl<ChatPrompt>(this as ChatPrompt, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatPrompt&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content,createdAt);

@override
String toString() {
  return 'ChatPrompt(id: $id, title: $title, content: $content, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ChatPromptCopyWith<$Res>  {
  factory $ChatPromptCopyWith(ChatPrompt value, $Res Function(ChatPrompt) _then) = _$ChatPromptCopyWithImpl;
@useResult
$Res call({
 String id, String title, String content, DateTime createdAt
});




}
/// @nodoc
class _$ChatPromptCopyWithImpl<$Res>
    implements $ChatPromptCopyWith<$Res> {
  _$ChatPromptCopyWithImpl(this._self, this._then);

  final ChatPrompt _self;
  final $Res Function(ChatPrompt) _then;

/// Create a copy of ChatPrompt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatPrompt].
extension ChatPromptPatterns on ChatPrompt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatPrompt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatPrompt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatPrompt value)  $default,){
final _that = this;
switch (_that) {
case _ChatPrompt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatPrompt value)?  $default,){
final _that = this;
switch (_that) {
case _ChatPrompt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String content,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatPrompt() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String content,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ChatPrompt():
return $default(_that.id,_that.title,_that.content,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String content,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatPrompt() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ChatPrompt extends ChatPrompt {
  const _ChatPrompt({required this.id, required this.title, required this.content, required this.createdAt}): super._();
  

@override final  String id;
@override final  String title;
@override final  String content;
@override final  DateTime createdAt;

/// Create a copy of ChatPrompt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatPromptCopyWith<_ChatPrompt> get copyWith => __$ChatPromptCopyWithImpl<_ChatPrompt>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatPrompt&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content,createdAt);

@override
String toString() {
  return 'ChatPrompt(id: $id, title: $title, content: $content, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ChatPromptCopyWith<$Res> implements $ChatPromptCopyWith<$Res> {
  factory _$ChatPromptCopyWith(_ChatPrompt value, $Res Function(_ChatPrompt) _then) = __$ChatPromptCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String content, DateTime createdAt
});




}
/// @nodoc
class __$ChatPromptCopyWithImpl<$Res>
    implements _$ChatPromptCopyWith<$Res> {
  __$ChatPromptCopyWithImpl(this._self, this._then);

  final _ChatPrompt _self;
  final $Res Function(_ChatPrompt) _then;

/// Create a copy of ChatPrompt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? createdAt = null,}) {
  return _then(_ChatPrompt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
