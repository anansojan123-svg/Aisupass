import 'package:Aisupass/features/escalation/domain/enums/run_log_result.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';

/// 运行日志**写**仓储。
///
/// 与 `RunLogQueryRepository` 严格二分，禁止混写。
abstract class RunLogActionRepository {
  /// 开一轮：原生会先把上一轮残留的 `active` session 收尾为「中断」。
  Future<RunLogMeta> beginRun({
    required String device,
    required String kernel,
    required String profile,
  });

  /// 追加日志行。
  Future<void> appendLines({
    required String fileName,
    required List<String> lines,
  });

  /// 收尾：写 `# result=` / `# exit=` 尾标记并关闭 session。
  Future<void> finishRun({
    required String fileName,
    required RunLogResult result,
    required int exitCode,
    required int durationMs,
  });

  /// 删除单条记录。
  Future<void> deleteRun({required RunLogMeta meta});

  /// 清空全部记录（跳过正在写的 `active`）。
  Future<void> clearRuns();
}
