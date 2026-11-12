import 'package:Aisupass/features/escalation/domain/enums/ghost_lock_kind.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_outcome.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_outcome_dto.freezed.dart';
part 'ghost_lock_outcome_dto.g.dart';

/// 原生一次轮询快照。
///
/// 前 6 个字段与 `pigeon.GhostLockChunk` 一一对应；`kind` / `log` / `reason`
/// 由仓储实现用 `copyWith` 填入后再 [toEntity]。
@freezed
abstract class GhostLockOutcomeDto with _$GhostLockOutcomeDto {
  const GhostLockOutcomeDto._();

  const factory GhostLockOutcomeDto({
    @Default('') String sessionId,
    @Default('') String output,
    @Default(-1) int exitCode,
    @Default(0) int durationMs,
    @Default(false) bool timedOut,

    /// 原生侧异常类名或本侧诊断码；空串表示无异常。
    @Default('') String failure,

    /// 终局分类。默认 [GhostLockKind.running]，由仓储实现覆盖。
    @Default(GhostLockKind.running) GhostLockKind kind,

    /// 累积输出。中间块为空串，终局块由仓储实现填入。
    @Default('') String log,

    /// 受理失败原因码；受理成功时为空串。
    @Default('') String reason,
  }) = _GhostLockOutcomeDto;

  factory GhostLockOutcomeDto.fromJson(Map<String, dynamic> json) =>
      _$GhostLockOutcomeDtoFromJson(json);

  /// 原生快照 → DTO。
  factory GhostLockOutcomeDto.fromNative(pigeon.GhostLockChunk chunk) =>
      GhostLockOutcomeDto(
        sessionId: chunk.sessionId,
        output: chunk.output,
        exitCode: chunk.exitCode,
        durationMs: chunk.durationMs,
        timedOut: chunk.timedOut,
        failure: chunk.failure,
      );

  /// 转成领域实体。无参数：判定结果先落进本 DTO 的 [kind] / [log] / [reason]。
  GhostLockOutcome toEntity() => GhostLockOutcome(
    kind: kind,
    sessionId: sessionId,
    output: output,
    log: log,
    exitCode: exitCode,
    durationMs: durationMs,
    timedOut: timedOut,
    reason: reason,
  );
}
