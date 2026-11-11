import 'package:Aisupass/features/escalation/domain/models/run_log_diagnosis.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';

/// 运行日志**只读**仓储。
abstract class RunLogQueryRepository {
  /// 全部历史运行记录，按开始时间倒序。
  Future<List<RunLogMeta>> listRuns();

  /// 单条日志正文（不含头尾标记行）。
  Future<List<String>> readBody({required RunLogMeta meta});

  /// 全量导出为一个字符串（每条记录带分隔头）。
  Future<String> exportAllText();

  /// 失败归因。只读传入的行，不改变任何状态。
  Future<RunLogDiagnosis> diagnose({
    required List<String> lines,
    required int exitCode,
  });
}
