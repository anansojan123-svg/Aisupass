import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_probe_progress.freezed.dart';

/// GhostLock profile 解析进度的即时快照。
///
/// [phase] 0 = 下载（字节），1 = 解包与解析，2 = 完成；不同阶段单位不同，
/// 不跨阶段比较。
@freezed
abstract class GhostLockProbeProgress with _$GhostLockProbeProgress {
  const GhostLockProbeProgress._();

  const factory GhostLockProbeProgress({
    /// 阶段：0 下载，1 解包与解析，2 完成。
    required int phase,

    /// 本阶段已完成量。
    required int done,

    /// 本阶段总量；未知时为 `0`。
    required int total,
  }) = _GhostLockProbeProgress;

  /// 是否处于下载阶段。
  bool get downloading => phase == 0;

  /// 是否已结束。
  bool get finished => phase >= 2;

  /// 完成比例 0..1；总量未知时为 `0`。
  double get fraction => total <= 0 ? 0 : (done / total).clamp(0, 1).toDouble();
}
