// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_prompt_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatPromptDto {

 String get id; String get title; String get content; String get createdAt;
/// Create a copy of ChatPromptDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatPromptDtoCopyWith<ChatPromptDto> get copyWith => _$ChatPromptDtoCopyWithImpl<ChatPromptDto>(this as ChatPromptDto, _$identity);

  /// Serializes this ChatPromptDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatPromptDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,createdAt);

@override
String toString() {
  return 'ChatPromptDto(id: $id, title: $title, content: $content, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ChatPromptDtoCopyWith<$Res>  {
  factory $ChatPromptDtoCopyWith(ChatPromptDto value, $Res Function(ChatPromptDto) _then) = _$ChatPromptDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String content, String createdAt
});




}
/// @nodoc
class _$ChatPromptDtoCopyWithImpl<$Res>
    implements $ChatPromptDtoCopyWith<$Res> {
  _$ChatPromptDtoCopyWithImpl(this._self, this._then);

  final ChatPromptDto _self;
  final $Res Function(ChatPromptDto) _then;

/// Create a copy of ChatPromptDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatPromptDto].
extension ChatPromptDtoPatterns on ChatPromptDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatPromptDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatPromptDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatPromptDto value)  $default,){
final _that = this;
switch (_that) {
case _ChatPromptDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatPromptDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChatPromptDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String content,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatPromptDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String content,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _ChatPromptDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String content,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatPromptDto() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatPromptDto extends ChatPromptDto {
  const _ChatPromptDto({this.id = '', this.title = '', this.content = '', this.createdAt = ''}): super._();
  factory _ChatPromptDto.fromJson(Map<String, dynamic> json) => _$ChatPromptDtoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String content;
@override@JsonKey() final  String createdAt;

/// Create a copy of ChatPromptDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatPromptDtoCopyWith<_ChatPromptDto> get copyWith => __$ChatPromptDtoCopyWithImpl<_ChatPromptDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatPromptDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatPromptDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,createdAt);

@override
String toString() {
  return 'ChatPromptDto(id: $id, title: $title, content: $content, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ChatPromptDtoCopyWith<$Res> implements $ChatPromptDtoCopyWith<$Res> {
  factory _$ChatPromptDtoCopyWith(_ChatPromptDto value, $Res Function(_ChatPromptDto) _then) = __$ChatPromptDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String content, String createdAt
});




}
/// @nodoc
class __$ChatPromptDtoCopyWithImpl<$Res>
    implements _$ChatPromptDtoCopyWith<$Res> {
  __$ChatPromptDtoCopyWithImpl(this._self, this._then);

  final _ChatPromptDto _self;
  final $Res Function(_ChatPromptDto) _then;

/// Create a copy of ChatPromptDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? createdAt = null,}) {
  return _then(_ChatPromptDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
