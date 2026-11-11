import 'package:Aisupass/features/escalation/domain/enums/ghost_key_kind.dart';
import 'package:Aisupass/features/escalation/domain/enums/ghost_key_stage_status.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_outcome.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_key_outcome_dto.freezed.dart';
part 'ghost_key_outcome_dto.g.dart';

/// [GhostKeyOutcome] 的传输形态。
///
/// 前 6 个字段与 `pigeon.Cve98260Chunk` 逐字对应；`kind` / `log` / `reason` /
/// `fraction` / `stageStatuses` / `stageDurations` 不在原生侧产生，由仓储实现
/// 用 `copyWith` 填入后再 `toEntity`。
///
/// `chunk.events` 不进本 DTO：事件流由仓储实现喂给 `_StageTracker`，
/// 再由 tracker 拍快照填 `stageStatuses` / `stageDurations`。
@freezed
abstract class GhostKeyOutcomeDto with _$GhostKeyOutcomeDto {
  const GhostKeyOutcomeDto._();

  const factory GhostKeyOutcomeDto({
    @Default('') String sessionId,
    @Default('') String output,
    @Default(-1) int exitCode,
    @Default(false) bool timedOut,
    @Default(0) int durationMs,
    @Default('') String failure,
    @Default(GhostKeyKind.running) GhostKeyKind kind,
    @Default('') String log,
    @Default('') String reason,
    @Default(0.0) double fraction,
    @Default(<GhostKeyStageStatus>[]) List<GhostKeyStageStatus> stageStatuses,
    @Default(<int>[]) List<int> stageDurations,
  }) = _GhostKeyOutcomeDto;

  factory GhostKeyOutcomeDto.fromJson(Map<String, dynamic> json) =>
      _$GhostKeyOutcomeDtoFromJson(json);

  /// 只搬原生侧真实存在的 6 个字段。
  factory GhostKeyOutcomeDto.fromNative(pigeon.Cve98260Chunk chunk) =>
      GhostKeyOutcomeDto(
        sessionId: chunk.sessionId,
        output: chunk.log,
        exitCode: chunk.exitCode,
        timedOut: chunk.timedOut,
        durationMs: chunk.durationMs,
        failure: chunk.failure,
      );

  GhostKeyOutcome toEntity() => GhostKeyOutcome(
    kind: kind,
    output: output,
    log: log,
    fraction: fraction,
    stageStatuses: stageStatuses,
    stageDurations: stageDurations,
    exitCode: exitCode,
    timedOut: timedOut,
    durationMs: durationMs,
    failure: failure,
    reason: reason,
  );
}
