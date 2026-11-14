import 'package:Aisupass/features/chat/domain/models/chat_tool_call.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/chat_widgets/adb_pairing_panel.dart';
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
    };

Widget _adbPairingPanel(
  BuildContext context,
  String turnId,
  bool isLastTurn,
  ChatToolCall call,
) => AdbPairingPanel(turnId: turnId, isLastTurn: isLastTurn);
