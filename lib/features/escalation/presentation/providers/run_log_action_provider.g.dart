// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_log_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(runLogActionDatasource)
const runLogActionDatasourceProvider = RunLogActionDatasourceProvider._();

final class RunLogActionDatasourceProvider
    extends
        $FunctionalProvider<
          RunLogActionDatasource,
          RunLogActionDatasource,
          RunLogActionDatasource
        >
    with $Provider<RunLogActionDatasource> {
  const RunLogActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runLogActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runLogActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<RunLogActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RunLogActionDatasource create(Ref ref) {
    return runLogActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunLogActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunLogActionDatasource>(value),
    );
  }
}

String _$runLogActionDatasourceHash() =>
    r'13324dbfd56bef279369c764516c4d5c7ae225aa';

@ProviderFor(runLogActionRepository)
const runLogActionRepositoryProvider = RunLogActionRepositoryProvider._();

final class RunLogActionRepositoryProvider
    extends
        $FunctionalProvider<
          RunLogActionRepository,
          RunLogActionRepository,
          RunLogActionRepository
        >
    with $Provider<RunLogActionRepository> {
  const RunLogActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runLogActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runLogActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<RunLogActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RunLogActionRepository create(Ref ref) {
    return runLogActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunLogActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunLogActionRepository>(value),
    );
  }
}

String _$runLogActionRepositoryHash() =>
    r'766caf7a22f6d30d3c48b79807d3f73988ce6a12';

/// 运行日志的写操作。
///
/// 无参 `keepAlive` 类，参数走方法入参：带参族函数会按参数缓存，
/// 同样的参数第二次调用不再执行方法体。

@ProviderFor(runLogActions)
const runLogActionsProvider = RunLogActionsProvider._();

/// 运行日志的写操作。
///
/// 无参 `keepAlive` 类，参数走方法入参：带参族函数会按参数缓存，
/// 同样的参数第二次调用不再执行方法体。

final class RunLogActionsProvider
    extends $FunctionalProvider<RunLogActions, RunLogActions, RunLogActions>
    with $Provider<RunLogActions> {
  /// 运行日志的写操作。
  ///
  /// 无参 `keepAlive` 类，参数走方法入参：带参族函数会按参数缓存，
  /// 同样的参数第二次调用不再执行方法体。
  const RunLogActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runLogActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runLogActionsHash();

  @$internal
  @override
  $ProviderElement<RunLogActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RunLogActions create(Ref ref) {
    return runLogActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunLogActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunLogActions>(value),
    );
  }
}

String _$runLogActionsHash() => r'e13ff7630b44aca1ea01ef98068fc4584de8b039';
