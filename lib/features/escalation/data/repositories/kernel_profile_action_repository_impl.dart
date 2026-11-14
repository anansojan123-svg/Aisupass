import 'dart:async';

import 'package:Aisupass/features/escalation/data/datasources/kernel_profile_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/kernel_profile_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/kernel_profile_import_result_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_state.dart';
import 'package:Aisupass/features/escalation/domain/repositories/kernel_profile_action_repository.dart';

/// 写仓储实现。导入用「流 + 轮询进度」。
class KernelProfileActionRepositoryImpl
    implements KernelProfileActionRepository {
  const KernelProfileActionRepositoryImpl({
    required this._datasource,
    required this._query,
  });

  /// 轮询间隔。导入耗时集中在 `parse()`：200 MB 的 boot.img 在低端机上
  /// 可能到数十秒，200 ms 足够让进度条不卡顿，又不至于把一次导入打成上千次 IPC。
  static const Duration _pollInterval = Duration(milliseconds: 200);

  final KernelProfileActionDatasource _datasource;

  final KernelProfileQueryDatasource _query;

  @override
  Stream<KernelProfileImportState> importBootImage({required String path}) =>
      _watch(_datasource.importBootImage(path: path));

  @override
  Stream<KernelProfileImportState> importBootImageFromUrl({
    required String url,
  }) => _watch(_datasource.importBootImageFromUrl(url: url));

  @override
  Future<bool> removeImportedProfile({required String release}) =>
      _datasource.removeImportedProfile(release: release);

  @override
  Future<KernelProfileImportResult> saveEditor({
    required String release,
    required Map<String, String> values,
  }) async => (await _datasource.saveEditor(
    release: release,
    values: values,
  )).toEntity();

  @override
  Future<String> renderEditor({
    required String release,
    required Map<String, String> values,
  }) => _datasource.renderEditor(release: release, values: values);

  /// 订阅一侧的导入任务，同时轮询进度；任务结束补一帧带真结果的进度块。
  Stream<KernelProfileImportState> _watch(
    Future<KernelProfileImportResultDto> task,
  ) async* {
    bool done = false;
    unawaited(
      task.then<void>(
        (_) {
          done = true;
        },
        onError: (Object _) {
          done = true;
        },
      ),
    );

    while (!done) {
      yield _progress(await _query.importProgress());
      await Future<void>.delayed(_pollInterval);
    }

    final KernelProfileImportResultDto dto = await task;
    // 终局帧强制推进到完成相位：失败时原生进度可能停在定位相位（例如链接不是
    // OTA 包，一个字节都没下），不强制就会让页面的 `finished` 永远为假，
    // 结果条和错误文案都不显示。
    yield _progress(await _query.importProgress()).copyWith(
      phase: KernelProfileImportState.phaseDone,
      done: 1,
      total: 1,
      result: dto.toEntity(),
    );
  }

  /// 解析 `"<phase> <done> <total>"`；非法值一律按 0。
  KernelProfileImportState _progress(String raw) {
    final List<String> parts = raw.trim().split(RegExp(r'\s+'));
    int at(int index) =>
        index < parts.length ? (int.tryParse(parts[index]) ?? 0) : 0;
    return KernelProfileImportState(
      phase: at(0),
      done: at(1),
      total: at(2),
      result: KernelProfileImportState.pendingResult,
    );
  }
}
