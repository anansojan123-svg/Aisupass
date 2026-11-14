import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/web_search/domain/models/web_search_result.dart';
import 'package:Aisupass/features/web_search/presentation/providers/web_search_query_provider.dart';

/// 联网搜索工具：走 Bing 公开 RSS，不需要 API Key。
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
];
