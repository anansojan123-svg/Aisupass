import 'package:Aisupass/features/escalation/domain/models/ghost_key_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';

/// GhostKey 运行仓储。
abstract class GhostKeyActionRepository {
  /// 运行前自检：ADB、shell 身份、seccomp、release、profile、二进制。
  Future<GhostKeyPreflight> preflight();

  /// 跨运行持久偏好。
  Future<GhostKeyRunDefaults> runDefaults();

  /// 写偏好。设置页改开关时调用。
  Future<void> saveRunDefaults({required GhostKeyRunDefaults defaults});

  /// 跑一次，按块吐出证据。
  ///
  /// [manager] 在 `runKsu` 为 `true` 时必需；为 `false` 时可空（不接管 KSU）。
  Stream<GhostKeyOutcome> run({RootManager? manager});

  /// 取消运行。
  ///
  /// 只停本侧读取并让 `rootd` 优雅退出，**不对任何原生进程发信号**——
  /// 它们钉住的页里有伪造 cred（`04:228-233`）。
  Future<void> cancel();
}
