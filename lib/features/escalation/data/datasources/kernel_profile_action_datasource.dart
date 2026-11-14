import 'package:Aisupass/features/escalation/data/models/kernel_profile_import_result_dto.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

/// 用户 profile 写侧：导入、删除、编辑与生效选择。
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

  /// 删除一份用户文档。
  Future<bool> removeImportedProfile({required String name}) =>
      _native.removeImportedProfile(name);

  /// 把编辑值写回同一份文档。
  Future<KernelProfileImportResultDto> saveEditor({
    required String name,
    required Map<String, String> values,
  }) async => _toDto(await _native.saveProfileEditor(name, values));

  /// 把编辑值另存为新文档；返回新文档名，失败为空串。
  Future<String> saveEditorAs({
    required String name,
    required String documentName,
    required Map<String, String> values,
  }) => _native.saveProfileEditorAs(name, documentName, values);

  /// 渲染编辑后的 HOCON 文本；失败返回空串。
  Future<String> renderEditor({
    required String name,
    required Map<String, String> values,
  }) => _native.renderProfileEditor(name, values);

  /// 指定生效的用户文档；空串回到自动匹配。
  Future<bool> selectImportedProfile({required String name}) =>
      _native.selectImportedProfile(name);

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
