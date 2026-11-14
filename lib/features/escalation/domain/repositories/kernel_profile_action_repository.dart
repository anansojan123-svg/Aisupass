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
}
