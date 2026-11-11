import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

/// 写侧：开轮 / 追加行 / 收尾 / 删除 / 清空。
///
/// 归因（`diagnose`）在只读侧 `RunLogQueryDatasource`——它不改状态。
class RunLogActionDatasource {
  RunLogActionDatasource({required this._native});

  final pigeon.Cve98260RunLogNative _native;

  Future<pigeon.RunLogMetaDto> beginRun({
    required String device,
    required String kernel,
    required String profile,
  }) => _native.beginRun(
    pigeon.RunLogBeginRequest(
      device: device,
      kernel: kernel,
      profile: profile,
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
}
