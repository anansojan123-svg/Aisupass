import 'package:Aisupass/features/escalation/domain/models/ghost_lock_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';

/// GhostLock profile 导入与用户文档管理仓储接口。
abstract class GhostLockProfileActionRepository {
  /// 解析内核表但不落盘。
  Future<GhostLockProbe> probeProfile({
    required String input,
    bool insecure = false,
  });

  /// 解析进度快照；未被解析占用时全为 0。
  Future<GhostLockProbeProgress> profileProgress();

  /// 把 [probeProfile] 返回的文本落盘。
  ///
  /// [overwrite] 为 false 时，同名文件存在会返回
  /// `requiresOverwrite`，由 UI 询问后再以 true 重试。
  Future<GhostLockImportResult> saveProfile({
    required String release,
    required String conf,
    bool overwrite = false,
  });

  /// 从本地镜像路径或 http(s) 直链提取并落盘。
  ///
  /// [overwrite] 为 false 时，同名文件存在会返回
  /// `requiresOverwrite`，由 UI 询问后再以 true 重试。
  Future<GhostLockImportResult> importProfile({
    required String input,
    bool insecure = false,
    bool overwrite = false,
  });

  /// 列出用户导入的全部 profile，按导入时间倒序。
  Future<List<GhostLockUserProfile>> listImportedProfiles();

  /// 列出内置内核表的全部 release，升序。
  Future<List<String>> listBuiltinReleases();

  /// 读取一份 profile 的完整 HOCON 文本；不存在返回空串。
  Future<String> readImportedProfile({required String name});

  /// 删除一份 profile；不存在返回 false。
  Future<bool> removeImportedProfile({required String name});
}
