// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 更新查询数据源。

@ProviderFor(updateQueryDatasource)
const updateQueryDatasourceProvider = UpdateQueryDatasourceProvider._();

/// 更新查询数据源。

final class UpdateQueryDatasourceProvider
    extends
        $FunctionalProvider<
          UpdateQueryDatasource,
          UpdateQueryDatasource,
          UpdateQueryDatasource
        >
    with $Provider<UpdateQueryDatasource> {
  /// 更新查询数据源。
  const UpdateQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<UpdateQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateQueryDatasource create(Ref ref) {
    return updateQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateQueryDatasource>(value),
    );
  }
}

String _$updateQueryDatasourceHash() =>
    r'd414a82918740e9ed67b1e7f8251fd936c01f726';

/// 更新查询仓储。

@ProviderFor(updateQueryRepository)
const updateQueryRepositoryProvider = UpdateQueryRepositoryProvider._();

/// 更新查询仓储。

final class UpdateQueryRepositoryProvider
    extends
        $FunctionalProvider<
          UpdateQueryRepository,
          UpdateQueryRepository,
          UpdateQueryRepository
        >
    with $Provider<UpdateQueryRepository> {
  /// 更新查询仓储。
  const UpdateQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<UpdateQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateQueryRepository create(Ref ref) {
    return updateQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateQueryRepository>(value),
    );
  }
}

String _$updateQueryRepositoryHash() =>
    r'33468c63517e0bdda6a5dd997d1f9611cd755448';

/// 服务端最新版本；手动检查前 invalidate 本 provider 即可重新拉取。

@ProviderFor(latestUpdate)
const latestUpdateProvider = LatestUpdateProvider._();

/// 服务端最新版本；手动检查前 invalidate 本 provider 即可重新拉取。

final class LatestUpdateProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppUpdate>,
          AppUpdate,
          FutureOr<AppUpdate>
        >
    with $FutureModifier<AppUpdate>, $FutureProvider<AppUpdate> {
  /// 服务端最新版本；手动检查前 invalidate 本 provider 即可重新拉取。
  const LatestUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestUpdateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestUpdateHash();

  @$internal
  @override
  $FutureProviderElement<AppUpdate> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AppUpdate> create(Ref ref) {
    return latestUpdate(ref);
  }
}

String _$latestUpdateHash() => r'924ef439e5ab8dc51647e3746967f4e55f33c23a';
