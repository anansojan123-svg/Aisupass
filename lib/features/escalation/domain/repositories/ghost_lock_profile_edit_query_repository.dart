import 'package:Aisupass/features/escalation/domain/models/ghost_lock_active_source.dart';

/// GhostLock profile 编辑只读仓储接口。
abstract class GhostLockProfileEditQueryRepository {
  /// 当前生效来源：内置层选中的 release 与「我的配置」文档名。
  ///
  /// 两者都为空表示两层都跟随设备。
  Future<GhostLockActiveSource> activeSource();
}
