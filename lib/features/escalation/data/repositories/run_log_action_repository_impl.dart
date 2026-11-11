import 'package:Aisupass/features/escalation/data/datasources/run_log_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/run_log_meta_dto.dart';
import 'package:Aisupass/features/escalation/domain/enums/run_log_result.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/features/escalation/domain/repositories/run_log_action_repository.dart';

/// 写仓储实现。DTO -> Entity 转换点之一。
class RunLogActionRepositoryImpl implements RunLogActionRepository {
  const RunLogActionRepositoryImpl({
    required this._datasource,
  });

  final RunLogActionDatasource _datasource;

  @override
  Future<RunLogMeta> beginRun({
    required String device,
    required String kernel,
    required String profile,
  }) async => RunLogMetaDto.fromNative(
    await _datasource.beginRun(
      device: device,
      kernel: kernel,
      profile: profile,
    ),
  ).toEntity();

  @override
  Future<void> appendLines({
    required String fileName,
    required List<String> lines,
  }) {
    if (lines.isEmpty) return Future<void>.value();
    return _datasource.appendLines(fileName: fileName, lines: lines);
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
  Future<void> deleteRun({required RunLogMeta meta}) =>
      _datasource.deleteRun(fileName: meta.fileName);

  @override
  Future<void> clearRuns() => _datasource.clearRuns();
}
