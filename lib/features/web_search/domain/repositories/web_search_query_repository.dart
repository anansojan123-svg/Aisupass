import 'package:Aisupass/features/web_search/domain/models/web_search_result.dart';

/// 联网搜索查询仓储：只读，无副作用。
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
}
