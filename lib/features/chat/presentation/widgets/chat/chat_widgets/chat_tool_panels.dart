import 'dart:convert';

import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/adb_pairing_panel.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/browser_open_panel.dart';
import 'package:flutter/widgets.dart';

/// 工具调用附带的自定义交互组件构造器；返回 null 表示该工具不需要。
typedef ChatToolPanelBuilder =
    Widget? Function(
      BuildContext context,
      String turnId,
      bool isLastTurn,
      ChatToolCall call,
    );

/// 工具名 → 对话内常驻组件。
///
/// 需要用户在对话里直接操作的工具在这里登记，新增一个只加一项，
/// 不必改消息渲染逻辑。挂起与续跑由 [ChatUserActionGate] 承担。
const Map<String, ChatToolPanelBuilder> chatToolPanels =
    <String, ChatToolPanelBuilder>{
      'adb_pairing_request': _adbPairingPanel,
      'open_in_browser': _browserPanel,
    };

Widget _adbPairingPanel(
  BuildContext context,
  String turnId,
  bool isLastTurn,
  ChatToolCall call,
) => AdbPairingPanel(turnId: turnId, isLastTurn: isLastTurn);

Widget? _browserPanel(
  BuildContext context,
  String turnId,
  bool isLastTurn,
  ChatToolCall call,
) {
  final Map<String, dynamic> arguments = _decodeArguments(call.argumentsJson);
  final String url = (arguments['url'] as String? ?? '').trim();
  if (url.isEmpty) return null;
  return BrowserOpenPanel(
    url: url,
    reason: (arguments['reason'] as String? ?? '').trim(),
  );
}

/// 工具参数是流式拼出来的 JSON 文本，非法或为空时按空参数处理。
Map<String, dynamic> _decodeArguments(String raw) {
  final String text = raw.trim();
  if (text.isEmpty) return const <String, dynamic>{};
  try {
    final Object? decoded = jsonDecode(text);
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
  } on FormatException {
    return const <String, dynamic>{};
  }
  return const <String, dynamic>{};
}
