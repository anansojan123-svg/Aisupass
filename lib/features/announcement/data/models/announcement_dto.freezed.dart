// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcement_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnnouncementDto {

 AnnouncementMsgDto get msg;
/// Create a copy of AnnouncementDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementDtoCopyWith<AnnouncementDto> get copyWith => _$AnnouncementDtoCopyWithImpl<AnnouncementDto>(this as AnnouncementDto, _$identity);

  /// Serializes this AnnouncementDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementDto&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,msg);

@override
String toString() {
  return 'AnnouncementDto(msg: $msg)';
}


}

/// @nodoc
abstract mixin class $AnnouncementDtoCopyWith<$Res>  {
  factory $AnnouncementDtoCopyWith(AnnouncementDto value, $Res Function(AnnouncementDto) _then) = _$AnnouncementDtoCopyWithImpl;
@useResult
$Res call({
 AnnouncementMsgDto msg
});


$AnnouncementMsgDtoCopyWith<$Res> get msg;

}
/// @nodoc
class _$AnnouncementDtoCopyWithImpl<$Res>
    implements $AnnouncementDtoCopyWith<$Res> {
  _$AnnouncementDtoCopyWithImpl(this._self, this._then);

  final AnnouncementDto _self;
  final $Res Function(AnnouncementDto) _then;

/// Create a copy of AnnouncementDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? msg = null,}) {
  return _then(_self.copyWith(
msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as AnnouncementMsgDto,
  ));
}
/// Create a copy of AnnouncementDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnnouncementMsgDtoCopyWith<$Res> get msg {
  
  return $AnnouncementMsgDtoCopyWith<$Res>(_self.msg, (value) {
    return _then(_self.copyWith(msg: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnnouncementDto].
extension AnnouncementDtoPatterns on AnnouncementDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnouncementDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnouncementDto value)  $default,){
final _that = this;
switch (_that) {
case _AnnouncementDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnouncementDto value)?  $default,){
final _that = this;
switch (_that) {
case _AnnouncementDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnnouncementMsgDto msg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementDto() when $default != null:
return $default(_that.msg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnnouncementMsgDto msg)  $default,) {final _that = this;
switch (_that) {
case _AnnouncementDto():
return $default(_that.msg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnnouncementMsgDto msg)?  $default,) {final _that = this;
switch (_that) {
case _AnnouncementDto() when $default != null:
return $default(_that.msg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnnouncementDto extends AnnouncementDto {
  const _AnnouncementDto({this.msg = const AnnouncementMsgDto()}): super._();
  factory _AnnouncementDto.fromJson(Map<String, dynamic> json) => _$AnnouncementDtoFromJson(json);

@override@JsonKey() final  AnnouncementMsgDto msg;

/// Create a copy of AnnouncementDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementDtoCopyWith<_AnnouncementDto> get copyWith => __$AnnouncementDtoCopyWithImpl<_AnnouncementDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnouncementDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementDto&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,msg);

@override
String toString() {
  return 'AnnouncementDto(msg: $msg)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementDtoCopyWith<$Res> implements $AnnouncementDtoCopyWith<$Res> {
  factory _$AnnouncementDtoCopyWith(_AnnouncementDto value, $Res Function(_AnnouncementDto) _then) = __$AnnouncementDtoCopyWithImpl;
@override @useResult
$Res call({
 AnnouncementMsgDto msg
});


@override $AnnouncementMsgDtoCopyWith<$Res> get msg;

}
/// @nodoc
class __$AnnouncementDtoCopyWithImpl<$Res>
    implements _$AnnouncementDtoCopyWith<$Res> {
  __$AnnouncementDtoCopyWithImpl(this._self, this._then);

  final _AnnouncementDto _self;
  final $Res Function(_AnnouncementDto) _then;

/// Create a copy of AnnouncementDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? msg = null,}) {
  return _then(_AnnouncementDto(
msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as AnnouncementMsgDto,
  ));
}

/// Create a copy of AnnouncementDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnnouncementMsgDtoCopyWith<$Res> get msg {
  
  return $AnnouncementMsgDtoCopyWith<$Res>(_self.msg, (value) {
    return _then(_self.copyWith(msg: value));
  });
}
}


/// @nodoc
mixin _$AnnouncementMsgDto {

@JsonKey(name: 'app_gg', fromJson: _asString) String get content;
/// Create a copy of AnnouncementMsgDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementMsgDtoCopyWith<AnnouncementMsgDto> get copyWith => _$AnnouncementMsgDtoCopyWithImpl<AnnouncementMsgDto>(this as AnnouncementMsgDto, _$identity);

  /// Serializes this AnnouncementMsgDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementMsgDto&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'AnnouncementMsgDto(content: $content)';
}


}

/// @nodoc
abstract mixin class $AnnouncementMsgDtoCopyWith<$Res>  {
  factory $AnnouncementMsgDtoCopyWith(AnnouncementMsgDto value, $Res Function(AnnouncementMsgDto) _then) = _$AnnouncementMsgDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'app_gg', fromJson: _asString) String content
});




}
/// @nodoc
class _$AnnouncementMsgDtoCopyWithImpl<$Res>
    implements $AnnouncementMsgDtoCopyWith<$Res> {
  _$AnnouncementMsgDtoCopyWithImpl(this._self, this._then);

  final AnnouncementMsgDto _self;
  final $Res Function(AnnouncementMsgDto) _then;

/// Create a copy of AnnouncementMsgDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnouncementMsgDto].
extension AnnouncementMsgDtoPatterns on AnnouncementMsgDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnouncementMsgDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnouncementMsgDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnouncementMsgDto value)  $default,){
final _that = this;
switch (_that) {
case _AnnouncementMsgDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnouncementMsgDto value)?  $default,){
final _that = this;
switch (_that) {
case _AnnouncementMsgDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'app_gg', fromJson: _asString)  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnouncementMsgDto() when $default != null:
return $default(_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'app_gg', fromJson: _asString)  String content)  $default,) {final _that = this;
switch (_that) {
case _AnnouncementMsgDto():
return $default(_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'app_gg', fromJson: _asString)  String content)?  $default,) {final _that = this;
switch (_that) {
case _AnnouncementMsgDto() when $default != null:
return $default(_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnnouncementMsgDto extends AnnouncementMsgDto {
  const _AnnouncementMsgDto({@JsonKey(name: 'app_gg', fromJson: _asString) this.content = ''}): super._();
  factory _AnnouncementMsgDto.fromJson(Map<String, dynamic> json) => _$AnnouncementMsgDtoFromJson(json);

@override@JsonKey(name: 'app_gg', fromJson: _asString) final  String content;

/// Create a copy of AnnouncementMsgDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementMsgDtoCopyWith<_AnnouncementMsgDto> get copyWith => __$AnnouncementMsgDtoCopyWithImpl<_AnnouncementMsgDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnouncementMsgDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnouncementMsgDto&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'AnnouncementMsgDto(content: $content)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementMsgDtoCopyWith<$Res> implements $AnnouncementMsgDtoCopyWith<$Res> {
  factory _$AnnouncementMsgDtoCopyWith(_AnnouncementMsgDto value, $Res Function(_AnnouncementMsgDto) _then) = __$AnnouncementMsgDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'app_gg', fromJson: _asString) String content
});




}
/// @nodoc
class __$AnnouncementMsgDtoCopyWithImpl<$Res>
    implements _$AnnouncementMsgDtoCopyWith<$Res> {
  __$AnnouncementMsgDtoCopyWithImpl(this._self, this._then);

  final _AnnouncementMsgDto _self;
  final $Res Function(_AnnouncementMsgDto) _then;

/// Create a copy of AnnouncementMsgDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(_AnnouncementMsgDto(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
