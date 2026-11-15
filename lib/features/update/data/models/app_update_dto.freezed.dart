// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUpdateDto {

 AppUpdateMsgDto get msg;
/// Create a copy of AppUpdateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUpdateDtoCopyWith<AppUpdateDto> get copyWith => _$AppUpdateDtoCopyWithImpl<AppUpdateDto>(this as AppUpdateDto, _$identity);

  /// Serializes this AppUpdateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateDto&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,msg);

@override
String toString() {
  return 'AppUpdateDto(msg: $msg)';
}


}

/// @nodoc
abstract mixin class $AppUpdateDtoCopyWith<$Res>  {
  factory $AppUpdateDtoCopyWith(AppUpdateDto value, $Res Function(AppUpdateDto) _then) = _$AppUpdateDtoCopyWithImpl;
@useResult
$Res call({
 AppUpdateMsgDto msg
});


$AppUpdateMsgDtoCopyWith<$Res> get msg;

}
/// @nodoc
class _$AppUpdateDtoCopyWithImpl<$Res>
    implements $AppUpdateDtoCopyWith<$Res> {
  _$AppUpdateDtoCopyWithImpl(this._self, this._then);

  final AppUpdateDto _self;
  final $Res Function(AppUpdateDto) _then;

/// Create a copy of AppUpdateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? msg = null,}) {
  return _then(_self.copyWith(
msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as AppUpdateMsgDto,
  ));
}
/// Create a copy of AppUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUpdateMsgDtoCopyWith<$Res> get msg {
  
  return $AppUpdateMsgDtoCopyWith<$Res>(_self.msg, (value) {
    return _then(_self.copyWith(msg: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppUpdateDto].
extension AppUpdateDtoPatterns on AppUpdateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUpdateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUpdateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUpdateDto value)  $default,){
final _that = this;
switch (_that) {
case _AppUpdateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUpdateDto value)?  $default,){
final _that = this;
switch (_that) {
case _AppUpdateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppUpdateMsgDto msg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUpdateDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppUpdateMsgDto msg)  $default,) {final _that = this;
switch (_that) {
case _AppUpdateDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppUpdateMsgDto msg)?  $default,) {final _that = this;
switch (_that) {
case _AppUpdateDto() when $default != null:
return $default(_that.msg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUpdateDto extends AppUpdateDto {
  const _AppUpdateDto({this.msg = const AppUpdateMsgDto()}): super._();
  factory _AppUpdateDto.fromJson(Map<String, dynamic> json) => _$AppUpdateDtoFromJson(json);

@override@JsonKey() final  AppUpdateMsgDto msg;

/// Create a copy of AppUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUpdateDtoCopyWith<_AppUpdateDto> get copyWith => __$AppUpdateDtoCopyWithImpl<_AppUpdateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUpdateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUpdateDto&&(identical(other.msg, msg) || other.msg == msg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,msg);

@override
String toString() {
  return 'AppUpdateDto(msg: $msg)';
}


}

/// @nodoc
abstract mixin class _$AppUpdateDtoCopyWith<$Res> implements $AppUpdateDtoCopyWith<$Res> {
  factory _$AppUpdateDtoCopyWith(_AppUpdateDto value, $Res Function(_AppUpdateDto) _then) = __$AppUpdateDtoCopyWithImpl;
@override @useResult
$Res call({
 AppUpdateMsgDto msg
});


@override $AppUpdateMsgDtoCopyWith<$Res> get msg;

}
/// @nodoc
class __$AppUpdateDtoCopyWithImpl<$Res>
    implements _$AppUpdateDtoCopyWith<$Res> {
  __$AppUpdateDtoCopyWithImpl(this._self, this._then);

  final _AppUpdateDto _self;
  final $Res Function(_AppUpdateDto) _then;

/// Create a copy of AppUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? msg = null,}) {
  return _then(_AppUpdateDto(
msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as AppUpdateMsgDto,
  ));
}

/// Create a copy of AppUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUpdateMsgDtoCopyWith<$Res> get msg {
  
  return $AppUpdateMsgDtoCopyWith<$Res>(_self.msg, (value) {
    return _then(_self.copyWith(msg: value));
  });
}
}


/// @nodoc
mixin _$AppUpdateMsgDto {

@JsonKey(fromJson: _asString) String get version;@JsonKey(name: 'app_update_url', fromJson: _asString) String get appUpdateUrl;@JsonKey(name: 'app_update_show', fromJson: _asString) String get appUpdateShow;@JsonKey(name: 'app_update_must', fromJson: _asString) String get appUpdateMust;
/// Create a copy of AppUpdateMsgDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUpdateMsgDtoCopyWith<AppUpdateMsgDto> get copyWith => _$AppUpdateMsgDtoCopyWithImpl<AppUpdateMsgDto>(this as AppUpdateMsgDto, _$identity);

  /// Serializes this AppUpdateMsgDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateMsgDto&&(identical(other.version, version) || other.version == version)&&(identical(other.appUpdateUrl, appUpdateUrl) || other.appUpdateUrl == appUpdateUrl)&&(identical(other.appUpdateShow, appUpdateShow) || other.appUpdateShow == appUpdateShow)&&(identical(other.appUpdateMust, appUpdateMust) || other.appUpdateMust == appUpdateMust));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,appUpdateUrl,appUpdateShow,appUpdateMust);

@override
String toString() {
  return 'AppUpdateMsgDto(version: $version, appUpdateUrl: $appUpdateUrl, appUpdateShow: $appUpdateShow, appUpdateMust: $appUpdateMust)';
}


}

/// @nodoc
abstract mixin class $AppUpdateMsgDtoCopyWith<$Res>  {
  factory $AppUpdateMsgDtoCopyWith(AppUpdateMsgDto value, $Res Function(AppUpdateMsgDto) _then) = _$AppUpdateMsgDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _asString) String version,@JsonKey(name: 'app_update_url', fromJson: _asString) String appUpdateUrl,@JsonKey(name: 'app_update_show', fromJson: _asString) String appUpdateShow,@JsonKey(name: 'app_update_must', fromJson: _asString) String appUpdateMust
});




}
/// @nodoc
class _$AppUpdateMsgDtoCopyWithImpl<$Res>
    implements $AppUpdateMsgDtoCopyWith<$Res> {
  _$AppUpdateMsgDtoCopyWithImpl(this._self, this._then);

  final AppUpdateMsgDto _self;
  final $Res Function(AppUpdateMsgDto) _then;

/// Create a copy of AppUpdateMsgDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? appUpdateUrl = null,Object? appUpdateShow = null,Object? appUpdateMust = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,appUpdateUrl: null == appUpdateUrl ? _self.appUpdateUrl : appUpdateUrl // ignore: cast_nullable_to_non_nullable
as String,appUpdateShow: null == appUpdateShow ? _self.appUpdateShow : appUpdateShow // ignore: cast_nullable_to_non_nullable
as String,appUpdateMust: null == appUpdateMust ? _self.appUpdateMust : appUpdateMust // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUpdateMsgDto].
extension AppUpdateMsgDtoPatterns on AppUpdateMsgDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUpdateMsgDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUpdateMsgDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUpdateMsgDto value)  $default,){
final _that = this;
switch (_that) {
case _AppUpdateMsgDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUpdateMsgDto value)?  $default,){
final _that = this;
switch (_that) {
case _AppUpdateMsgDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _asString)  String version, @JsonKey(name: 'app_update_url', fromJson: _asString)  String appUpdateUrl, @JsonKey(name: 'app_update_show', fromJson: _asString)  String appUpdateShow, @JsonKey(name: 'app_update_must', fromJson: _asString)  String appUpdateMust)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUpdateMsgDto() when $default != null:
return $default(_that.version,_that.appUpdateUrl,_that.appUpdateShow,_that.appUpdateMust);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _asString)  String version, @JsonKey(name: 'app_update_url', fromJson: _asString)  String appUpdateUrl, @JsonKey(name: 'app_update_show', fromJson: _asString)  String appUpdateShow, @JsonKey(name: 'app_update_must', fromJson: _asString)  String appUpdateMust)  $default,) {final _that = this;
switch (_that) {
case _AppUpdateMsgDto():
return $default(_that.version,_that.appUpdateUrl,_that.appUpdateShow,_that.appUpdateMust);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _asString)  String version, @JsonKey(name: 'app_update_url', fromJson: _asString)  String appUpdateUrl, @JsonKey(name: 'app_update_show', fromJson: _asString)  String appUpdateShow, @JsonKey(name: 'app_update_must', fromJson: _asString)  String appUpdateMust)?  $default,) {final _that = this;
switch (_that) {
case _AppUpdateMsgDto() when $default != null:
return $default(_that.version,_that.appUpdateUrl,_that.appUpdateShow,_that.appUpdateMust);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUpdateMsgDto extends AppUpdateMsgDto {
  const _AppUpdateMsgDto({@JsonKey(fromJson: _asString) this.version = '', @JsonKey(name: 'app_update_url', fromJson: _asString) this.appUpdateUrl = '', @JsonKey(name: 'app_update_show', fromJson: _asString) this.appUpdateShow = '', @JsonKey(name: 'app_update_must', fromJson: _asString) this.appUpdateMust = ''}): super._();
  factory _AppUpdateMsgDto.fromJson(Map<String, dynamic> json) => _$AppUpdateMsgDtoFromJson(json);

@override@JsonKey(fromJson: _asString) final  String version;
@override@JsonKey(name: 'app_update_url', fromJson: _asString) final  String appUpdateUrl;
@override@JsonKey(name: 'app_update_show', fromJson: _asString) final  String appUpdateShow;
@override@JsonKey(name: 'app_update_must', fromJson: _asString) final  String appUpdateMust;

/// Create a copy of AppUpdateMsgDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUpdateMsgDtoCopyWith<_AppUpdateMsgDto> get copyWith => __$AppUpdateMsgDtoCopyWithImpl<_AppUpdateMsgDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUpdateMsgDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUpdateMsgDto&&(identical(other.version, version) || other.version == version)&&(identical(other.appUpdateUrl, appUpdateUrl) || other.appUpdateUrl == appUpdateUrl)&&(identical(other.appUpdateShow, appUpdateShow) || other.appUpdateShow == appUpdateShow)&&(identical(other.appUpdateMust, appUpdateMust) || other.appUpdateMust == appUpdateMust));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,appUpdateUrl,appUpdateShow,appUpdateMust);

@override
String toString() {
  return 'AppUpdateMsgDto(version: $version, appUpdateUrl: $appUpdateUrl, appUpdateShow: $appUpdateShow, appUpdateMust: $appUpdateMust)';
}


}

/// @nodoc
abstract mixin class _$AppUpdateMsgDtoCopyWith<$Res> implements $AppUpdateMsgDtoCopyWith<$Res> {
  factory _$AppUpdateMsgDtoCopyWith(_AppUpdateMsgDto value, $Res Function(_AppUpdateMsgDto) _then) = __$AppUpdateMsgDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _asString) String version,@JsonKey(name: 'app_update_url', fromJson: _asString) String appUpdateUrl,@JsonKey(name: 'app_update_show', fromJson: _asString) String appUpdateShow,@JsonKey(name: 'app_update_must', fromJson: _asString) String appUpdateMust
});




}
/// @nodoc
class __$AppUpdateMsgDtoCopyWithImpl<$Res>
    implements _$AppUpdateMsgDtoCopyWith<$Res> {
  __$AppUpdateMsgDtoCopyWithImpl(this._self, this._then);

  final _AppUpdateMsgDto _self;
  final $Res Function(_AppUpdateMsgDto) _then;

/// Create a copy of AppUpdateMsgDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? appUpdateUrl = null,Object? appUpdateShow = null,Object? appUpdateMust = null,}) {
  return _then(_AppUpdateMsgDto(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,appUpdateUrl: null == appUpdateUrl ? _self.appUpdateUrl : appUpdateUrl // ignore: cast_nullable_to_non_nullable
as String,appUpdateShow: null == appUpdateShow ? _self.appUpdateShow : appUpdateShow // ignore: cast_nullable_to_non_nullable
as String,appUpdateMust: null == appUpdateMust ? _self.appUpdateMust : appUpdateMust // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
