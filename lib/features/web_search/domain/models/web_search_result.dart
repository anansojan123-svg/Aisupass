import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_search_result.freezed.dart';

/// 一条搜索结果。
///
/// 只保留模型真正需要的四样东西：标题、链接、摘要、发布时间。
@freezed
abstract class WebSearchResult with _$WebSearchResult {
  const WebSearchResult._();

  const factory WebSearchResult({
    required String title,
    required String url,

    /// 搜索引擎给出的片段摘要，可能带高亮标签，已在上游清洗。
    required String snippet,

    /// 原始时间串；搜索引擎不保证格式，解析不了就留空。
    required String publishedAt,
  }) = _WebSearchResult;

  bool get hasUrl => url.trim().isNotEmpty;

  bool get hasSnippet => snippet.trim().isNotEmpty;
}
