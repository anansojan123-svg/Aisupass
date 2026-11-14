import 'package:Aisupass/features/escalation/data/models/kernel_profile_dto.dart';
import 'package:Aisupass/features/escalation/data/models/kernel_profile_editor_dto.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

/// 用户 profile 只读侧：列表、内容、生效选择与导入进度。
class KernelProfileQueryDatasource {
  const KernelProfileQueryDatasource({required this._native});

  final pigeon.Cve98260ProfileNative _native;

  /// 列出用户导入的全部文档（最近修改优先）。
  Future<List<KernelProfileDto>> listImportedProfiles() async =>
      (await _native.listImportedProfiles())
          .map(_toDto)
          .toList(growable: false);

  /// 列出内置 profile（不含用户导入）。
  Future<List<KernelProfileDto>> listBuiltinProfiles() async =>
      (await _native.listBuiltinProfiles()).map(_toDto).toList(growable: false);

  /// 取导入进度快照（`"<phase> <done> <total>"`）。
  Future<String> importProgress() => _native.importProgress();

  /// 读一份 profile 的原始 HOCON 文本；`name` 为空时按 `release` 读内置表。
  Future<String> readProfileText({
    required String name,
    required String release,
  }) => _native.readImportedProfile(name, release);

  /// 读取用户文档的可编辑字段；没有对应文档时 `name` 为空串。
  Future<KernelProfileEditorDto> readEditor({required String name}) async =>
      KernelProfileEditorDto.fromNative(await _native.readProfileEditor(name));

  /// 当前生效的用户文档名；未选择返回空串。
  Future<String> activeImportedProfile() => _native.activeImportedProfile();

  /// 当前生效的内置表 release；未选择返回空串。
  Future<String> activeBuiltinRelease() => _native.activeBuiltinRelease();

  /// Pigeon 传输对象 -> DTO。
  static KernelProfileDto _toDto(pigeon.KernelProfile native) =>
      KernelProfileDto(
        name: native.name,
        release: native.release,
        detail: native.detail,
      );
}
