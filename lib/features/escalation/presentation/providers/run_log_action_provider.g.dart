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
    r'62363c60325403ace779fb3d2dba3076fce59430';

/// 写侧仓储。持有本轮写盘游标，故不随页面回收。

@ProviderFor(runLogActionRepository)
const runLogActionRepositoryProvider = RunLogActionRepositoryProvider._();

/// 写侧仓储。持有本轮写盘游标，故不随页面回收。

final class RunLogActionRepositoryProvider
    extends
        $FunctionalProvider<
          RunLogActionRepository,
          RunLogActionRepository,
          RunLogActionRepository
        >
    with $Provider<RunLogActionRepository> {
  /// 写侧仓储。持有本轮写盘游标，故不随页面回收。
  const RunLogActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runLogActionRepositoryProvider',
        isAutoDispose: false,
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
    r'3762da693a1db86ba0c0b206c4389344e0f253c8';

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
