import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

/// 只读侧：列表 / 正文 / 全量导出 / 失败归因。全部一行转发，不做任何加工。
///
/// `diagnose` 归 Query：它只读传入的行数组并返回规则码 + 证据，不改变任何状态。
class RunLogQueryDatasource {
  const RunLogQueryDatasource({required this._native});

  final pigeon.Cve98260RunLogNative _native;

  Future<List<pigeon.RunLogMetaDto>> listRuns() => _native.listRuns();

  Future<List<String>> readBody({required String fileName}) =>
      _native.readBody(fileName);

  Future<String> exportAllText() => _native.exportAllText();

  Future<pigeon.RunLogDiagnosisDto> diagnose({
    required List<String> lines,
    required int exitCode,
  }) => _native.diagnose(
    pigeon.RunLogDiagnoseRequest(lines: lines, exitCode: exitCode),
  );
}
