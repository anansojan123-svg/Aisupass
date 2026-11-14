// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'handoff_outcome_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HandoffOutcomeDto {

 HandoffKind get kind; String get managerPackage; String get managerDisplayName; List<int> get managerIcon; String get ksudPath; int get exitCode; String get output; int get durationMs; bool get timedOut;
/// Create a copy of HandoffOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HandoffOutcomeDtoCopyWith<HandoffOutcomeDto> get copyWith => _$HandoffOutcomeDtoCopyWithImpl<HandoffOutcomeDto>(this as HandoffOutcomeDto, _$identity);

  /// Serializes this HandoffOutcomeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HandoffOutcomeDto&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.managerPackage, managerPackage) || other.managerPackage == managerPackage)&&(identical(other.managerDisplayName, managerDisplayName) || other.managerDisplayName == managerDisplayName)&&const DeepCollectionEquality().equals(other.managerIcon, managerIcon)&&(identical(other.ksudPath, ksudPath) || other.ksudPath == ksudPath)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.output, output) || other.output == output)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,managerPackage,managerDisplayName,const DeepCollectionEquality().hash(managerIcon),ksudPath,exitCode,output,durationMs,timedOut);

@override
String toString() {
  return 'HandoffOutcomeDto(kind: $kind, managerPackage: $managerPackage, managerDisplayName: $managerDisplayName, managerIcon: $managerIcon, ksudPath: $ksudPath, exitCode: $exitCode, output: $output, durationMs: $durationMs, timedOut: $timedOut)';
}


}

