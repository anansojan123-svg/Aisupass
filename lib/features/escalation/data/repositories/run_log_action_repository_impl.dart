import 'package:Aisupass/features/escalation/data/datasources/run_log_action_datasource.dart';
import 'package:Aisupass/features/escalation/domain/enums/run_log_result.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/features/escalation/domain/repositories/run_log_action_repository.dart';

/// 写仓储实现。DTO -> Entity 转换点之一。
class RunLogActionRepositoryImpl implements RunLogActionRepository {
  RunLogActionRepositoryImpl({required this._datasource});

  final RunLogActionDatasource _datasource;

  /// 每轮日志的写盘游标，键为文件名。
  ///
  /// 随本实例存活；`runLogActionRepositoryProvider` 已设 `keepAlive`，
  /// 避免中途回收导致游标丢失、重复写行。
  final Map<String, int> _cursors = <String, int>{};

  @override
  Future<RunLogMeta> beginRun({
    required String device,
    required String kernel,
    required String profile,
  }) async => (await _datasource.beginRun(
    device: device,
    kernel: kernel,
    profile: profile,
  )).toEntity();

  @override
  Future<void> appendLines({
    required String fileName,
    required List<String> lines,
  }) {
    if (lines.isEmpty) return Future<void>.value();
    return _datasource.appendLines(fileName: fileName, lines: lines);
  }

  @override
  Future<void> appendChunk({
    required String fileName,
    required String fullText,
  }) async {
    final int logged = _cursors[fileName] ?? 0;
    if (fullText.length <= logged) return;
    _cursors[fileName] = fullText.length;
    final List<String> lines = fullText
        .substring(logged)
        .split('\n')
        .map((String line) => line.trimRight())
        .where((String line) => line.isNotEmpty)
        .toList(growable: false);
    if (lines.isEmpty) return;
    await _datasource.appendLines(fileName: fileName, lines: lines);
  }

  @override
  Future<void> finishRun({
    required String fileName,
    required RunLogResult result,
    required int exitCode,
    required int durationMs,
  }) => _datasource.finishRun(
    fileName: fileName,
    result: result.nativeName,
    exitCode: exitCode,
    durationMs: durationMs,
  );

  @override
  Future<void> finishChunk({
    required String fileName,
    required RunLogResult result,
    required int exitCode,
    required int durationMs,
  }) async {
    try {
      await finishRun(
        fileName: fileName,
        result: result,
        exitCode: exitCode,
        durationMs: durationMs,
      );
    } finally {
      _cursors.remove(fileName);
    }
  }

  @override
  Future<void> deleteRun({required RunLogMeta meta}) =>
      _datasource.deleteRun(fileName: meta.fileName);

  @override
  Future<void> clearRuns() => _datasource.clearRuns();
}
