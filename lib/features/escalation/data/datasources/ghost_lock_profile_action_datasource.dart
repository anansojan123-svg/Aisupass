import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;

/// GhostLock profile 导入数据源。
///
/// 只做原生转发，提取与落盘都在 Kotlin/Rust 侧。
class GhostLockProfileActionDatasource {
  GhostLockProfileActionDatasource({required this._native});

  final pigeon.GhostLockProfileNative _native;

  /// 解析内核表，不落盘。
  Future<pigeon.GhostLockProbeResult> probeProfile({
    required String input,
    bool insecure = false,
  }) => _native.probeProfile(input, insecure);

  /// 解析进度快照：`"<phase> <done> <total>"`。
  Future<String> profileProgress() => _native.profileProgress();

  /// 把解析结果落盘。
  Future<pigeon.GhostLockImportResult> saveProfile({
    required String release,
    required String conf,
    bool overwrite = false,
  }) => _native.saveProfile(release, conf, overwrite);

  /// 从本地路径或 http(s) 直链提取并直接落盘。
  Future<pigeon.GhostLockImportResult> importProfile({
    required String input,
    bool insecure = false,
    bool overwrite = false,
  }) => _native.importProfile(input, insecure, overwrite);

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
}
