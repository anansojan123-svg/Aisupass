import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;

/// GhostLock profile 导入数据源。
///
/// 只做原生转发，提取与落盘都在 Kotlin/Rust 侧。
class GhostLockProfileActionDatasource {
  GhostLockProfileActionDatasource({required this._native});

  final pigeon.GhostLockProfileNative _native;

  /// 解析内核表，不落盘。
  ///
  /// [xblPath] / [uefiPath] / [vendorBootPath] 是可选的附加镜像，空串表示没有；
  /// [phys] 是用户手填的物理装载基址。[kallsymsPath] / [iomemPath] 是外部文本
  /// 文件，[route] 强制路由，空串均表示自动。
  Future<pigeon.GhostLockProbeResult> probeProfile({
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
  }) => _native.probeProfile(
    input,
    insecure,
    xblPath,
    uefiPath,
    vendorBootPath,
    phys,
    kallsymsPath,
    iomemPath,
    route,
    allowMissing,
    noDisasm,
  );

  /// 解析进度快照：`"<phase> <done> <total>"`。
  Future<String> profileProgress() => _native.profileProgress();

  /// 把解析结果落盘。
  Future<pigeon.GhostLockImportResult> saveProfile({
    required String release,
    required String conf,
    bool overwrite = false,
  }) => _native.saveProfile(release, conf, overwrite);

  /// 列出用户导入的 profile。
  Future<List<pigeon.GhostLockUserProfile>> listImportedProfiles() =>
      _native.listImportedProfiles();

  /// 列出内置内核表的全部 release。
  Future<List<String>> listBuiltinReleases() => _native.listBuiltinReleases();

  /// 读取一份 profile 的 HOCON 文本。
  Future<String> readImportedProfile({required String name}) =>
      _native.readImportedProfile(name);

  /// 删除一份 profile。
  Future<bool> removeImportedProfile({required String name}) =>
      _native.removeImportedProfile(name);

  /// 导入现成的 profile 文本（HOCON 或 JSON）。
  Future<pigeon.GhostLockImportResult> importProfileText({
    required String text,
    required String fileName,
    bool overwrite = false,
  }) => _native.importProfileText(text, fileName, overwrite);

  /// 重命名用户文档；返回新文件名，失败为空串。
  Future<String> renameImportedProfile({
    required String name,
    required String newName,
  }) => _native.renameImportedProfile(name, newName);

  /// 把用户文档渲染为 HOCON 文本。
  Future<String> exportImportedProfile({required String name}) =>
      _native.exportImportedProfile(name);

  /// 把旧格式文档转换为当前布局。
  Future<pigeon.GhostLockImportResult> convertImportedProfile({
    required String name,
  }) => _native.convertImportedProfile(name);
}
