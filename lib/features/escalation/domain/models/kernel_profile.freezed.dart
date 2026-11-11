// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kernel_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KernelProfile {

 String get release; String get detail;
/// Create a copy of KernelProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KernelProfileCopyWith<KernelProfile> get copyWith => _$KernelProfileCopyWithImpl<KernelProfile>(this as KernelProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KernelProfile&&(identical(other.release, release) || other.release == release)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,release,detail);

@override
String toString() {
  return 'KernelProfile(release: $release, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $KernelProfileCopyWith<$Res>  {
  factory $KernelProfileCopyWith(KernelProfile value, $Res Function(KernelProfile) _then) = _$KernelProfileCopyWithImpl;
@useResult
$Res call({
 String release, String detail
});




}
/// @nodoc
class _$KernelProfileCopyWithImpl<$Res>
    implements $KernelProfileCopyWith<$Res> {
  _$KernelProfileCopyWithImpl(this._self, this._then);

  final KernelProfile _self;
  final $Res Function(KernelProfile) _then;

/// Create a copy of KernelProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? release = null,Object? detail = null,}) {
  return _then(_self.copyWith(
release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KernelProfile].
extension KernelProfilePatterns on KernelProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KernelProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KernelProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KernelProfile value)  $default,){
final _that = this;
switch (_that) {
case _KernelProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KernelProfile value)?  $default,){
final _that = this;
switch (_that) {
case _KernelProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String release,  String detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KernelProfile() when $default != null:
return $default(_that.release,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String release,  String detail)  $default,) {final _that = this;
switch (_that) {
case _KernelProfile():
return $default(_that.release,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String release,  String detail)?  $default,) {final _that = this;
switch (_that) {
case _KernelProfile() when $default != null:
return $default(_that.release,_that.detail);case _:
  return null;

}
}

}

/// @nodoc


class _KernelProfile extends KernelProfile {
  const _KernelProfile({required this.release, required this.detail}): super._();
  

@override final  String release;
@override final  String detail;

/// Create a copy of KernelProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KernelProfileCopyWith<_KernelProfile> get copyWith => __$KernelProfileCopyWithImpl<_KernelProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KernelProfile&&(identical(other.release, release) || other.release == release)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,release,detail);

@override
String toString() {
  return 'KernelProfile(release: $release, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$KernelProfileCopyWith<$Res> implements $KernelProfileCopyWith<$Res> {
  factory _$KernelProfileCopyWith(_KernelProfile value, $Res Function(_KernelProfile) _then) = __$KernelProfileCopyWithImpl;
@override @useResult
$Res call({
 String release, String detail
});




}
/// @nodoc
class __$KernelProfileCopyWithImpl<$Res>
    implements _$KernelProfileCopyWith<$Res> {
  __$KernelProfileCopyWithImpl(this._self, this._then);

  final _KernelProfile _self;
  final $Res Function(_KernelProfile) _then;

/// Create a copy of KernelProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? release = null,Object? detail = null,}) {
  return _then(_KernelProfile(
release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
