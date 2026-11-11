/// 单个阶段的状态。
///
/// 成员比上游 `StageState` 少一个 `STOPPED`：本移植不移植 `StageTracker.stop()`，
/// 原因见 `05` 的差异表。
enum GhostKeyStageStatus {
  /// 尚未开始。
  pending,

  /// 正在执行。
  running,

  /// 完成。
  success,

  /// 完成，但走了兜底路径（`calib_b` 回退 profile 默认值）。
  degraded,

  /// 失败。
  failed,

  /// 没跑到，流水线已结束。
  skipped;

  /// 把原生状态码转成枚举。
  ///
  /// 原生只回 `running` / `ok` / `degraded` / `failed` / `skipped`；
  /// `pending` 与 `success` 是内部态，也一并认，便于往返。
  /// 禁止直接调用 `values.byName`：遇到未知名字会抛异常。
  static GhostKeyStageStatus fromName(String? value) {
    switch (value) {
      case 'pending':
        return GhostKeyStageStatus.pending;
      case 'running':
        return GhostKeyStageStatus.running;
      case 'ok':
      case 'success':
        return GhostKeyStageStatus.success;
      case 'degraded':
        return GhostKeyStageStatus.degraded;
      case 'failed':
        return GhostKeyStageStatus.failed;
      case 'skipped':
        return GhostKeyStageStatus.skipped;
      default:
        return GhostKeyStageStatus.failed;
    }
  }
}
