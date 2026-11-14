import 'package:Aisupass/features/escalation/data/models/kernel_profile_import_result_dto.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

/// 用户 profile 写侧：导入与删除。
class KernelProfileActionDatasource {
  const KernelProfileActionDatasource({required this._native});

  final pigeon.Cve98260ProfileNative _native;

  /// 解析 boot.img 并落盘。
  Future<KernelProfileImportResultDto> importBootImage({
    required String path,
  }) async => _toDto(await _native.importBootImage(path));

  /// 从 OTA 链接取 boot 分区并落盘。
  Future<KernelProfileImportResultDto> importBootImageFromUrl({
    required String url,
  }) async => _toDto(await _native.importBootImageFromUrl(url));

  /// 删除一份用户 profile。
  Future<bool> removeImportedProfile({required String release}) =>
      _native.removeImportedProfile(release);

  /// 把编辑值合并回用户文档。
  Future<KernelProfileImportResultDto> saveEditor({
    required String release,
    required Map<String, String> values,
  }) async => _toDto(await _native.saveProfileEditor(release, values));

  /// 渲染编辑后的 HOCON 文本；失败返回空串。
  Future<String> renderEditor({
    required String release,
    required Map<String, String> values,
  }) => _native.renderProfileEditor(release, values);

  /// Pigeon 传输对象 -> DTO。
  static KernelProfileImportResultDto _toDto(
    pigeon.KernelProfileImportResult native,
  ) => KernelProfileImportResultDto(
    ok: native.ok,
    release: native.release,
    missing: native.missing,
    errorCode: native.errorCode,
    error: native.error,
  );
}
