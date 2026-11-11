import 'package:Aisupass/features/escalation/domain/enums/run_log_result.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_log_meta_dto.freezed.dart';
part 'run_log_meta_dto.g.dart';

/// 历史记录传输对象。字段与 pigeon `RunLogMetaDto` 一一对应，
/// 唯一差别是这里不持 `File`（Dart 侧不碰路径）。
@freezed
abstract class RunLogMetaDto with _$RunLogMetaDto {
  const RunLogMetaDto._();

  const factory RunLogMetaDto({
    @Default('') String fileName,
    @Default(0) int runId,
    @Default(0) int startedAt,
    @Default('') String result,
    @Default(-1) int exitCode,
    @Default(0) int durationMs,
    @Default(-1) int lineCount,
    @Default('') String device,
    @Default('') String kernel,
    @Default('') String profile,
  }) = _RunLogMetaDto;

  factory RunLogMetaDto.fromJson(Map<String, dynamic> json) =>
      _$RunLogMetaDtoFromJson(json);

  /// Pigeon 传输对象 -> DTO。原生 `exitCode` 为 null（中断）时落 `-1`，
  /// 与 `RunLogMeta.hasExitCode` 的哨兵约定一致。
  factory RunLogMetaDto.fromNative(pigeon.RunLogMetaDto dto) => RunLogMetaDto(
    fileName: dto.fileName,
    runId: dto.runId,
    startedAt: dto.startedAt,
    result: dto.result,
    exitCode: dto.exitCode ?? -1,
    durationMs: dto.durationMs,
    lineCount: dto.lineCount,
    device: dto.device,
    kernel: dto.kernel,
    profile: dto.profile,
  );

  /// DTO -> Entity。`result` 的 String -> 枚举解析全任务只此一处。
  RunLogMeta toEntity() => RunLogMeta(
    fileName: fileName,
    runId: runId,
    startedAt: startedAt,
    result: RunLogResult.fromNative(result),
    exitCode: exitCode,
    durationMs: durationMs,
    lineCount: lineCount,
    device: device,
    kernel: kernel,
    profile: profile,
  );
}
