// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_tool_call_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatToolCallDto {

 String get callId; String get name; String get argumentsJson; String get status; String get result; String get error; int get durationMs;
/// Create a copy of ChatToolCallDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatToolCallDtoCopyWith<ChatToolCallDto> get copyWith => _$ChatToolCallDtoCopyWithImpl<ChatToolCallDto>(this as ChatToolCallDto, _$identity);

  /// Serializes this ChatToolCallDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatToolCallDto&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.name, name) || other.name == name)&&(identical(other.argumentsJson, argumentsJson) || other.argumentsJson == argumentsJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.result, result) || other.result == result)&&(identical(other.error, error) || other.error == error)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,name,argumentsJson,status,result,error,durationMs);

@override
String toString() {
  return 'ChatToolCallDto(callId: $callId, name: $name, argumentsJson: $argumentsJson, status: $status, result: $result, error: $error, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class $ChatToolCallDtoCopyWith<$Res>  {
  factory $ChatToolCallDtoCopyWith(ChatToolCallDto value, $Res Function(ChatToolCallDto) _then) = _$ChatToolCallDtoCopyWithImpl;
@useResult
$Res call({
 String callId, String name, String argumentsJson, String status, String result, String error, int durationMs
});




}
/// @nodoc
class _$ChatToolCallDtoCopyWithImpl<$Res>
    implements $ChatToolCallDtoCopyWith<$Res> {
  _$ChatToolCallDtoCopyWithImpl(this._self, this._then);

  final ChatToolCallDto _self;
  final $Res Function(ChatToolCallDto) _then;

/// Create a copy of ChatToolCallDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? name = null,Object? argumentsJson = null,Object? status = null,Object? result = null,Object? error = null,Object? durationMs = null,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,argumentsJson: null == argumentsJson ? _self.argumentsJson : argumentsJson // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatToolCallDto].
extension ChatToolCallDtoPatterns on ChatToolCallDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatToolCallDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatToolCallDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatToolCallDto value)  $default,){
final _that = this;
switch (_that) {
case _ChatToolCallDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatToolCallDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChatToolCallDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String name,  String argumentsJson,  String status,  String result,  String error,  int durationMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatToolCallDto() when $default != null:
return $default(_that.callId,_that.name,_that.argumentsJson,_that.status,_that.result,_that.error,_that.durationMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String name,  String argumentsJson,  String status,  String result,  String error,  int durationMs)  $default,) {final _that = this;
switch (_that) {
case _ChatToolCallDto():
return $default(_that.callId,_that.name,_that.argumentsJson,_that.status,_that.result,_that.error,_that.durationMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String name,  String argumentsJson,  String status,  String result,  String error,  int durationMs)?  $default,) {final _that = this;
switch (_that) {
case _ChatToolCallDto() when $default != null:
return $default(_that.callId,_that.name,_that.argumentsJson,_that.status,_that.result,_that.error,_that.durationMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatToolCallDto extends ChatToolCallDto {
  const _ChatToolCallDto({this.callId = '', this.name = '', this.argumentsJson = '', this.status = '', this.result = '', this.error = '', this.durationMs = 0}): super._();
  factory _ChatToolCallDto.fromJson(Map<String, dynamic> json) => _$ChatToolCallDtoFromJson(json);

@override@JsonKey() final  String callId;
@override@JsonKey() final  String name;
@override@JsonKey() final  String argumentsJson;
@override@JsonKey() final  String status;
@override@JsonKey() final  String result;
@override@JsonKey() final  String error;
@override@JsonKey() final  int durationMs;

/// Create a copy of ChatToolCallDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatToolCallDtoCopyWith<_ChatToolCallDto> get copyWith => __$ChatToolCallDtoCopyWithImpl<_ChatToolCallDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatToolCallDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatToolCallDto&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.name, name) || other.name == name)&&(identical(other.argumentsJson, argumentsJson) || other.argumentsJson == argumentsJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.result, result) || other.result == result)&&(identical(other.error, error) || other.error == error)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,name,argumentsJson,status,result,error,durationMs);

@override
String toString() {
  return 'ChatToolCallDto(callId: $callId, name: $name, argumentsJson: $argumentsJson, status: $status, result: $result, error: $error, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class _$ChatToolCallDtoCopyWith<$Res> implements $ChatToolCallDtoCopyWith<$Res> {
  factory _$ChatToolCallDtoCopyWith(_ChatToolCallDto value, $Res Function(_ChatToolCallDto) _then) = __$ChatToolCallDtoCopyWithImpl;
@override @useResult
$Res call({
 String callId, String name, String argumentsJson, String status, String result, String error, int durationMs
});




}
/// @nodoc
class __$ChatToolCallDtoCopyWithImpl<$Res>
    implements _$ChatToolCallDtoCopyWith<$Res> {
  __$ChatToolCallDtoCopyWithImpl(this._self, this._then);

  final _ChatToolCallDto _self;
  final $Res Function(_ChatToolCallDto) _then;

/// Create a copy of ChatToolCallDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? name = null,Object? argumentsJson = null,Object? status = null,Object? result = null,Object? error = null,Object? durationMs = null,}) {
  return _then(_ChatToolCallDto(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,argumentsJson: null == argumentsJson ? _self.argumentsJson : argumentsJson // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
