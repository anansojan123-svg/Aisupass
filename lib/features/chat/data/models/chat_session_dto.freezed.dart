// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatSessionDto {

 String get id; String get title; String get createdAt; String get updatedAt; List<ChatTurnDto> get turns;
/// Create a copy of ChatSessionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSessionDtoCopyWith<ChatSessionDto> get copyWith => _$ChatSessionDtoCopyWithImpl<ChatSessionDto>(this as ChatSessionDto, _$identity);

  /// Serializes this ChatSessionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSessionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.turns, turns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,updatedAt,const DeepCollectionEquality().hash(turns));

@override
String toString() {
  return 'ChatSessionDto(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, turns: $turns)';
}


}

/// @nodoc
abstract mixin class $ChatSessionDtoCopyWith<$Res>  {
  factory $ChatSessionDtoCopyWith(ChatSessionDto value, $Res Function(ChatSessionDto) _then) = _$ChatSessionDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String createdAt, String updatedAt, List<ChatTurnDto> turns
});




}
/// @nodoc
class _$ChatSessionDtoCopyWithImpl<$Res>
    implements $ChatSessionDtoCopyWith<$Res> {
  _$ChatSessionDtoCopyWithImpl(this._self, this._then);

  final ChatSessionDto _self;
  final $Res Function(ChatSessionDto) _then;

/// Create a copy of ChatSessionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? turns = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,turns: null == turns ? _self.turns : turns // ignore: cast_nullable_to_non_nullable
as List<ChatTurnDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSessionDto].
extension ChatSessionDtoPatterns on ChatSessionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSessionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSessionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSessionDto value)  $default,){
final _that = this;
switch (_that) {
case _ChatSessionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSessionDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSessionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String createdAt,  String updatedAt,  List<ChatTurnDto> turns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSessionDto() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.turns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String createdAt,  String updatedAt,  List<ChatTurnDto> turns)  $default,) {final _that = this;
switch (_that) {
case _ChatSessionDto():
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.turns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String createdAt,  String updatedAt,  List<ChatTurnDto> turns)?  $default,) {final _that = this;
switch (_that) {
case _ChatSessionDto() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.turns);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSessionDto extends ChatSessionDto {
  const _ChatSessionDto({this.id = '', this.title = '', this.createdAt = '', this.updatedAt = '', this.turns = const <ChatTurnDto>[]}): super._();
  factory _ChatSessionDto.fromJson(Map<String, dynamic> json) => _$ChatSessionDtoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String createdAt;
@override@JsonKey() final  String updatedAt;
@override@JsonKey() final  List<ChatTurnDto> turns;

/// Create a copy of ChatSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSessionDtoCopyWith<_ChatSessionDto> get copyWith => __$ChatSessionDtoCopyWithImpl<_ChatSessionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSessionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSessionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.turns, turns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,updatedAt,const DeepCollectionEquality().hash(turns));

@override
String toString() {
  return 'ChatSessionDto(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, turns: $turns)';
}


}

/// @nodoc
abstract mixin class _$ChatSessionDtoCopyWith<$Res> implements $ChatSessionDtoCopyWith<$Res> {
  factory _$ChatSessionDtoCopyWith(_ChatSessionDto value, $Res Function(_ChatSessionDto) _then) = __$ChatSessionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String createdAt, String updatedAt, List<ChatTurnDto> turns
});




}
/// @nodoc
class __$ChatSessionDtoCopyWithImpl<$Res>
    implements _$ChatSessionDtoCopyWith<$Res> {
  __$ChatSessionDtoCopyWithImpl(this._self, this._then);

  final _ChatSessionDto _self;
  final $Res Function(_ChatSessionDto) _then;

/// Create a copy of ChatSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? turns = null,}) {
  return _then(_ChatSessionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,turns: null == turns ? _self.turns : turns // ignore: cast_nullable_to_non_nullable
as List<ChatTurnDto>,
  ));
}


}

// dart format on
