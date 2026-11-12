// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ghost_lock_user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GhostLockUserProfile {

/// 文件名，唯一标识。
 String get name;/// 文档里声明的内核 release；解析失败为空串。
 String get release;/// 文件字节数。
 int get sizeBytes;/// 导入时间（毫秒时间戳）。
 int get importedAtMs;/// 文本无法解析出 release。
 bool get parseError;
/// Create a copy of GhostLockUserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GhostLockUserProfileCopyWith<GhostLockUserProfile> get copyWith => _$GhostLockUserProfileCopyWithImpl<GhostLockUserProfile>(this as GhostLockUserProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GhostLockUserProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.release, release) || other.release == release)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.importedAtMs, importedAtMs) || other.importedAtMs == importedAtMs)&&(identical(other.parseError, parseError) || other.parseError == parseError));
}


@override
int get hashCode => Object.hash(runtimeType,name,release,sizeBytes,importedAtMs,parseError);

@override
String toString() {
  return 'GhostLockUserProfile(name: $name, release: $release, sizeBytes: $sizeBytes, importedAtMs: $importedAtMs, parseError: $parseError)';
}


}

/// @nodoc
abstract mixin class $GhostLockUserProfileCopyWith<$Res>  {
  factory $GhostLockUserProfileCopyWith(GhostLockUserProfile value, $Res Function(GhostLockUserProfile) _then) = _$GhostLockUserProfileCopyWithImpl;
@useResult
$Res call({
 String name, String release, int sizeBytes, int importedAtMs, bool parseError
});




}
/// @nodoc
class _$GhostLockUserProfileCopyWithImpl<$Res>
    implements $GhostLockUserProfileCopyWith<$Res> {
  _$GhostLockUserProfileCopyWithImpl(this._self, this._then);

  final GhostLockUserProfile _self;
  final $Res Function(GhostLockUserProfile) _then;

/// Create a copy of GhostLockUserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? release = null,Object? sizeBytes = null,Object? importedAtMs = null,Object? parseError = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,importedAtMs: null == importedAtMs ? _self.importedAtMs : importedAtMs // ignore: cast_nullable_to_non_nullable
as int,parseError: null == parseError ? _self.parseError : parseError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GhostLockUserProfile].
extension GhostLockUserProfilePatterns on GhostLockUserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GhostLockUserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GhostLockUserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GhostLockUserProfile value)  $default,){
final _that = this;
switch (_that) {
case _GhostLockUserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GhostLockUserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _GhostLockUserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String release,  int sizeBytes,  int importedAtMs,  bool parseError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GhostLockUserProfile() when $default != null:
return $default(_that.name,_that.release,_that.sizeBytes,_that.importedAtMs,_that.parseError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String release,  int sizeBytes,  int importedAtMs,  bool parseError)  $default,) {final _that = this;
switch (_that) {
case _GhostLockUserProfile():
return $default(_that.name,_that.release,_that.sizeBytes,_that.importedAtMs,_that.parseError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String release,  int sizeBytes,  int importedAtMs,  bool parseError)?  $default,) {final _that = this;
switch (_that) {
case _GhostLockUserProfile() when $default != null:
return $default(_that.name,_that.release,_that.sizeBytes,_that.importedAtMs,_that.parseError);case _:
  return null;

}
}

}

/// @nodoc


class _GhostLockUserProfile extends GhostLockUserProfile {
  const _GhostLockUserProfile({required this.name, required this.release, required this.sizeBytes, required this.importedAtMs, required this.parseError}): super._();
  

/// 文件名，唯一标识。
@override final  String name;
/// 文档里声明的内核 release；解析失败为空串。
@override final  String release;
/// 文件字节数。
@override final  int sizeBytes;
/// 导入时间（毫秒时间戳）。
@override final  int importedAtMs;
/// 文本无法解析出 release。
@override final  bool parseError;

/// Create a copy of GhostLockUserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GhostLockUserProfileCopyWith<_GhostLockUserProfile> get copyWith => __$GhostLockUserProfileCopyWithImpl<_GhostLockUserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GhostLockUserProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.release, release) || other.release == release)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.importedAtMs, importedAtMs) || other.importedAtMs == importedAtMs)&&(identical(other.parseError, parseError) || other.parseError == parseError));
}


@override
int get hashCode => Object.hash(runtimeType,name,release,sizeBytes,importedAtMs,parseError);

@override
String toString() {
  return 'GhostLockUserProfile(name: $name, release: $release, sizeBytes: $sizeBytes, importedAtMs: $importedAtMs, parseError: $parseError)';
}


}

/// @nodoc
abstract mixin class _$GhostLockUserProfileCopyWith<$Res> implements $GhostLockUserProfileCopyWith<$Res> {
  factory _$GhostLockUserProfileCopyWith(_GhostLockUserProfile value, $Res Function(_GhostLockUserProfile) _then) = __$GhostLockUserProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, String release, int sizeBytes, int importedAtMs, bool parseError
});




}
/// @nodoc
class __$GhostLockUserProfileCopyWithImpl<$Res>
    implements _$GhostLockUserProfileCopyWith<$Res> {
  __$GhostLockUserProfileCopyWithImpl(this._self, this._then);

  final _GhostLockUserProfile _self;
  final $Res Function(_GhostLockUserProfile) _then;

/// Create a copy of GhostLockUserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? release = null,Object? sizeBytes = null,Object? importedAtMs = null,Object? parseError = null,}) {
  return _then(_GhostLockUserProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,release: null == release ? _self.release : release // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,importedAtMs: null == importedAtMs ? _self.importedAtMs : importedAtMs // ignore: cast_nullable_to_non_nullable
as int,parseError: null == parseError ? _self.parseError : parseError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
