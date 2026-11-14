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

  /// 把当前生效配置渲染为 HOCON 文本；无法解析时返回空串。
  Future<String> render({required String release});

  /// 把当前生效配置另存为一份用户文档。
  Future<bool> saveModified({required String release});

  /// 只重置通用参数的 override。
  Future<GhostLockProfileConfig> resetGeneral({required String release});

  /// 只重置路由与高级字段的 override，保留通用参数。
  Future<GhostLockProfileConfig> resetAdvanced({required String release});

  /// 把当前生效配置写回用户文档 [name]，并清掉该 release 的 override。
  Future<bool> overwriteProfile({
    required String release,
    required String name,
  });

  /// 打开编辑会话；[name] 为空串表示内置/设备态。
  Future<GhostLockProfileConfig> beginEditSession({
    required String name,
    required String deviceRelease,
  });

  /// 丢弃未保存改动，按当前会话目标重新解析。
  Future<GhostLockProfileConfig> reloadEditSession();

  /// 会话是否编辑当前生效配置。
  Future<bool> editSessionIsLive();

  /// 会话目标的文档名；内置/设备态返回空串。
  Future<String> editSessionTarget();

  /// 会话实际使用的 release。
  Future<String> editSessionRelease();

  /// 把会话 override 写入 live override。
  Future<bool> commitEditSession();

  /// 用会话结果整篇覆盖目标文档。
  Future<bool> saveEditSessionInPlace();

  /// 会话结果另存为新文档；失败返回空串。
  Future<String> saveEditSessionAsNew();

  /// 会话结果导出到 [path]。
  Future<bool> exportEditSession({required String path});

  /// 关闭会话。
  Future<void> endEditSession();
}
