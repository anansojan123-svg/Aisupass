// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kernel_profile_import_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KernelProfileImportState {

 int get phase; int get done; int get total; KernelProfileImportResult get result;
/// Create a copy of KernelProfileImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KernelProfileImportStateCopyWith<KernelProfileImportState> get copyWith => _$KernelProfileImportStateCopyWithImpl<KernelProfileImportState>(this as KernelProfileImportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KernelProfileImportState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,phase,done,total,result);

@override
String toString() {
  return 'KernelProfileImportState(phase: $phase, done: $done, total: $total, result: $result)';
}


}

/// @nodoc
abstract mixin class $KernelProfileImportStateCopyWith<$Res>  {
  factory $KernelProfileImportStateCopyWith(KernelProfileImportState value, $Res Function(KernelProfileImportState) _then) = _$KernelProfileImportStateCopyWithImpl;
@useResult
$Res call({
 int phase, int done, int total, KernelProfileImportResult result
});


$KernelProfileImportResultCopyWith<$Res> get result;

}
/// @nodoc
class _$KernelProfileImportStateCopyWithImpl<$Res>
    implements $KernelProfileImportStateCopyWith<$Res> {
  _$KernelProfileImportStateCopyWithImpl(this._self, this._then);

  final KernelProfileImportState _self;
  final $Res Function(KernelProfileImportState) _then;

/// Create a copy of KernelProfileImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? done = null,Object? total = null,Object? result = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as KernelProfileImportResult,
  ));
}
/// Create a copy of KernelProfileImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KernelProfileImportResultCopyWith<$Res> get result {
  
  return $KernelProfileImportResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [KernelProfileImportState].
extension KernelProfileImportStatePatterns on KernelProfileImportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KernelProfileImportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KernelProfileImportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KernelProfileImportState value)  $default,){
final _that = this;
switch (_that) {
case _KernelProfileImportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KernelProfileImportState value)?  $default,){
final _that = this;
switch (_that) {
case _KernelProfileImportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int phase,  int done,  int total,  KernelProfileImportResult result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KernelProfileImportState() when $default != null:
return $default(_that.phase,_that.done,_that.total,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int phase,  int done,  int total,  KernelProfileImportResult result)  $default,) {final _that = this;
switch (_that) {
case _KernelProfileImportState():
return $default(_that.phase,_that.done,_that.total,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int phase,  int done,  int total,  KernelProfileImportResult result)?  $default,) {final _that = this;
switch (_that) {
case _KernelProfileImportState() when $default != null:
return $default(_that.phase,_that.done,_that.total,_that.result);case _:
  return null;

}
}

}

/// @nodoc


class _KernelProfileImportState extends KernelProfileImportState {
  const _KernelProfileImportState({required this.phase, required this.done, required this.total, required this.result}): super._();
  

@override final  int phase;
@override final  int done;
@override final  int total;
@override final  KernelProfileImportResult result;

/// Create a copy of KernelProfileImportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KernelProfileImportStateCopyWith<_KernelProfileImportState> get copyWith => __$KernelProfileImportStateCopyWithImpl<_KernelProfileImportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KernelProfileImportState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.done, done) || other.done == done)&&(identical(other.total, total) || other.total == total)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,phase,done,total,result);

@override
String toString() {
  return 'KernelProfileImportState(phase: $phase, done: $done, total: $total, result: $result)';
}


}

/// @nodoc
abstract mixin class _$KernelProfileImportStateCopyWith<$Res> implements $KernelProfileImportStateCopyWith<$Res> {
  factory _$KernelProfileImportStateCopyWith(_KernelProfileImportState value, $Res Function(_KernelProfileImportState) _then) = __$KernelProfileImportStateCopyWithImpl;
@override @useResult
$Res call({
 int phase, int done, int total, KernelProfileImportResult result
});


@override $KernelProfileImportResultCopyWith<$Res> get result;

}
/// @nodoc
class __$KernelProfileImportStateCopyWithImpl<$Res>
    implements _$KernelProfileImportStateCopyWith<$Res> {
  __$KernelProfileImportStateCopyWithImpl(this._self, this._then);

  final _KernelProfileImportState _self;
  final $Res Function(_KernelProfileImportState) _then;

/// Create a copy of KernelProfileImportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? done = null,Object? total = null,Object? result = null,}) {
  return _then(_KernelProfileImportState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as int,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as KernelProfileImportResult,
  ));
}

/// Create a copy of KernelProfileImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KernelProfileImportResultCopyWith<$Res> get result {
  
  return $KernelProfileImportResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
