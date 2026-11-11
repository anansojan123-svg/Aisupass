import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

/// 用户 profile 写侧：导入与删除。
class KernelProfileActionDatasource {
  const KernelProfileActionDatasource({required this._native});

  final pigeon.Cve98260ProfileNative _native;

  /// 解析 boot.img 并落盘。
  Future<pigeon.KernelProfileImportResult> importBootImage({
    required String path,
  }) => _native.importBootImage(path);

  /// 从 OTA 链接取 boot 分区并落盘。
  Future<pigeon.KernelProfileImportResult> importBootImageFromUrl({
    required String url,
  }) => _native.importBootImageFromUrl(url);

  /// 删除一份用户 profile。
  Future<bool> removeImportedProfile({required String release}) =>
      _native.removeImportedProfile(release);
}
