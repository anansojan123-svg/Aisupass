import 'package:Aisupass/features/escalation/domain/models/ghost_lock_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';

/// GhostLock profile 导入与用户文档管理仓储接口。
abstract class GhostLockProfileActionRepository {
  /// 解析内核表但不落盘。
  ///
  /// [xblPath] / [uefiPath] / [vendorBootPath] 是可选的附加镜像，用于补齐
  /// `kernel_phys_load`；传空串表示没有。[phys] 是手填的物理装载基址。
  /// [kallsymsPath] / [iomemPath] 是外部文本文件，[route] 强制路由，
  /// 空串均表示自动。
  Future<GhostLockProbe> probeProfile({
    required String input,
    bool insecure = false,
    String xblPath = '',
    String uefiPath = '',
    String vendorBootPath = '',
    String phys = '',
    String kallsymsPath = '',
    String iomemPath = '',
    String route = '',
    bool allowMissing = false,
    bool noDisasm = false,
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

  /// 列出用户导入的全部 profile，按导入时间倒序。
  Future<List<GhostLockUserProfile>> listImportedProfiles();

  /// 列出内置内核表的全部 release，升序。
  Future<List<String>> listBuiltinReleases();

  /// 读取一份 profile 的完整 HOCON 文本；不存在返回空串。
  Future<String> readImportedProfile({required String name});

  /// 删除一份 profile；不存在返回 false。
  Future<bool> removeImportedProfile({required String name});

  /// 导入现成的 profile 文本（HOCON 或 JSON）为一份用户文档。
  Future<GhostLockImportResult> importProfileText({
    required String text,
    required String fileName,
    bool overwrite = false,
  });

  /// 重命名用户文档；返回新文件名，失败为空串。
  Future<String> renameImportedProfile({
    required String name,
    required String newName,
  });

  /// 把用户文档渲染为 HOCON 文本；不存在返回空串。
  Future<String> exportImportedProfile({required String name});

  /// 把旧格式文档转换为当前布局并存为新文档。
  Future<GhostLockImportResult> convertImportedProfile({required String name});

  /// 把本 App 缓存里的文件另存到手机「下载」目录。
  ///
  /// 成功返回落点显示名，失败返回空串。
  Future<String> exportLocalFile({
    required String sourcePath,
    required String fileName,
  });

  /// 上一次提取在缓存里留下的镜像路径（boot / xbl_config / uefi）。
  Future<List<String>> listExtractedImages();
}
