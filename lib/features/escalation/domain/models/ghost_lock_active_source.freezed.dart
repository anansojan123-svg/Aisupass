// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_active_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostLockActiveSource {

 String get builtin; String get user;
/// Create a copy of GhostLockActiveSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockActiveSourceCopyWith<GhostLockActiveSource> get copyWith => _$GhostLockActiveSourceCopyWithImpl<GhostLockActiveSource>(this as GhostLockActiveSource, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockActiveSource&&(identical(other.builtin, builtin) || other.builtin == builtin)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,builtin,user);

@override
String toString() {
  return 'GhostLockActiveSource(builtin: $builtin, user: $user)';
}


}

/// @nodoc
abstract mixin class $GhostLockActiveSourceCopyWith<$Res>  {
  factory $GhostLockActiveSourceCopyWith(GhostLockActiveSource value, $Res Function(GhostLockActiveSource) _then) = _$GhostLockActiveSourceCopyWithImpl;
@useResult
$Res call({
 String builtin, String user
});




}
/// @nodoc
class _$GhostLockActiveSourceCopyWithImpl<$Res>
    implements $GhostLockActiveSourceCopyWith<$Res> {
  _$GhostLockActiveSourceCopyWithImpl(this._self, this._then);

  final GhostLockActiveSource _self;
  final $Res Function(GhostLockActiveSource) _then;

/// Create a copy of GhostLockActiveSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? builtin = null,Object? user = null,}) {
  return _then(_self.copyWith(
builtin: null == builtin ? _self.builtin : builtin // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockActiveSource].
extension GhostLockActiveSourcePatterns on GhostLockActiveSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockActiveSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockActiveSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockActiveSource value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockActiveSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockActiveSource value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockActiveSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String builtin,  String user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockActiveSource() when $default != null:
return $default(_that.builtin,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String builtin,  String user)  $default,) {final _that = this;
switch (_that) {
case _GhostLockActiveSource():
return $default(_that.builtin,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String builtin,  String user)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockActiveSource() when $default != null:
return $default(_that.builtin,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _GhostLockActiveSource extends GhostLockActiveSource {
  const _GhostLockActiveSource({required this.builtin, required this.user}): super._();
  

@override final  String builtin;
@override final  String user;

/// Create a copy of GhostLockActiveSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockActiveSourceCopyWith<_GhostLockActiveSource> get copyWith => __$GhostLockActiveSourceCopyWithImpl<_GhostLockActiveSource>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockActiveSource&&(identical(other.builtin, builtin) || other.builtin == builtin)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,builtin,user);

@override
String toString() {
  return 'GhostLockActiveSource(builtin: $builtin, user: $user)';
}


}

/// @nodoc
abstract mixin class _$GhostLockActiveSourceCopyWith<$Res> implements $GhostLockActiveSourceCopyWith<$Res> {
  factory _$GhostLockActiveSourceCopyWith(_GhostLockActiveSource value, $Res Function(_GhostLockActiveSource) _then) = __$GhostLockActiveSourceCopyWithImpl;
@override @useResult
$Res call({
 String builtin, String user
});




}
/// @nodoc
class __$GhostLockActiveSourceCopyWithImpl<$Res>
    implements _$GhostLockActiveSourceCopyWith<$Res> {
  __$GhostLockActiveSourceCopyWithImpl(this._self, this._then);

  final _GhostLockActiveSource _self;
  final $Res Function(_GhostLockActiveSource) _then;

/// Create a copy of GhostLockActiveSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? builtin = null,Object? user = null,}) {
  return _then(_GhostLockActiveSource(
builtin: null == builtin ? _self.builtin : builtin // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
