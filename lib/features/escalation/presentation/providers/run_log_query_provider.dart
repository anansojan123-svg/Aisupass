import 'package:Aisupass/core/providers/escalation_native_provider.dart';
import 'package:Aisupass/features/escalation/data/datasources/run_log_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/run_log_query_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_diagnosis.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/features/escalation/domain/repositories/run_log_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'run_log_query_provider.g.dart';

@riverpod
RunLogQueryDatasource runLogQueryDatasource(Ref ref) =>
    RunLogQueryDatasource(native: ref.watch(cve98260RunLogNativeProvider));

@riverpod
RunLogQueryRepository runLogQueryRepository(Ref ref) =>
    RunLogQueryRepositoryImpl(
      datasource: ref.watch(runLogQueryDatasourceProvider),
    );

/// 列表页数据源。返回 `Future`，页面用 `AsyncValue` 三态。
@riverpod
Future<List<RunLogMeta>> runLogs(Ref ref) =>
    ref.watch(runLogQueryRepositoryProvider).listRuns();

/// 全量导出为一个字符串（每条记录带分隔头）。列表页「导出全部」用。
///
/// 页面**不许** `ref.read(runLogQueryRepositoryProvider).exportAllText()`
/// （`coding.md §7:438`：UI 不得直调 Repository），必须经本 Provider。
@riverpod
Future<String> exportAllRunLogs(Ref ref) =>
    ref.watch(runLogQueryRepositoryProvider).exportAllText();

/// 单条日志正文。参数是 `RunLogMeta.fileName`。
@riverpod
Future<List<String>> runLogBody(Ref ref, {required String fileName}) async {
  final List<RunLogMeta> metas = await ref.watch(runLogsProvider.future);
  final RunLogMeta? meta = _findByFile(metas, fileName);
  if (meta == null) return const <String>[];
  return ref.watch(runLogQueryRepositoryProvider).readBody(meta: meta);
}

/// 失败归因。一次性调用，不订阅。
@riverpod
Future<RunLogDiagnosis> diagnoseRunLog(
  Ref ref, {
  required List<String> lines,
  required int exitCode,
}) => ref
    .watch(runLogQueryRepositoryProvider)
    .diagnose(lines: lines, exitCode: exitCode);

RunLogMeta? _findByFile(List<RunLogMeta> metas, String fileName) {
  for (final RunLogMeta meta in metas) {
    if (meta.fileName == fileName) return meta;
  }
  return null;
}
