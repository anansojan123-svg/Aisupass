import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/exploit_run_sessions.dart';
import 'package:Aisupass/features/chat/presentation/widgets/chat/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';

/// 按包名找已安装 root 管理器；包名为空时回落到用户已选项，未装时返回 null。
Future<RootManager?> resolveRootManager(Ref ref, String packageName) async {
  if (packageName.isEmpty) {
    return ref.read(selectedRootManagerProvider.future);
  }
  final List<RootManager> managers = await ref.read(
    installedRootManagersProvider.future,
  );
  for (final RootManager manager in managers) {
    if (manager.packageName == packageName) return manager;
  }
  return null;
}

/// 取指定工具的运行会话；`sessionId` 为空时取该工具最近一次。
ExploitRunSession? findRunSession(
  Ref ref,
  String tool,
  Map<String, dynamic> arguments,
) {
  final ExploitRunRegistry registry = ref.read(exploitRunRegistryProvider);
  final String id = stringArg(arguments, 'sessionId');
  return id.isEmpty ? registry.latest(tool) : registry.find(id);
}

/// 读取指定运行会话的快照 JSON；找不到返回 `found: false`。
String snapshotRunSession(
  Ref ref,
  String tool,
  Map<String, dynamic> arguments,
) {
  final ExploitRunSession? session = findRunSession(ref, tool, arguments);
  if (session == null) return jsonEncode(<String, Object?>{'found': false});
  return jsonEncode(<String, Object?>{'found': true, ...session.toJson()});
}

/// 停止本侧读取指定会话并回填终态；设备侧进程不受影响。
Future<String> cancelRunSession(
  Ref ref,
  String tool,
  Map<String, dynamic> arguments,
) async {
  final ExploitRunSession? session = findRunSession(ref, tool, arguments);
  if (session == null) return jsonEncode(<String, Object?>{'found': false});
  await session.subscription?.cancel();
  session.subscription = null;
  await session.cancel?.call();
  session.onCancel?.call();
  session.status = 'cancelled';
  session.finished = true;
  return jsonEncode(<String, Object?>{'found': true, ...session.toJson()});
}
