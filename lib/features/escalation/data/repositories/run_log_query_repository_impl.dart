import 'package:Aisupass/features/escalation/data/datasources/run_log_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/run_log_diagnosis_dto.dart';
import 'package:Aisupass/features/escalation/data/models/run_log_meta_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_diagnosis.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/features/escalation/domain/repositories/run_log_query_repository.dart';

/// 只读仓储实现。DTO -> Entity 转换点之一。
class RunLogQueryRepositoryImpl implements RunLogQueryRepository {
  const RunLogQueryRepositoryImpl({required this._datasource});

  final RunLogQueryDatasource _datasource;

  @override
  Future<List<RunLogMeta>> listRuns() async {
    final List<RunLogMetaDto> dtos = (await _datasource.listRuns())
        .map(RunLogMetaDto.fromNative)
        .toList(growable: false);
    return dtos
        .map((RunLogMetaDto dto) => dto.toEntity())
        .toList(growable: false);
  }

  @override
  Future<List<String>> readBody({required RunLogMeta meta}) =>
      _datasource.readBody(fileName: meta.fileName);

  @override
  Future<String> exportAllText() => _datasource.exportAllText();

  @override
  Future<RunLogDiagnosis> diagnose({
    required List<String> lines,
    required int exitCode,
  }) async {
    final RunLogDiagnosisDto dto = RunLogDiagnosisDto.fromNative(
      await _datasource.diagnose(lines: lines, exitCode: exitCode),
      exitCode: exitCode,
    );
    return dto.toEntity();
  }
}
