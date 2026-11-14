import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_editor.dart';

/// 用户 profile **只读**仓储。
abstract class KernelProfileQueryRepository {
  /// 列出用户导入的全部 profile。
  Future<List<KernelProfile>> listImported();

  /// 列出内置 profile（不含用户导入）。
  Future<List<KernelProfile>> listBuiltin();

  /// 读取一份 profile 的原始 HOCON 文本；文件不存在返回空串。
  Future<String> readContent({required String release});

  /// 读取用户文档的可编辑字段；没有对应用户文档时 `release` 为空串。
  Future<KernelProfileEditorState> readEditor({required String release});
}
