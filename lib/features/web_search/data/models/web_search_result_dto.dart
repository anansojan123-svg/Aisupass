import 'package:Aisupass/features/web_search/domain/models/web_search_result.dart';
import 'package:flutter/foundation.dart';

/// 搜索结果的传输对象。
///
/// 上游是 Bing 的 RSS 文本，不是 JSON，因此解析入口是 [fromRssFields] 而非
/// `fromJson`；对外只暴露 [toEntity]，实体不参与序列化。
@immutable
class WebSearchResultDto {
  const WebSearchResultDto({
    required this.title,
    required this.url,
    required this.snippet,
    required this.publishedAt,
  });

  final String title;
  final String url;
  final String snippet;
  final String publishedAt;

  /// 从 RSS `<item>` 的字段映射构造；标题或链接缺失时返回 null。
  static WebSearchResultDto? fromRssFields(Map<String, String> fields) {
    final String title = (fields['title'] ?? '').trim();
    final String url = (fields['link'] ?? '').trim();
    if (title.isEmpty || url.isEmpty) return null;
    return WebSearchResultDto(
      title: title,
      url: url,
      snippet: (fields['description'] ?? '').trim(),
      publishedAt: (fields['pubDate'] ?? '').trim(),
    );
  }

  WebSearchResult toEntity() => WebSearchResult(
    title: title,
    url: url,
    snippet: snippet,
    publishedAt: publishedAt,
  );
}
