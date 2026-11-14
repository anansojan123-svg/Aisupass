// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'web_page_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WebPageContent {

 String get url;/// 跟随重定向后的最终地址；无重定向时与 [url] 相同。
 String get finalUrl; int get statusCode; String get contentType;/// 响应正文；超出上限时只保留前段。
 String get text;/// 正文原始字符数，用于判断是否被截断。
 int get totalChars;
/// Create a copy of WebPageContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebPageContentCopyWith<WebPageContent> get copyWith => _$WebPageContentCopyWithImpl<WebPageContent>(this as WebPageContent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebPageContent&&(identical(other.url, url) || other.url == url)&&(identical(other.finalUrl, finalUrl) || other.finalUrl == finalUrl)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.text, text) || other.text == text)&&(identical(other.totalChars, totalChars) || other.totalChars == totalChars));
}


@override
int get hashCode => Object.hash(runtimeType,url,finalUrl,statusCode,contentType,text,totalChars);

@override
String toString() {
  return 'WebPageContent(url: $url, finalUrl: $finalUrl, statusCode: $statusCode, contentType: $contentType, text: $text, totalChars: $totalChars)';
}


}

/// @nodoc
abstract mixin class $WebPageContentCopyWith<$Res>  {
  factory $WebPageContentCopyWith(WebPageContent value, $Res Function(WebPageContent) _then) = _$WebPageContentCopyWithImpl;
@useResult
$Res call({
 String url, String finalUrl, int statusCode, String contentType, String text, int totalChars
});




}
/// @nodoc
class _$WebPageContentCopyWithImpl<$Res>
    implements $WebPageContentCopyWith<$Res> {
  _$WebPageContentCopyWithImpl(this._self, this._then);

  final WebPageContent _self;
  final $Res Function(WebPageContent) _then;

/// Create a copy of WebPageContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? finalUrl = null,Object? statusCode = null,Object? contentType = null,Object? text = null,Object? totalChars = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,finalUrl: null == finalUrl ? _self.finalUrl : finalUrl // ignore: cast_nullable_to_non_nullable
as String,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,totalChars: null == totalChars ? _self.totalChars : totalChars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WebPageContent].
extension WebPageContentPatterns on WebPageContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebPageContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebPageContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebPageContent value)  $default,){
final _that = this;
switch (_that) {
case _WebPageContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebPageContent value)?  $default,){
final _that = this;
switch (_that) {
case _WebPageContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String finalUrl,  int statusCode,  String contentType,  String text,  int totalChars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebPageContent() when $default != null:
return $default(_that.url,_that.finalUrl,_that.statusCode,_that.contentType,_that.text,_that.totalChars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String finalUrl,  int statusCode,  String contentType,  String text,  int totalChars)  $default,) {final _that = this;
switch (_that) {
case _WebPageContent():
return $default(_that.url,_that.finalUrl,_that.statusCode,_that.contentType,_that.text,_that.totalChars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String finalUrl,  int statusCode,  String contentType,  String text,  int totalChars)?  $default,) {final _that = this;
switch (_that) {
case _WebPageContent() when $default != null:
return $default(_that.url,_that.finalUrl,_that.statusCode,_that.contentType,_that.text,_that.totalChars);case _:
  return null;

}
}

}

/// @nodoc


class _WebPageContent extends WebPageContent {
  const _WebPageContent({required this.url, required this.finalUrl, required this.statusCode, required this.contentType, required this.text, required this.totalChars}): super._();
  

@override final  String url;
/// 跟随重定向后的最终地址；无重定向时与 [url] 相同。
@override final  String finalUrl;
@override final  int statusCode;
@override final  String contentType;
/// 响应正文；超出上限时只保留前段。
@override final  String text;
/// 正文原始字符数，用于判断是否被截断。
@override final  int totalChars;

/// Create a copy of WebPageContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebPageContentCopyWith<_WebPageContent> get copyWith => __$WebPageContentCopyWithImpl<_WebPageContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebPageContent&&(identical(other.url, url) || other.url == url)&&(identical(other.finalUrl, finalUrl) || other.finalUrl == finalUrl)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.text, text) || other.text == text)&&(identical(other.totalChars, totalChars) || other.totalChars == totalChars));
}


@override
int get hashCode => Object.hash(runtimeType,url,finalUrl,statusCode,contentType,text,totalChars);

@override
String toString() {
  return 'WebPageContent(url: $url, finalUrl: $finalUrl, statusCode: $statusCode, contentType: $contentType, text: $text, totalChars: $totalChars)';
}


}

/// @nodoc
abstract mixin class _$WebPageContentCopyWith<$Res> implements $WebPageContentCopyWith<$Res> {
  factory _$WebPageContentCopyWith(_WebPageContent value, $Res Function(_WebPageContent) _then) = __$WebPageContentCopyWithImpl;
@override @useResult
$Res call({
 String url, String finalUrl, int statusCode, String contentType, String text, int totalChars
});




}
/// @nodoc
class __$WebPageContentCopyWithImpl<$Res>
    implements _$WebPageContentCopyWith<$Res> {
  __$WebPageContentCopyWithImpl(this._self, this._then);

  final _WebPageContent _self;
  final $Res Function(_WebPageContent) _then;

/// Create a copy of WebPageContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? finalUrl = null,Object? statusCode = null,Object? contentType = null,Object? text = null,Object? totalChars = null,}) {
  return _then(_WebPageContent(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,finalUrl: null == finalUrl ? _self.finalUrl : finalUrl // ignore: cast_nullable_to_non_nullable
as String,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,totalChars: null == totalChars ? _self.totalChars : totalChars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
