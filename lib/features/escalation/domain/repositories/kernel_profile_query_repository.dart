import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_editor.dart';

/// 用户 profile **只读**仓储。
abstract class KernelProfileQueryRepository {
  /// 列出用户导入的全部文档（最近修改优先）。
  Future<List<KernelProfile>> listImported();

  /// 列出内置 profile（不含用户导入）。
  Future<List<KernelProfile>> listBuiltin();

  /// 读一份 profile 的原始 HOCON 文本；`name` 为空时按 `release` 读内置表。
  Future<String> readContent({required String name, required String release});

  /// 读取用户文档的可编辑字段；没有对应文档时 `name` 为空串。
  Future<KernelProfileEditorState> readEditor({required String name});

  /// 当前生效的用户文档名；未选择返回空串。
  Future<String> activeImportedProfile();

  /// 当前生效的内置表 release；未选择返回空串。
  Future<String> activeBuiltinRelease();
}
