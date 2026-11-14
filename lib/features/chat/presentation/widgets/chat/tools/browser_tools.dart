import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';

/// 浏览器工具：把网页交给用户用系统浏览器打开。
///
/// 存在的理由：找 ROM / 固件时常被验证码、登录墙、Cloudflare 挑战拦住，
/// 这些只存在于真实浏览器会话里，应用内抓取永远过不去。
/// 因此本工具不下载、不解析，只负责把链接摆到用户面前并给出一个打开的按钮。
List<ChatToolDefinition> browserTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'open_in_browser',
    description:
        'Offer a web page to the user and render a card with an "open in '
        'browser" button. Use this when a page needs a real browser session: '
        'captcha, login, Cloudflare challenge, or a large ROM/firmware '
        'download that the app must not fetch itself. After calling it, do '
        'not repeat the URL; wait for the user to come back.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'url': stringProperty(
          description: 'Absolute http or https URL to open.',
        ),
        'reason': stringProperty(
          description:
              'One short sentence telling the user why this page is worth '
              'opening, shown under the link.',
        ),
      },
      required: <String>['url'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final String raw = requireString(arguments, 'url').trim();
      final Uri? uri = Uri.tryParse(raw);
      if (uri == null ||
          (uri.scheme != 'http' && uri.scheme != 'https') ||
          uri.host.isEmpty) {
        throw ArgumentError('Not an absolute http or https URL: $raw');
      }

      final String reason = stringArg(arguments, 'reason').trim();
      return jsonEncode(<String, Object?>{
        'panel': 'browser',
        'url': raw,
        'host': uri.host,
        'reason': reason,
        'next':
            'Card rendered. The user must tap the button in the card, so do '
            'not repeat the URL and do not claim the page was opened. Wait '
            'for the user to come back with what they saw or downloaded.',
      });
    },
  ),
];
