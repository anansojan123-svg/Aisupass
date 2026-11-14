import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';

/// GhostLock 内核表编辑器的保存编排。
///
/// 只负责调 Provider 与回传结果；Toast、FilePicker 与状态更新由页面处理。
class GhostLockProfileController {
  GhostLockProfileController({required this.ref});

  final WidgetRef ref;

  /// 把草稿写进 override；无改动时原样返回 [config]，[config] 为空返回 null。
  Future<GhostLockProfileConfig?> commitDraft({
    required GhostLockProfileConfig? config,
    required Map<String, int> values,
  }) async {
    if (config == null) return null;
    if (values.isEmpty) return config;
    return ref
        .read(ghostLockProfileActionsProvider)
        .updateAdvanced(release: config.release, values: values);
  }

  /// 另存为新文档；返回新文档名，失败为空串。
  Future<String> saveAsNew() =>
      ref.read(ghostLockProfileActionsProvider).saveEditSessionAsNew();

  /// 渲染导出文本；空串表示无法渲染。
  Future<String> renderExport({required String release}) =>
      ref.read(ghostLockProfileActionsProvider).renderProfile(release: release);
}
