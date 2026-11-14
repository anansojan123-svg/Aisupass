import 'package:Aisupass/features/escalation/data/models/kernel_profile_dto.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

/// 用户 profile 只读侧：列表与导入进度。
class KernelProfileQueryDatasource {
  const KernelProfileQueryDatasource({required this._native});

  final pigeon.Cve98260ProfileNative _native;

  /// 列出用户导入的全部 profile。
  Future<List<KernelProfileDto>> listImportedProfiles() async =>
      (await _native.listImportedProfiles())
          .map(_toDto)
          .toList(growable: false);

  /// 列出内置 profile（不含用户导入）。
  Future<List<KernelProfileDto>> listBuiltinProfiles() async =>
      (await _native.listBuiltinProfiles()).map(_toDto).toList(growable: false);

  /// 取导入进度快照（`"<phase> <done> <total>"`）。
  Future<String> importProgress() => _native.importProgress();

  /// 读取一份 profile 的原始 HOCON 文本；文件不存在返回空串。
  Future<String> readImportedProfile({required String release}) =>
      _native.readImportedProfile(release);

  /// Pigeon 传输对象 -> DTO。
  static KernelProfileDto _toDto(pigeon.KernelProfile native) =>
      KernelProfileDto(release: native.release, detail: native.detail);
}
