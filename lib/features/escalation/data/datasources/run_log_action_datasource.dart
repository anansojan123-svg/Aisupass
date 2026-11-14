import 'package:Aisupass/features/escalation/data/models/run_log_meta_dto.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

/// 写侧：开轮 / 追加行 / 收尾 / 删除 / 清空。
///
/// 归因（`diagnose`）在只读侧 `RunLogQueryDatasource`——它不改状态。
class RunLogActionDatasource {
  RunLogActionDatasource({required this._native});

  final pigeon.Cve98260RunLogNative _native;

  Future<RunLogMetaDto> beginRun({
    required String device,
    required String kernel,
    required String profile,
  }) async => _toDto(
    await _native.beginRun(
      pigeon.RunLogBeginRequest(
        device: device,
        kernel: kernel,
        profile: profile,
      ),
    ),
  );

  Future<void> appendLines({
    required String fileName,
    required List<String> lines,
  }) => _native.appendLines(fileName, lines);

  /// 本层 `exitCode` 是 `int`：上游 `GhostKeyOutcome.exitCode` 非空，整条链路
  /// 统一 `int`。Pigeon 的 `RunLogFinishRequest.exitCode` 是 `int?`，转发时
  /// 直接传（Dart 允许 `int` -> `int?` 隐式提升）。
  Future<void> finishRun({
    required String fileName,
    required String result,
    required int exitCode,
    required int durationMs,
  }) => _native.finishRun(
    pigeon.RunLogFinishRequest(
      fileName: fileName,
      result: result,
      exitCode: exitCode,
      durationMs: durationMs,
    ),
  );

  Future<void> deleteRun({required String fileName}) =>
      _native.deleteRun(fileName);

  Future<void> clearRuns() => _native.clearRuns();

  /// Pigeon 传输对象 -> DTO。原生 `exitCode` 为 null（中断）时落 `-1`，
  /// 与 `RunLogMeta.hasExitCode` 的哨兵约定一致。
  static RunLogMetaDto _toDto(pigeon.RunLogMetaDto dto) => RunLogMetaDto(
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
}
