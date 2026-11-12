import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;

/// GhostLock 运行数据源。
///
/// 只做原生转发，受理判定与结果分型都在仓储实现里。
class GhostLockActionDatasource {
  GhostLockActionDatasource({required this._native});

  final pigeon.GhostLockNative _native;

  /// 运行前自检。
  Future<pigeon.GhostLockPreflight> preflight() => _native.preflight();

  /// 受理一次运行。
  Future<pigeon.GhostLockStartResult> start({
    required pigeon.GhostLockRequest request,
  }) => _native.start(request);

  /// 取走自上次轮询以来积累的输出。
  Future<pigeon.GhostLockChunk> poll({required String sessionId}) =>
      _native.poll(sessionId);

  /// 停止本侧读取。设备侧进程不受影响。
  Future<void> cancel({required String sessionId}) => _native.cancel(sessionId);
}
