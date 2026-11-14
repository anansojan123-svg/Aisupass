import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/web_search/domain/models/web_page_content.dart';
import 'package:Aisupass/features/web_search/domain/models/web_search_result.dart';
import 'package:Aisupass/features/web_search/presentation/providers/web_search_query_provider.dart';

/// 回传给模型的网页正文字符上限；超出部分直接截断。
const int _defaultPageChars = 12000;
const int _maxPageChars = 60000;

/// 联网搜索与网页抓取工具：走公开网络，不需要 API Key。
List<ChatToolDefinition> webSearchTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'web_search',
    description:
        'Search the public web with Bing and return titles, URLs and '
        'snippets. Use this for anything not answerable from the device '
        'itself: latest kernel/ROM release info, CVE details, error messages, '
        'documentation. Results are snippets only, not full pages.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'query': stringProperty(
          description: 'Search keywords, as you would type into Bing.',
        ),
        'count': intProperty(
          description: 'How many results to return. Defaults to 8.',
          minimum: 1,
          maximum: 20,
        ),
        'market': stringProperty(
          description:
              'Market such as zh-CN or en-US. Defaults to zh-CN; use en-US '
              'for English technical sources.',
          allowedValues: <String>['zh-CN', 'en-US'],
        ),
      },
      required: <String>['query'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String query = requireString(arguments, 'query');
      final int count = intArg(arguments, 'count', fallback: 8)!;
      final String market = stringArg(
        arguments,
        'market',
        fallback: 'zh-CN',
      );

      final List<WebSearchResult> results = await ref.read(
        webSearchProvider(query: query, count: count, market: market).future,
      );

      return jsonEncode(<String, Object?>{
        'query': query,
        'total': results.length,
        'items': <Map<String, Object?>>[
          for (final WebSearchResult item in results)
            <String, Object?>{
              'title': item.title,
              'url': item.url,
              'snippet': item.snippet,
              if (item.publishedAt.isNotEmpty) 'publishedAt': item.publishedAt,
            },
        ],
      });
    },
  ),
  ChatToolDefinition(
    name: 'fetch_web_page',
    description:
        'Download the raw source of one web page and return it as text. Use '
        'this after web_search when the snippet is not enough: reading a ROM '
        'release page, a download mirror listing, a changelog or a forum '
        'thread. Returns statusCode and contentType too, so a 403 or a '
        'captcha page can be recognised instead of being treated as content. '
        'If the page needs a real browser session, use open_in_browser.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'url': stringProperty(
          description: 'Absolute http or https URL to download.',
        ),
        'maxChars': intProperty(
          description:
              'Characters of the body to keep. Defaults to $_defaultPageChars.',
          minimum: 1000,
          maximum: _maxPageChars,
        ),
      },
      required: <String>['url'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String url = requireString(arguments, 'url').trim();
      final int maxChars = _clampChars(
        intArg(arguments, 'maxChars', fallback: _defaultPageChars)!,
      );

      final WebPageContent page = await ref.read(
        webPageContentProvider(url: url, maxChars: maxChars).future,
      );

      return jsonEncode(<String, Object?>{
        'url': page.url,
        'finalUrl': page.finalUrl,
        'statusCode': page.statusCode,
        'contentType': page.contentType,
        'totalChars': page.totalChars,
        'truncated': page.truncated,
        'ok': page.ok,
        'text': page.text,
      });
    },
  ),
];

int _clampChars(int value) {
  if (value < 1000) return 1000;
  return value > _maxPageChars ? _maxPageChars : value;
}
