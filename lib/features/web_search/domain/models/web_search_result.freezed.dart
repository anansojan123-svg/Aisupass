// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'web_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WebSearchResult {

 String get title; String get url;/// 搜索引擎给出的片段摘要，可能带高亮标签，已在上游清洗。
 String get snippet;/// 原始时间串；搜索引擎不保证格式，解析不了就留空。
 String get publishedAt;
/// Create a copy of WebSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebSearchResultCopyWith<WebSearchResult> get copyWith => _$WebSearchResultCopyWithImpl<WebSearchResult>(this as WebSearchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebSearchResult&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}


@override
int get hashCode => Object.hash(runtimeType,title,url,snippet,publishedAt);

@override
String toString() {
  return 'WebSearchResult(title: $title, url: $url, snippet: $snippet, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class $WebSearchResultCopyWith<$Res>  {
  factory $WebSearchResultCopyWith(WebSearchResult value, $Res Function(WebSearchResult) _then) = _$WebSearchResultCopyWithImpl;
@useResult
$Res call({
 String title, String url, String snippet, String publishedAt
});




}
/// @nodoc
class _$WebSearchResultCopyWithImpl<$Res>
    implements $WebSearchResultCopyWith<$Res> {
  _$WebSearchResultCopyWithImpl(this._self, this._then);

  final WebSearchResult _self;
  final $Res Function(WebSearchResult) _then;

/// Create a copy of WebSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? url = null,Object? snippet = null,Object? publishedAt = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WebSearchResult].
extension WebSearchResultPatterns on WebSearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebSearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _WebSearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _WebSearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String url,  String snippet,  String publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebSearchResult() when $default != null:
return $default(_that.title,_that.url,_that.snippet,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String url,  String snippet,  String publishedAt)  $default,) {final _that = this;
switch (_that) {
case _WebSearchResult():
return $default(_that.title,_that.url,_that.snippet,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String url,  String snippet,  String publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _WebSearchResult() when $default != null:
return $default(_that.title,_that.url,_that.snippet,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc


class _WebSearchResult extends WebSearchResult {
  const _WebSearchResult({required this.title, required this.url, required this.snippet, required this.publishedAt}): super._();
  

@override final  String title;
@override final  String url;
/// 搜索引擎给出的片段摘要，可能带高亮标签，已在上游清洗。
@override final  String snippet;
/// 原始时间串；搜索引擎不保证格式，解析不了就留空。
@override final  String publishedAt;

/// Create a copy of WebSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebSearchResultCopyWith<_WebSearchResult> get copyWith => __$WebSearchResultCopyWithImpl<_WebSearchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebSearchResult&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}


@override
int get hashCode => Object.hash(runtimeType,title,url,snippet,publishedAt);

@override
String toString() {
  return 'WebSearchResult(title: $title, url: $url, snippet: $snippet, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$WebSearchResultCopyWith<$Res> implements $WebSearchResultCopyWith<$Res> {
  factory _$WebSearchResultCopyWith(_WebSearchResult value, $Res Function(_WebSearchResult) _then) = __$WebSearchResultCopyWithImpl;
@override @useResult
$Res call({
 String title, String url, String snippet, String publishedAt
});




}
/// @nodoc
class __$WebSearchResultCopyWithImpl<$Res>
    implements _$WebSearchResultCopyWith<$Res> {
  __$WebSearchResultCopyWithImpl(this._self, this._then);

  final _WebSearchResult _self;
  final $Res Function(_WebSearchResult) _then;

/// Create a copy of WebSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? url = null,Object? snippet = null,Object? publishedAt = null,}) {
  return _then(_WebSearchResult(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
