// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_log_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(runLogQueryDatasource)
const runLogQueryDatasourceProvider = RunLogQueryDatasourceProvider._();

final class RunLogQueryDatasourceProvider
    extends
        $FunctionalProvider<
          RunLogQueryDatasource,
          RunLogQueryDatasource,
          RunLogQueryDatasource
        >
    with $Provider<RunLogQueryDatasource> {
  const RunLogQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runLogQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runLogQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<RunLogQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RunLogQueryDatasource create(Ref ref) {
    return runLogQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunLogQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunLogQueryDatasource>(value),
    );
  }
}

String _$runLogQueryDatasourceHash() =>
    r'97324cfc649eb60037e2195a8eb049b07cbce157';

@ProviderFor(runLogQueryRepository)
const runLogQueryRepositoryProvider = RunLogQueryRepositoryProvider._();

final class RunLogQueryRepositoryProvider
    extends
        $FunctionalProvider<
          RunLogQueryRepository,
          RunLogQueryRepository,
          RunLogQueryRepository
        >
    with $Provider<RunLogQueryRepository> {
  const RunLogQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runLogQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runLogQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<RunLogQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RunLogQueryRepository create(Ref ref) {
    return runLogQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunLogQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunLogQueryRepository>(value),
    );
  }
}

String _$runLogQueryRepositoryHash() =>
    r'5cdb2e8a1ee2817c0d877e853a66085549fcc248';

/// 列表页数据源。返回 `Future`，页面用 `AsyncValue` 三态。

@ProviderFor(runLogs)
const runLogsProvider = RunLogsProvider._();

/// 列表页数据源。返回 `Future`，页面用 `AsyncValue` 三态。

final class RunLogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RunLogMeta>>,
          List<RunLogMeta>,
          FutureOr<List<RunLogMeta>>
        >
    with $FutureModifier<List<RunLogMeta>>, $FutureProvider<List<RunLogMeta>> {
  /// 列表页数据源。返回 `Future`，页面用 `AsyncValue` 三态。
  const RunLogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runLogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runLogsHash();

  @$internal
  @override
  $FutureProviderElement<List<RunLogMeta>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RunLogMeta>> create(Ref ref) {
    return runLogs(ref);
  }
}

String _$runLogsHash() => r'b1050ed67d53e8c87bb2c6b0c5d51c462397a905';

/// 全量导出为一个字符串（每条记录带分隔头）。列表页「导出全部」用。
///
/// 页面**不许** `ref.read(runLogQueryRepositoryProvider).exportAllText()`
/// （`coding.md §7:438`：UI 不得直调 Repository），必须经本 Provider。

@ProviderFor(exportAllRunLogs)
const exportAllRunLogsProvider = ExportAllRunLogsProvider._();

/// 全量导出为一个字符串（每条记录带分隔头）。列表页「导出全部」用。
///
/// 页面**不许** `ref.read(runLogQueryRepositoryProvider).exportAllText()`
/// （`coding.md §7:438`：UI 不得直调 Repository），必须经本 Provider。

final class ExportAllRunLogsProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 全量导出为一个字符串（每条记录带分隔头）。列表页「导出全部」用。
  ///
  /// 页面**不许** `ref.read(runLogQueryRepositoryProvider).exportAllText()`
  /// （`coding.md §7:438`：UI 不得直调 Repository），必须经本 Provider。
  const ExportAllRunLogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exportAllRunLogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exportAllRunLogsHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return exportAllRunLogs(ref);
  }
}

String _$exportAllRunLogsHash() => r'1cf24a2cf3f46dbb91c25ad4b5618a1ee1eff82c';

/// 单条日志正文。参数是 `RunLogMeta.fileName`。

@ProviderFor(runLogBody)
const runLogBodyProvider = RunLogBodyFamily._();

/// 单条日志正文。参数是 `RunLogMeta.fileName`。

final class RunLogBodyProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// 单条日志正文。参数是 `RunLogMeta.fileName`。
  const RunLogBodyProvider._({
    required RunLogBodyFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'runLogBodyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runLogBodyHash();

  @override
  String toString() {
    return r'runLogBodyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return runLogBody(ref, fileName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RunLogBodyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runLogBodyHash() => r'54fc46e1bbafc0e638090025d799b11dfc53a528';

/// 单条日志正文。参数是 `RunLogMeta.fileName`。

final class RunLogBodyFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String> {
  const RunLogBodyFamily._()
    : super(
        retry: null,
        name: r'runLogBodyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 单条日志正文。参数是 `RunLogMeta.fileName`。

  RunLogBodyProvider call({required String fileName}) =>
      RunLogBodyProvider._(argument: fileName, from: this);

  @override
  String toString() => r'runLogBodyProvider';
}

/// 失败归因。一次性调用，不订阅。

@ProviderFor(diagnoseRunLog)
const diagnoseRunLogProvider = DiagnoseRunLogFamily._();

/// 失败归因。一次性调用，不订阅。

final class DiagnoseRunLogProvider
    extends
        $FunctionalProvider<
          AsyncValue<RunLogDiagnosis>,
          RunLogDiagnosis,
          FutureOr<RunLogDiagnosis>
        >
    with $FutureModifier<RunLogDiagnosis>, $FutureProvider<RunLogDiagnosis> {
  /// 失败归因。一次性调用，不订阅。
  const DiagnoseRunLogProvider._({
    required DiagnoseRunLogFamily super.from,
    required ({List<String> lines, int exitCode}) super.argument,
  }) : super(
         retry: null,
         name: r'diagnoseRunLogProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diagnoseRunLogHash();

  @override
  String toString() {
    return r'diagnoseRunLogProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RunLogDiagnosis> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RunLogDiagnosis> create(Ref ref) {
    final argument = this.argument as ({List<String> lines, int exitCode});
    return diagnoseRunLog(
      ref,
      lines: argument.lines,
      exitCode: argument.exitCode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DiagnoseRunLogProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diagnoseRunLogHash() => r'b5038b5dde5e3dcc3ab6af76583f63c434eab486';

/// 失败归因。一次性调用，不订阅。

final class DiagnoseRunLogFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<RunLogDiagnosis>,
          ({List<String> lines, int exitCode})
        > {
  const DiagnoseRunLogFamily._()
    : super(
        retry: null,
        name: r'diagnoseRunLogProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 失败归因。一次性调用，不订阅。

  DiagnoseRunLogProvider call({
    required List<String> lines,
    required int exitCode,
  }) => DiagnoseRunLogProvider._(
    argument: (lines: lines, exitCode: exitCode),
    from: this,
  );

  @override
  String toString() => r'diagnoseRunLogProvider';
}
