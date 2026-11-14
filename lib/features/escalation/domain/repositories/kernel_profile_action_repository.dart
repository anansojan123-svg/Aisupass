import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_state.dart';

/// 用户 profile **写**仓储。
abstract class KernelProfileActionRepository {
  /// 解析 boot.img 并落盘，按进度块吐出。
  Stream<KernelProfileImportState> importBootImage({required String path});

  /// 从 OTA 链接取 boot 分区并落盘，按进度块吐出。
  Stream<KernelProfileImportState> importBootImageFromUrl({
    required String url,
  });

  /// 删除一份用户 profile；文件不存在返回 false。
  Future<bool> removeImportedProfile({required String release});

  /// 把编辑值合并回用户文档；校验完整后才落盘。
  Future<KernelProfileImportResult> saveEditor({
    required String release,
    required Map<String, String> values,
  });

  /// 渲染编辑后的 HOCON 文本；失败返回空串。
  Future<String> renderEditor({
    required String release,
    required Map<String, String> values,
  });
}