/// @nodoc
abstract mixin class $HandoffOutcomeDtoCopyWith<$Res>  {
  factory $HandoffOutcomeDtoCopyWith(HandoffOutcomeDto value, $Res Function(HandoffOutcomeDto) _then) = _$HandoffOutcomeDtoCopyWithImpl;
@useResult
$Res call({
 HandoffKind kind, String managerPackage, String managerDisplayName, List<int> managerIcon, String ksudPath, int exitCode, String output, int durationMs, bool timedOut
});




}
/// @nodoc
class _$HandoffOutcomeDtoCopyWithImpl<$Res>
    implements $HandoffOutcomeDtoCopyWith<$Res> {
  _$HandoffOutcomeDtoCopyWithImpl(this._self, this._then);

  final HandoffOutcomeDto _self;
  final $Res Function(HandoffOutcomeDto) _then;

/// Create a copy of HandoffOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? managerPackage = null,Object? managerDisplayName = null,Object? managerIcon = null,Object? ksudPath = null,Object? exitCode = null,Object? output = null,Object? durationMs = null,Object? timedOut = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as HandoffKind,managerPackage: null == managerPackage ? _self.managerPackage : managerPackage // ignore: cast_nullable_to_non_nullable
as String,managerDisplayName: null == managerDisplayName ? _self.managerDisplayName : managerDisplayName // ignore: cast_nullable_to_non_nullable
as String,managerIcon: null == managerIcon ? _self.managerIcon : managerIcon // ignore: cast_nullable_to_non_nullable
as List<int>,ksudPath: null == ksudPath ? _self.ksudPath : ksudPath // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HandoffOutcomeDto].
extension HandoffOutcomeDtoPatterns on HandoffOutcomeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HandoffOutcomeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HandoffOutcomeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HandoffOutcomeDto value)  $default,){
final _that = this;
switch (_that) {
case _HandoffOutcomeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HandoffOutcomeDto value)?  $default,){
final _that = this;
switch (_that) {
case _HandoffOutcomeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HandoffKind kind,  String managerPackage,  String managerDisplayName,  List<int> managerIcon,  String ksudPath,  int exitCode,  String output,  int durationMs,  bool timedOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HandoffOutcomeDto() when $default != null:
return $default(_that.kind,_that.managerPackage,_that.managerDisplayName,_that.managerIcon,_that.ksudPath,_that.exitCode,_that.output,_that.durationMs,_that.timedOut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HandoffKind kind,  String managerPackage,  String managerDisplayName,  List<int> managerIcon,  String ksudPath,  int exitCode,  String output,  int durationMs,  bool timedOut)  $default,) {final _that = this;
switch (_that) {
case _HandoffOutcomeDto():
return $default(_that.kind,_that.managerPackage,_that.managerDisplayName,_that.managerIcon,_that.ksudPath,_that.exitCode,_that.output,_that.durationMs,_that.timedOut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HandoffKind kind,  String managerPackage,  String managerDisplayName,  List<int> managerIcon,  String ksudPath,  int exitCode,  String output,  int durationMs,  bool timedOut)?  $default,) {final _that = this;
switch (_that) {
case _HandoffOutcomeDto() when $default != null:
return $default(_that.kind,_that.managerPackage,_that.managerDisplayName,_that.managerIcon,_that.ksudPath,_that.exitCode,_that.output,_that.durationMs,_that.timedOut);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HandoffOutcomeDto extends HandoffOutcomeDto {
  const _HandoffOutcomeDto({this.kind = HandoffKind.failed, this.managerPackage = '', this.managerDisplayName = '', this.managerIcon = const <int>[], this.ksudPath = '', this.exitCode = -1, this.output = '', this.durationMs = 0, this.timedOut = false}): super._();
  factory _HandoffOutcomeDto.fromJson(Map<String, dynamic> json) => _$HandoffOutcomeDtoFromJson(json);

@override@JsonKey() final  HandoffKind kind;
@override@JsonKey() final  String managerPackage;
@override@JsonKey() final  String managerDisplayName;
@override@JsonKey() final  List<int> managerIcon;
@override@JsonKey() final  String ksudPath;
@override@JsonKey() final  int exitCode;
@override@JsonKey() final  String output;
@override@JsonKey() final  int durationMs;
@override@JsonKey() final  bool timedOut;

/// Create a copy of HandoffOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HandoffOutcomeDtoCopyWith<_HandoffOutcomeDto> get copyWith => __$HandoffOutcomeDtoCopyWithImpl<_HandoffOutcomeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HandoffOutcomeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HandoffOutcomeDto&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.managerPackage, managerPackage) || other.managerPackage == managerPackage)&&(identical(other.managerDisplayName, managerDisplayName) || other.managerDisplayName == managerDisplayName)&&const DeepCollectionEquality().equals(other.managerIcon, managerIcon)&&(identical(other.ksudPath, ksudPath) || other.ksudPath == ksudPath)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode)&&(identical(other.output, output) || other.output == output)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,managerPackage,managerDisplayName,const DeepCollectionEquality().hash(managerIcon),ksudPath,exitCode,output,durationMs,timedOut);

@override
String toString() {
  return 'HandoffOutcomeDto(kind: $kind, managerPackage: $managerPackage, managerDisplayName: $managerDisplayName, managerIcon: $managerIcon, ksudPath: $ksudPath, exitCode: $exitCode, output: $output, durationMs: $durationMs, timedOut: $timedOut)';
}


}

/// @nodoc
abstract mixin class _$HandoffOutcomeDtoCopyWith<$Res> implements $HandoffOutcomeDtoCopyWith<$Res> {
  factory _$HandoffOutcomeDtoCopyWith(_HandoffOutcomeDto value, $Res Function(_HandoffOutcomeDto) _then) = __$HandoffOutcomeDtoCopyWithImpl;
@override @useResult
$Res call({
 HandoffKind kind, String managerPackage, String managerDisplayName, List<int> managerIcon, String ksudPath, int exitCode, String output, int durationMs, bool timedOut
});




}
/// @nodoc
class __$HandoffOutcomeDtoCopyWithImpl<$Res>
    implements _$HandoffOutcomeDtoCopyWith<$Res> {
  __$HandoffOutcomeDtoCopyWithImpl(this._self, this._then);

  final _HandoffOutcomeDto _self;
  final $Res Function(_HandoffOutcomeDto) _then;

/// Create a copy of HandoffOutcomeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? managerPackage = null,Object? managerDisplayName = null,Object? managerIcon = null,Object? ksudPath = null,Object? exitCode = null,Object? output = null,Object? durationMs = null,Object? timedOut = null,}) {
  return _then(_HandoffOutcomeDto(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as HandoffKind,managerPackage: null == managerPackage ? _self.managerPackage : managerPackage // ignore: cast_nullable_to_non_nullable
as String,managerDisplayName: null == managerDisplayName ? _self.managerDisplayName : managerDisplayName // ignore: cast_nullable_to_non_nullable
as String,managerIcon: null == managerIcon ? _self.managerIcon : managerIcon // ignore: cast_nullable_to_non_nullable
as List<int>,ksudPath: null == ksudPath ? _self.ksudPath : ksudPath // ignore: cast_nullable_to_non_nullable
as String,exitCode: null == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
