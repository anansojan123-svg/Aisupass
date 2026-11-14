import 'package:Aisupass/features/web_search/data/datasources/web_search_query_datasource.dart';
import 'package:Aisupass/features/web_search/data/models/web_page_content_dto.dart';
import 'package:Aisupass/features/web_search/data/models/web_search_result_dto.dart';
import 'package:Aisupass/features/web_search/domain/models/web_page_content.dart';
import 'package:Aisupass/features/web_search/domain/models/web_search_result.dart';
import 'package:Aisupass/features/web_search/domain/repositories/web_search_query_repository.dart';

/// 联网搜索与网页抓取仓储实现：DTO → Entity 的唯一转换点。
class WebSearchQueryRepositoryImpl implements WebSearchQueryRepository {
  const WebSearchQueryRepositoryImpl({required this._datasource});

  final WebSearchQueryDatasource _datasource;

  @override
  Future<List<WebSearchResult>> search({
    required String query,
    required int count,
    required String market,
  }) async {
    final List<WebSearchResultDto> items = await _datasource.search(
      query: query,
      count: count,
      market: market,
    );
    return <WebSearchResult>[
      for (final WebSearchResultDto dto in items) dto.toEntity(),
    ];
  }

  @override
  Future<WebPageContent> fetchPage({
    required String url,
    required int maxChars,
  }) async {
    final WebPageContentDto dto = await _datasource.fetchPage(
      url: url,
      maxChars: maxChars,
    );
    return dto.toEntity();
  }
}
