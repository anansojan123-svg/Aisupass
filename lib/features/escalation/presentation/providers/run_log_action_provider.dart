import 'package:Aisupass/core/providers/escalation_native_provider.dart';
import 'package:Aisupass/features/escalation/data/datasources/run_log_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/run_log_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/enums/run_log_result.dart';
import 'package:Aisupass/features/escalation/domain/models/run_log_meta.dart';
import 'package:Aisupass/features/escalation/domain/repositories/run_log_action_repository.dart';
import 'package:Aisupass/features/escalation/presentation/providers/run_log_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'run_log_action_provider.g.dart';

@riverpod
RunLogActionDatasource runLogActionDatasource(Ref ref) =>
    RunLogActionDatasource(native: ref.watch(cve98260RunLogNativeProvider));

/// 写侧仓储。持有本轮写盘游标，故不随页面回收。
@Riverpod(keepAlive: true)
RunLogActionRepository runLogActionRepository(Ref ref) =>
    RunLogActionRepositoryImpl(
      datasource: ref.watch(runLogActionDatasourceProvider),
    );

/// 运行日志的写操作。
///
/// 无参 `keepAlive` 类，参数走方法入参：带参族函数会按参数缓存，
/// 同样的参数第二次调用不再执行方法体。
@Riverpod(keepAlive: true)
RunLogActions runLogActions(Ref ref) => RunLogActions(ref);

/// 见 [runLogActions]。
class RunLogActions {
  RunLogActions(this._ref);

  final Ref _ref;

  /// 开一轮，返回新建的 `RunLogMeta`（含 `fileName`）。
  Future<RunLogMeta> begin({
    required String device,
    required String kernel,
    required String profile,
  }) async {
    final RunLogMeta meta = await _ref
        .read(runLogActionRepositoryProvider)
        .beginRun(device: device, kernel: kernel, profile: profile);
    _ref.invalidate(runLogsProvider);
    return meta;
  }

  /// 追加日志行。
  Future<void> appendLines({
    required String fileName,
    required List<String> lines,
  }) => _ref
      .read(runLogActionRepositoryProvider)
      .appendLines(fileName: fileName, lines: lines);

  /// 追加本轮新增的日志尾部。
  Future<void> appendChunk({
    required String fileName,
    required String fullText,
  }) => _ref
      .read(runLogActionRepositoryProvider)
      .appendChunk(fileName: fileName, fullText: fullText);

  /// 收尾并刷新列表。
  Future<void> finishChunk({
    required String fileName,
    required RunLogResult result,
    required int exitCode,
    required int durationMs,
  }) async {
    await _ref
        .read(runLogActionRepositoryProvider)
        .finishChunk(
          fileName: fileName,
          result: result,
          exitCode: exitCode,
          durationMs: durationMs,
        );
    _ref.invalidate(runLogsProvider);
  }

  /// 删除单条。
  Future<void> delete(RunLogMeta meta) async {
    await _ref.read(runLogActionRepositoryProvider).deleteRun(meta: meta);
    _ref.invalidate(runLogsProvider);
  }

  /// 清空全部。
  Future<void> clear() async {
    await _ref.read(runLogActionRepositoryProvider).clearRuns();
    _ref.invalidate(runLogsProvider);
  }
}
