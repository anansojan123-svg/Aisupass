import 'package:Aisupass/features/escalation/domain/enums/ghost_lock_kind.dart';
import 'package:Aisupass/features/escalation/domain/enums/run_log_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_outcome.freezed.dart';

/// 一次 GhostLock 运行产出的证据与结论。
///
/// 终局判定由仓储实现给出，本类只承载数据。
@freezed
abstract class GhostLockOutcome with _$GhostLockOutcome {
  const GhostLockOutcome._();

  const factory GhostLockOutcome({
    /// 终局分类；[GhostLockKind.running] 表示还有后续块。
    required GhostLockKind kind,

    /// 会话标识；受理失败时为空串。
    required String sessionId,

    /// 自上次块以来新增的输出，直接写屏。
    required String output,

    /// 累积输出，只有终局块非空；判定依据就是它。
    required String log,

    /// 退出码；`0` 完成，`1` 失败，`255` 原生 `pr_error`，`70` 脏竞争。
    required int exitCode,

    /// 从受理到终局的耗时（毫秒）。
    required int durationMs,

    /// 是否因本侧取消或超时停止读取；**不代表设备侧进程已停止**。
    required bool timedOut,

    /// 受理失败原因码；受理成功时为空串。
    required String reason,

    /// 原生侧诊断码（`profileWriteFailed` / `launchFailed` / `nativeNotStarted`
    /// / `unknownSession` 或异常类名）；无异常时为空串。
    required String failure,
  }) = _GhostLockOutcome;

  /// 是否拿到 KSU 接管。
  bool get success => kind == GhostLockKind.succeeded;

  /// 是否已到终局。
  bool get isFinal => kind != GhostLockKind.running;

  /// 本轮该记成什么日志结论。
  RunLogResult get logResult => success
      ? RunLogResult.success
      : kind == GhostLockKind.timedOut
      ? RunLogResult.interrupted
      : RunLogResult.failed;
}
