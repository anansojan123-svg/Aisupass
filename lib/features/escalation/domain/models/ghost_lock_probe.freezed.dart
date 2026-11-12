// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_probe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostLockProbe {

/// 是否解析成功。
 bool get ok;/// 内核 release，与 `uname -r` 逐字可比。
 String get release;/// 自包含的 GLK profile 文本；失败为空串。
 String get conf;/// 提取过程中的告警，不阻断。
 List<String> get warnings;/// 实际参与解析的 boot 镜像路径；OTA / 直链输入时为解包后的缓存文件。
 String get bootPath;/// 失败原因码；成功为空串。
 String get reason;
/// Create a copy of GhostLockProbe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockProbeCopyWith<GhostLockProbe> get copyWith => _$GhostLockProbeCopyWithImpl<GhostLockProbe>(this as GhostLockProbe, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockProbe&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&(identical(other.conf, conf) || other.conf == conf)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&(identical(other.bootPath, bootPath) || other.bootPath == bootPath)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,ok,release,conf,const DeepCollectionEquality().hash(warnings),bootPath,reason);

@override
String toString() {
  return 'GhostLockProbe(ok: $ok, release: $release, conf: $conf, warnings: $warnings, bootPath: $bootPath, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $GhostLockProbeCopyWith<$Res>  {
  factory $GhostLockProbeCopyWith(GhostLockProbe value, $Res Function(GhostLockProbe) _then) = _$GhostLockProbeCopyWithImpl;
@useResult
$Res call({
 bool ok, String release, String conf, List<String> warnings, String bootPath, String reason
});




}
/// @nodoc
class _$GhostLockProbeCopyWithImpl<$Res>
    implements $GhostLockProbeCopyWith<$Res> {
  _$GhostLockProbeCopyWithImpl(this._self, this._then);

  final GhostLockProbe _self;
  final $Res Function(GhostLockProbe) _then;

/// Create a copy of GhostLockProbe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? release = null,Object? conf = null,Object? warnings = null,Object? bootPath = null,Object? reason = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,conf: null == conf ? _self.conf : conf // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,bootPath: null == bootPath ? _self.bootPath : bootPath // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockProbe].
extension GhostLockProbePatterns on GhostLockProbe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockProbe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockProbe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockProbe value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockProbe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockProbe value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockProbe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String release,  String conf,  List<String> warnings,  String bootPath,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockProbe() when $default != null:
return $default(_that.ok,_that.release,_that.conf,_that.warnings,_that.bootPath,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String release,  String conf,  List<String> warnings,  String bootPath,  String reason)  $default,) {final _that = this;
switch (_that) {
case _GhostLockProbe():
return $default(_that.ok,_that.release,_that.conf,_that.warnings,_that.bootPath,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String release,  String conf,  List<String> warnings,  String bootPath,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockProbe() when $default != null:
return $default(_that.ok,_that.release,_that.conf,_that.warnings,_that.bootPath,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _GhostLockProbe extends GhostLockProbe {
  const _GhostLockProbe({required this.ok, required this.release, required this.conf, required this.warnings, required this.bootPath, required this.reason}): super._();
  

/// 是否解析成功。
@override final  bool ok;
/// 内核 release，与 `uname -r` 逐字可比。
@override final  String release;
/// 自包含的 GLK profile 文本；失败为空串。
@override final  String conf;
/// 提取过程中的告警，不阻断。
@override final  List<String> warnings;
/// 实际参与解析的 boot 镜像路径；OTA / 直链输入时为解包后的缓存文件。
@override final  String bootPath;
/// 失败原因码；成功为空串。
@override final  String reason;

/// Create a copy of GhostLockProbe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockProbeCopyWith<_GhostLockProbe> get copyWith => __$GhostLockProbeCopyWithImpl<_GhostLockProbe>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockProbe&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.release, release) || other.release == release)&&(identical(other.conf, conf) || other.conf == conf)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&(identical(other.bootPath, bootPath) || other.bootPath == bootPath)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,ok,release,conf,const DeepCollectionEquality().hash(warnings),bootPath,reason);

@override
String toString() {
  return 'GhostLockProbe(ok: $ok, release: $release, conf: $conf, warnings: $warnings, bootPath: $bootPath, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$GhostLockProbeCopyWith<$Res> implements $GhostLockProbeCopyWith<$Res> {
  factory _$GhostLockProbeCopyWith(_GhostLockProbe value, $Res Function(_GhostLockProbe) _then) = __$GhostLockProbeCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String release, String conf, List<String> warnings, String bootPath, String reason
});




}
/// @nodoc
class __$GhostLockProbeCopyWithImpl<$Res>
    implements _$GhostLockProbeCopyWith<$Res> {
  __$GhostLockProbeCopyWithImpl(this._self, this._then);

  final _GhostLockProbe _self;
  final $Res Function(_GhostLockProbe) _then;

/// Create a copy of GhostLockProbe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? release = null,Object? conf = null,Object? warnings = null,Object? bootPath = null,Object? reason = null,}) {
  return _then(_GhostLockProbe(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,conf: null == conf ? _self.conf : conf // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,bootPath: null == bootPath ? _self.bootPath : bootPath // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
