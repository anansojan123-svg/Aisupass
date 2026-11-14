// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatUsage {

 int get promptTokens; int get completionTokens;
/// Create a copy of ChatUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatUsageCopyWith<ChatUsage> get copyWith => _$ChatUsageCopyWithImpl<ChatUsage>(this as ChatUsage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatUsage&&(identical(other.promptTokens, promptTokens) || other.promptTokens == promptTokens)&&(identical(other.completionTokens, completionTokens) || other.completionTokens == completionTokens));
}


@override
int get hashCode => Object.hash(runtimeType,promptTokens,completionTokens);

@override
String toString() {
  return 'ChatUsage(promptTokens: $promptTokens, completionTokens: $completionTokens)';
}


}

/// @nodoc
abstract mixin class $ChatUsageCopyWith<$Res>  {
  factory $ChatUsageCopyWith(ChatUsage value, $Res Function(ChatUsage) _then) = _$ChatUsageCopyWithImpl;
@useResult
$Res call({
 int promptTokens, int completionTokens
});




}
/// @nodoc
class _$ChatUsageCopyWithImpl<$Res>
    implements $ChatUsageCopyWith<$Res> {
  _$ChatUsageCopyWithImpl(this._self, this._then);

  final ChatUsage _self;
  final $Res Function(ChatUsage) _then;

/// Create a copy of ChatUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? promptTokens = null,Object? completionTokens = null,}) {
  return _then(_self.copyWith(
promptTokens: null == promptTokens ? _self.promptTokens : promptTokens // ignore: cast_nullable_to_non_nullable
as int,completionTokens: null == completionTokens ? _self.completionTokens : completionTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatUsage].
extension ChatUsagePatterns on ChatUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatUsage value)  $default,){
final _that = this;
switch (_that) {
case _ChatUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatUsage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int promptTokens,  int completionTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatUsage() when $default != null:
return $default(_that.promptTokens,_that.completionTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int promptTokens,  int completionTokens)  $default,) {final _that = this;
switch (_that) {
case _ChatUsage():
return $default(_that.promptTokens,_that.completionTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int promptTokens,  int completionTokens)?  $default,) {final _that = this;
switch (_that) {
case _ChatUsage() when $default != null:
return $default(_that.promptTokens,_that.completionTokens);case _:
  return null;

}
}

}

/// @nodoc


class _ChatUsage extends ChatUsage {
  const _ChatUsage({required this.promptTokens, required this.completionTokens}): super._();
  

@override final  int promptTokens;
@override final  int completionTokens;

/// Create a copy of ChatUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatUsageCopyWith<_ChatUsage> get copyWith => __$ChatUsageCopyWithImpl<_ChatUsage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatUsage&&(identical(other.promptTokens, promptTokens) || other.promptTokens == promptTokens)&&(identical(other.completionTokens, completionTokens) || other.completionTokens == completionTokens));
}


@override
int get hashCode => Object.hash(runtimeType,promptTokens,completionTokens);

@override
String toString() {
  return 'ChatUsage(promptTokens: $promptTokens, completionTokens: $completionTokens)';
}


}

/// @nodoc
abstract mixin class _$ChatUsageCopyWith<$Res> implements $ChatUsageCopyWith<$Res> {
  factory _$ChatUsageCopyWith(_ChatUsage value, $Res Function(_ChatUsage) _then) = __$ChatUsageCopyWithImpl;
@override @useResult
$Res call({
 int promptTokens, int completionTokens
});




}
/// @nodoc
class __$ChatUsageCopyWithImpl<$Res>
    implements _$ChatUsageCopyWith<$Res> {
  __$ChatUsageCopyWithImpl(this._self, this._then);

  final _ChatUsage _self;
  final $Res Function(_ChatUsage) _then;

/// Create a copy of ChatUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? promptTokens = null,Object? completionTokens = null,}) {
  return _then(_ChatUsage(
promptTokens: null == promptTokens ? _self.promptTokens : promptTokens // ignore: cast_nullable_to_non_nullable
as int,completionTokens: null == completionTokens ? _self.completionTokens : completionTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
