import 'package:Aisupass/features/web_search/data/datasources/web_search_query_datasource.dart';
import 'package:Aisupass/features/web_search/data/repositories/web_search_query_repository_impl.dart';
import 'package:Aisupass/features/web_search/domain/models/web_page_content.dart';
import 'package:Aisupass/features/web_search/domain/models/web_search_result.dart';
import 'package:Aisupass/features/web_search/domain/repositories/web_search_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_search_query_provider.g.dart';

/// Bing 搜索数据源。
@riverpod
WebSearchQueryDatasource webSearchQueryDatasource(Ref ref) =>
    WebSearchQueryDatasource();

/// 联网搜索查询仓储。
@riverpod
WebSearchQueryRepository webSearchQueryRepository(Ref ref) =>
    WebSearchQueryRepositoryImpl(
      datasource: ref.watch(webSearchQueryDatasourceProvider),
    );

/// 一次联网搜索。
///
/// 关键词与条数都是入参，结果不缓存：同一句话在不同时间搜到的内容不同，
/// 常驻反而会拿到过期页面。
@riverpod
Future<List<WebSearchResult>> webSearch(
  Ref ref, {
  required String query,
  required int count,
  required String market,
}) => ref
    .watch(webSearchQueryRepositoryProvider)
    .search(query: query, count: count, market: market);

/// 抓取单个网页的原始正文。
///
/// 同样不缓存：同一 URL 在不同时间返回的可能是挑战页、登录页或已更新内容。
@riverpod
Future<WebPageContent> webPageContent(
  Ref ref, {
  required String url,
  required int maxChars,
}) => ref
    .watch(webSearchQueryRepositoryProvider)
    .fetchPage(url: url, maxChars: maxChars);
