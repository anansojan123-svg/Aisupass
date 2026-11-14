import 'package:Aisupass/features/web_search/domain/models/web_page_content.dart';
import 'package:Aisupass/features/web_search/domain/models/web_search_result.dart';

/// 联网搜索与网页抓取的查询仓储：只读，无副作用。
abstract class WebSearchQueryRepository {
  /// 搜索关键词，返回按搜索引擎排序的结果。
  ///
  /// [count] 是期望条数，由实现按服务端上限裁剪；
  /// [market] 是区域标识（如 `zh-CN`），空串表示不指定。
  Future<List<WebSearchResult>> search({
    required String query,
    required int count,
    required String market,
  });

  /// 抓取单个网页的原始正文。
  ///
  /// 非 2xx 不抛异常：状态码与正文一起返回，让调用方能看到挑战页与报错页。
  /// [maxChars] 为正文保留上限，超出部分截断。
  Future<WebPageContent> fetchPage({
    required String url,
    required int maxChars,
  });
}
