import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_action_provider.dart';

/// 内核表页签的生效编排。
///
/// 只调 Provider 并回传结果；Toast 与页签状态由页面处理。
class KernelProfileController {
  KernelProfileController({required this.ref});

  final WidgetRef ref;

  /// 把选中的来源写入生效配置。
  ///
  /// 两组候选互斥由原生保证：选文档会撤掉生效内置表，反之亦然。
  Future<GhostLockProfileConfig> applyProfile({
    required String deviceRelease,
    required String pickedUser,
    required String pickedBuiltin,
  }) {
    final GhostLockProfileActions actions = ref.read(
      ghostLockProfileActionsProvider,
    );
    if (pickedUser.isNotEmpty) {
      return actions.selectUserProfile(
        release: deviceRelease,
        name: pickedUser,
      );
    }
    return actions.selectBuiltin(
      release: deviceRelease,
      profileRelease: pickedBuiltin,
    );
  }
}
