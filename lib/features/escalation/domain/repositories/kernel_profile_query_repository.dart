import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';

/// 用户 profile **只读**仓储。
abstract class KernelProfileQueryRepository {
  /// 列出用户导入的全部 profile。
  Future<List<KernelProfile>> listImported();

  /// 读取一份 profile 的原始 HOCON 文本；文件不存在返回空串。
  Future<String> readContent({required String release});
}
