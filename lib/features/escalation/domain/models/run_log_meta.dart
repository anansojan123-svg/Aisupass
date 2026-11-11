import 'package:Aisupass/features/escalation/domain/enums/run_log_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_log_meta.freezed.dart';

/// 一条历史运行记录（列表页一行所需的一切）。
@freezed
abstract class RunLogMeta with _$RunLogMeta {
  const RunLogMeta._();

  const factory RunLogMeta({
    required String fileName,
    required int runId,
    required int startedAt,
    required RunLogResult result,
    required int exitCode,
    required int durationMs,
    required int lineCount,
    required String device,
    required String kernel,
    required String profile,
  }) = _RunLogMeta;

  /// 原生用 -1 表示「文件尾没写行数」（中断）。
  bool get hasLineCount => lineCount >= 0;

  /// 原生用 -1 表示「文件尾没写退出码」（中断）。
  bool get hasExitCode => exitCode >= 0;

  bool get isRunning => result == RunLogResult.running;

  DateTime get startedAtTime => DateTime.fromMillisecondsSinceEpoch(startedAt);
}
