// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_search_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bing 搜索数据源。

@ProviderFor(webSearchQueryDatasource)
const webSearchQueryDatasourceProvider = WebSearchQueryDatasourceProvider._();

/// Bing 搜索数据源。

final class WebSearchQueryDatasourceProvider
    extends
        $FunctionalProvider<
          WebSearchQueryDatasource,
          WebSearchQueryDatasource,
          WebSearchQueryDatasource
        >
    with $Provider<WebSearchQueryDatasource> {
  /// Bing 搜索数据源。
  const WebSearchQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webSearchQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webSearchQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<WebSearchQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WebSearchQueryDatasource create(Ref ref) {
    return webSearchQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebSearchQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebSearchQueryDatasource>(value),
    );
  }
}

String _$webSearchQueryDatasourceHash() =>
    r'cd87a97eaa136e44cb0692ca5dfd2dc60ace0f76';

/// 联网搜索查询仓储。

@ProviderFor(webSearchQueryRepository)
const webSearchQueryRepositoryProvider = WebSearchQueryRepositoryProvider._();

/// 联网搜索查询仓储。

final class WebSearchQueryRepositoryProvider
    extends
        $FunctionalProvider<
          WebSearchQueryRepository,
          WebSearchQueryRepository,
          WebSearchQueryRepository
        >
    with $Provider<WebSearchQueryRepository> {
  /// 联网搜索查询仓储。
  const WebSearchQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webSearchQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webSearchQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<WebSearchQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WebSearchQueryRepository create(Ref ref) {
    return webSearchQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebSearchQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebSearchQueryRepository>(value),
    );
  }
}

String _$webSearchQueryRepositoryHash() =>
    r'115aa1008726b6aba0c71f7debf489c9b4132701';

/// 一次联网搜索。
///
/// 关键词与条数都是入参，结果不缓存：同一句话在不同时间搜到的内容不同，
/// 常驻反而会拿到过期页面。

@ProviderFor(webSearch)
const webSearchProvider = WebSearchFamily._();

/// 一次联网搜索。
///
/// 关键词与条数都是入参，结果不缓存：同一句话在不同时间搜到的内容不同，
/// 常驻反而会拿到过期页面。

final class WebSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WebSearchResult>>,
          List<WebSearchResult>,
          FutureOr<List<WebSearchResult>>
        >
    with
        $FutureModifier<List<WebSearchResult>>,
        $FutureProvider<List<WebSearchResult>> {
  /// 一次联网搜索。
  ///
  /// 关键词与条数都是入参，结果不缓存：同一句话在不同时间搜到的内容不同，
  /// 常驻反而会拿到过期页面。
  const WebSearchProvider._({
    required WebSearchFamily super.from,
    required ({String query, int count, String market}) super.argument,
  }) : super(
         retry: null,
         name: r'webSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$webSearchHash();

  @override
  String toString() {
    return r'webSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<WebSearchResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WebSearchResult>> create(Ref ref) {
    final argument =
        this.argument as ({String query, int count, String market});
    return webSearch(
      ref,
      query: argument.query,
      count: argument.count,
      market: argument.market,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WebSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$webSearchHash() => r'ab555d593f210cceda21eebcb5f14666b81ea2c1';

/// 一次联网搜索。
///
/// 关键词与条数都是入参，结果不缓存：同一句话在不同时间搜到的内容不同，
/// 常驻反而会拿到过期页面。

final class WebSearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<WebSearchResult>>,
          ({String query, int count, String market})
        > {
  const WebSearchFamily._()
    : super(
        retry: null,
        name: r'webSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 一次联网搜索。
  ///
  /// 关键词与条数都是入参，结果不缓存：同一句话在不同时间搜到的内容不同，
  /// 常驻反而会拿到过期页面。

  WebSearchProvider call({
    required String query,
    required int count,
    required String market,
  }) => WebSearchProvider._(
    argument: (query: query, count: count, market: market),
    from: this,
  );

  @override
  String toString() => r'webSearchProvider';
}
