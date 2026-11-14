// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_tool_call.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatToolCall {

 String get callId; String get name; String get argumentsJson; ChatToolStatus get status; String get result; String get error; Duration get duration;
/// Create a copy of ChatToolCall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatToolCallCopyWith<ChatToolCall> get copyWith => _$ChatToolCallCopyWithImpl<ChatToolCall>(this as ChatToolCall, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatToolCall&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.name, name) || other.name == name)&&(identical(other.argumentsJson, argumentsJson) || other.argumentsJson == argumentsJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.result, result) || other.result == result)&&(identical(other.error, error) || other.error == error)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,callId,name,argumentsJson,status,result,error,duration);

@override
String toString() {
  return 'ChatToolCall(callId: $callId, name: $name, argumentsJson: $argumentsJson, status: $status, result: $result, error: $error, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $ChatToolCallCopyWith<$Res>  {
  factory $ChatToolCallCopyWith(ChatToolCall value, $Res Function(ChatToolCall) _then) = _$ChatToolCallCopyWithImpl;
@useResult
$Res call({
 String callId, String name, String argumentsJson, ChatToolStatus status, String result, String error, Duration duration
});




}
/// @nodoc
class _$ChatToolCallCopyWithImpl<$Res>
    implements $ChatToolCallCopyWith<$Res> {
  _$ChatToolCallCopyWithImpl(this._self, this._then);

  final ChatToolCall _self;
  final $Res Function(ChatToolCall) _then;

/// Create a copy of ChatToolCall
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? name = null,Object? argumentsJson = null,Object? status = null,Object? result = null,Object? error = null,Object? duration = null,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,argumentsJson: null == argumentsJson ? _self.argumentsJson : argumentsJson // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChatToolStatus,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatToolCall].
extension ChatToolCallPatterns on ChatToolCall {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatToolCall value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatToolCall() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatToolCall value)  $default,){
final _that = this;
switch (_that) {
case _ChatToolCall():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatToolCall value)?  $default,){
final _that = this;
switch (_that) {
case _ChatToolCall() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String name,  String argumentsJson,  ChatToolStatus status,  String result,  String error,  Duration duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatToolCall() when $default != null:
return $default(_that.callId,_that.name,_that.argumentsJson,_that.status,_that.result,_that.error,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String name,  String argumentsJson,  ChatToolStatus status,  String result,  String error,  Duration duration)  $default,) {final _that = this;
switch (_that) {
case _ChatToolCall():
return $default(_that.callId,_that.name,_that.argumentsJson,_that.status,_that.result,_that.error,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String name,  String argumentsJson,  ChatToolStatus status,  String result,  String error,  Duration duration)?  $default,) {final _that = this;
switch (_that) {
case _ChatToolCall() when $default != null:
return $default(_that.callId,_that.name,_that.argumentsJson,_that.status,_that.result,_that.error,_that.duration);case _:
  return null;

}
}

}

/// @nodoc


class _ChatToolCall extends ChatToolCall {
  const _ChatToolCall({required this.callId, required this.name, required this.argumentsJson, required this.status, required this.result, required this.error, required this.duration}): super._();
  

@override final  String callId;
@override final  String name;
@override final  String argumentsJson;
@override final  ChatToolStatus status;
@override final  String result;
@override final  String error;
@override final  Duration duration;

/// Create a copy of ChatToolCall
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatToolCallCopyWith<_ChatToolCall> get copyWith => __$ChatToolCallCopyWithImpl<_ChatToolCall>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatToolCall&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.name, name) || other.name == name)&&(identical(other.argumentsJson, argumentsJson) || other.argumentsJson == argumentsJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.result, result) || other.result == result)&&(identical(other.error, error) || other.error == error)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,callId,name,argumentsJson,status,result,error,duration);

@override
String toString() {
  return 'ChatToolCall(callId: $callId, name: $name, argumentsJson: $argumentsJson, status: $status, result: $result, error: $error, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$ChatToolCallCopyWith<$Res> implements $ChatToolCallCopyWith<$Res> {
  factory _$ChatToolCallCopyWith(_ChatToolCall value, $Res Function(_ChatToolCall) _then) = __$ChatToolCallCopyWithImpl;
@override @useResult
$Res call({
 String callId, String name, String argumentsJson, ChatToolStatus status, String result, String error, Duration duration
});




}
/// @nodoc
class __$ChatToolCallCopyWithImpl<$Res>
    implements _$ChatToolCallCopyWith<$Res> {
  __$ChatToolCallCopyWithImpl(this._self, this._then);

  final _ChatToolCall _self;
  final $Res Function(_ChatToolCall) _then;

/// Create a copy of ChatToolCall
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? name = null,Object? argumentsJson = null,Object? status = null,Object? result = null,Object? error = null,Object? duration = null,}) {
  return _then(_ChatToolCall(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,argumentsJson: null == argumentsJson ? _self.argumentsJson : argumentsJson // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChatToolStatus,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
