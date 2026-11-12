// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_probe_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostLockProbeProgress {

/// 阶段：0 下载，1 解包与解析，2 完成。
 int get phase;/// 本阶段已完成量。
 int get done;/// 本阶段总量；未知时为 `0`。
 int get total;
/// Create a copy of GhostLockProbeProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockProbeProgressCopyWith<GhostLockProbeProgress> get copyWith => _$GhostLockProbeProgressCopyWithImpl<GhostLockProbeProgress>(this as GhostLockProbeProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockProbeProgress&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,phase,done,total);

@override
String toString() {
  return 'GhostLockProbeProgress(phase: $phase, done: $done, total: $total)';
}


}

/// @nodoc
abstract mixin class $GhostLockProbeProgressCopyWith<$Res>  {
  factory $GhostLockProbeProgressCopyWith(GhostLockProbeProgress value, $Res Function(GhostLockProbeProgress) _then) = _$GhostLockProbeProgressCopyWithImpl;
@useResult
$Res call({
 int phase, int done, int total
});




}
/// @nodoc
class _$GhostLockProbeProgressCopyWithImpl<$Res>
    implements $GhostLockProbeProgressCopyWith<$Res> {
  _$GhostLockProbeProgressCopyWithImpl(this._self, this._then);

  final GhostLockProbeProgress _self;
  final $Res Function(GhostLockProbeProgress) _then;

/// Create a copy of GhostLockProbeProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? done = null,Object? total = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockProbeProgress].
extension GhostLockProbeProgressPatterns on GhostLockProbeProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockProbeProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockProbeProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockProbeProgress value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockProbeProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockProbeProgress value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockProbeProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int phase,  int done,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockProbeProgress() when $default != null:
return $default(_that.phase,_that.done,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int phase,  int done,  int total)  $default,) {final _that = this;
switch (_that) {
case _GhostLockProbeProgress():
return $default(_that.phase,_that.done,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int phase,  int done,  int total)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockProbeProgress() when $default != null:
return $default(_that.phase,_that.done,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _GhostLockProbeProgress extends GhostLockProbeProgress {
  const _GhostLockProbeProgress({required this.phase, required this.done, required this.total}): super._();
  

/// 阶段：0 下载，1 解包与解析，2 完成。
@override final  int phase;
/// 本阶段已完成量。
@override final  int done;
/// 本阶段总量；未知时为 `0`。
@override final  int total;

/// Create a copy of GhostLockProbeProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockProbeProgressCopyWith<_GhostLockProbeProgress> get copyWith => __$GhostLockProbeProgressCopyWithImpl<_GhostLockProbeProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockProbeProgress&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,phase,done,total);

@override
String toString() {
  return 'GhostLockProbeProgress(phase: $phase, done: $done, total: $total)';
}


}

/// @nodoc
abstract mixin class _$GhostLockProbeProgressCopyWith<$Res> implements $GhostLockProbeProgressCopyWith<$Res> {
  factory _$GhostLockProbeProgressCopyWith(_GhostLockProbeProgress value, $Res Function(_GhostLockProbeProgress) _then) = __$GhostLockProbeProgressCopyWithImpl;
@override @useResult
$Res call({
 int phase, int done, int total
});




}
/// @nodoc
class __$GhostLockProbeProgressCopyWithImpl<$Res>
    implements _$GhostLockProbeProgressCopyWith<$Res> {
  __$GhostLockProbeProgressCopyWithImpl(this._self, this._then);

  final _GhostLockProbeProgress _self;
  final $Res Function(_GhostLockProbeProgress) _then;

/// Create a copy of GhostLockProbeProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? done = null,Object? total = null,}) {
  return _then(_GhostLockProbeProgress(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
