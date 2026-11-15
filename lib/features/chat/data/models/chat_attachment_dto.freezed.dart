// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_attachment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatAttachmentDto {

 String get id; String get name; String get path; String get mimeType; int get size; String get kind;
/// Create a copy of ChatAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatAttachmentDtoCopyWith<ChatAttachmentDto> get copyWith => _$ChatAttachmentDtoCopyWithImpl<ChatAttachmentDto>(this as ChatAttachmentDto, _$identity);

  /// Serializes this ChatAttachmentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatAttachmentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.size, size) || other.size == size)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,path,mimeType,size,kind);

@override
String toString() {
  return 'ChatAttachmentDto(id: $id, name: $name, path: $path, mimeType: $mimeType, size: $size, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $ChatAttachmentDtoCopyWith<$Res>  {
  factory $ChatAttachmentDtoCopyWith(ChatAttachmentDto value, $Res Function(ChatAttachmentDto) _then) = _$ChatAttachmentDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String path, String mimeType, int size, String kind
});




}
/// @nodoc
class _$ChatAttachmentDtoCopyWithImpl<$Res>
    implements $ChatAttachmentDtoCopyWith<$Res> {
  _$ChatAttachmentDtoCopyWithImpl(this._self, this._then);

  final ChatAttachmentDto _self;
  final $Res Function(ChatAttachmentDto) _then;

/// Create a copy of ChatAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? path = null,Object? mimeType = null,Object? size = null,Object? kind = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatAttachmentDto].
extension ChatAttachmentDtoPatterns on ChatAttachmentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatAttachmentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatAttachmentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatAttachmentDto value)  $default,){
final _that = this;
switch (_that) {
case _ChatAttachmentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatAttachmentDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChatAttachmentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String path,  String mimeType,  int size,  String kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatAttachmentDto() when $default != null:
return $default(_that.id,_that.name,_that.path,_that.mimeType,_that.size,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String path,  String mimeType,  int size,  String kind)  $default,) {final _that = this;
switch (_that) {
case _ChatAttachmentDto():
return $default(_that.id,_that.name,_that.path,_that.mimeType,_that.size,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String path,  String mimeType,  int size,  String kind)?  $default,) {final _that = this;
switch (_that) {
case _ChatAttachmentDto() when $default != null:
return $default(_that.id,_that.name,_that.path,_that.mimeType,_that.size,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatAttachmentDto extends ChatAttachmentDto {
  const _ChatAttachmentDto({this.id = '', this.name = '', this.path = '', this.mimeType = '', this.size = 0, this.kind = ''}): super._();
  factory _ChatAttachmentDto.fromJson(Map<String, dynamic> json) => _$ChatAttachmentDtoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String path;
@override@JsonKey() final  String mimeType;
@override@JsonKey() final  int size;
@override@JsonKey() final  String kind;

/// Create a copy of ChatAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatAttachmentDtoCopyWith<_ChatAttachmentDto> get copyWith => __$ChatAttachmentDtoCopyWithImpl<_ChatAttachmentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatAttachmentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatAttachmentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.size, size) || other.size == size)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,path,mimeType,size,kind);

@override
String toString() {
  return 'ChatAttachmentDto(id: $id, name: $name, path: $path, mimeType: $mimeType, size: $size, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$ChatAttachmentDtoCopyWith<$Res> implements $ChatAttachmentDtoCopyWith<$Res> {
  factory _$ChatAttachmentDtoCopyWith(_ChatAttachmentDto value, $Res Function(_ChatAttachmentDto) _then) = __$ChatAttachmentDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String path, String mimeType, int size, String kind
});




}
/// @nodoc
class __$ChatAttachmentDtoCopyWithImpl<$Res>
    implements _$ChatAttachmentDtoCopyWith<$Res> {
  __$ChatAttachmentDtoCopyWithImpl(this._self, this._then);

  final _ChatAttachmentDto _self;
  final $Res Function(_ChatAttachmentDto) _then;

/// Create a copy of ChatAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? path = null,Object? mimeType = null,Object? size = null,Object? kind = null,}) {
  return _then(_ChatAttachmentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
