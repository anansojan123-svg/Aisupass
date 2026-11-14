import 'package:Aisupass/features/escalation/domain/enums/ghost_key_kind.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_key_stage_status.dart';
import 'package:Aisupass/features/escalation/domain/enums/run_log_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_key_outcome.freezed.dart';

/// 一次 GhostKey 运行产出的证据与结论。
///
/// 终局判定由仓储实现给出，本类只承载数据。
@freezed
abstract class GhostKeyOutcome with _$GhostKeyOutcome {
  const GhostKeyOutcome._();

  const factory GhostKeyOutcome({
    /// 终局分类；[GhostKeyKind.running] 表示还有后续块。
    required GhostKeyKind kind,

    /// 自上次块以来新增的输出（stdout 与 stderr 合并），直接写屏。
    required String output,

    /// 累积输出，只有终局块非空；判定依据就是它。
    required String log,

    /// 五阶段总进度，`0`～`1`。
    required double fraction,

    /// 五阶段状态，长度恒为 5，下标对应 `GhostKeyStage.index`。
    required List<GhostKeyStageStatus> stageStatuses,

    /// 五阶段耗时（毫秒），长度恒为 5，下标同上。
    required List<int> stageDurations,

    /// 会话级退出码；`-1` 表示没拿到。
    required int exitCode,

    /// 是否因超时或本侧取消而掐断了某个阶段。
    required bool timedOut,

    /// 从受理到本次轮询的耗时（毫秒）。
    required int durationMs,

    /// 原生侧异常类名，或 `"<stage>: exit frame missing"`；空串表示无异常。
    required String failure,

    /// 被拒原因码；空串表示已受理。
    required String reason,
  }) = _GhostKeyOutcome;

  /// 是否拿到临时 root。
  ///
  /// [GhostKeyKind.degraded] 也算成功：`calib_b` 用 fallback 后流水线仍走完。
  bool get success =>
      kind == GhostKeyKind.succeeded || kind == GhostKeyKind.degraded;

  /// 终局块。
  bool get isFinal => kind != GhostKeyKind.running;

  /// 本轮该记成什么日志结论。
  RunLogResult get logResult => success
      ? RunLogResult.success
      : kind == GhostKeyKind.timedOut
      ? RunLogResult.interrupted
      : RunLogResult.failed;
}
