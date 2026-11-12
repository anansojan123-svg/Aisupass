import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';

/// GhostLock profile 编辑仓储接口。
abstract class GhostLockProfileEditActionRepository {
  /// 解析 builtin + imported + override 三层。
  Future<GhostLockProfileConfig> load({required String release});

  /// 写通用参数（execution tuning）。
  Future<GhostLockProfileConfig> updateGeneral({
    required String release,
    required Map<String, int> values,
  });

  /// 写高级字段（点分路径 → 值）。
  Future<GhostLockProfileConfig> updateAdvanced({
    required String release,
    required Map<String, int> values,
  });

  /// 设置 route；空串恢复为 profile 声明。
  Future<GhostLockProfileConfig> updateRoute({
    required String release,
    required String route,
  });

  /// 设置 fallback；`none` 关闭，空串移除声明。
  Future<GhostLockProfileConfig> updateFallback({
    required String release,
    required String fallbackTo,
  });

  /// 清掉该 release 的全部 override。
  Future<GhostLockProfileConfig> reset({required String release});

  /// 指定生效的内置表；[profileRelease] 为空串表示回到设备自身 release。
  Future<GhostLockProfileConfig> selectBuiltin({
    required String release,
    required String profileRelease,
  });

  /// 指定生效的用户文档；[name] 为空串表示不使用导入层。
  Future<GhostLockProfileConfig> selectUserProfile({
    required String release,
    required String name,
  });

  /// 把当前生效配置导出到 [path]。
  Future<bool> export({required String release, required String path});

  /// 把当前生效配置另存为一份用户文档。
  Future<bool> saveModified({required String release});
}
