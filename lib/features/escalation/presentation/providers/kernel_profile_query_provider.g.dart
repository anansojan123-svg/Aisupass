// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kernel_profile_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 用户 profile 查询数据源。

@ProviderFor(kernelProfileQueryDatasource)
const kernelProfileQueryDatasourceProvider =
    KernelProfileQueryDatasourceProvider._();

/// 用户 profile 查询数据源。

final class KernelProfileQueryDatasourceProvider
    extends
        $FunctionalProvider<
          KernelProfileQueryDatasource,
          KernelProfileQueryDatasource,
          KernelProfileQueryDatasource
        >
    with $Provider<KernelProfileQueryDatasource> {
  /// 用户 profile 查询数据源。
  const KernelProfileQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kernelProfileQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kernelProfileQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<KernelProfileQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KernelProfileQueryDatasource create(Ref ref) {
    return kernelProfileQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KernelProfileQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KernelProfileQueryDatasource>(value),
    );
  }
}

String _$kernelProfileQueryDatasourceHash() =>
    r'ec19e8b8bcb0afe8983433b73290f986252aafb2';

/// 用户 profile 查询仓储。

@ProviderFor(kernelProfileQueryRepository)
const kernelProfileQueryRepositoryProvider =
    KernelProfileQueryRepositoryProvider._();

/// 用户 profile 查询仓储。

final class KernelProfileQueryRepositoryProvider
    extends
        $FunctionalProvider<
          KernelProfileQueryRepository,
          KernelProfileQueryRepository,
          KernelProfileQueryRepository
        >
    with $Provider<KernelProfileQueryRepository> {
  /// 用户 profile 查询仓储。
  const KernelProfileQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kernelProfileQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kernelProfileQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<KernelProfileQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KernelProfileQueryRepository create(Ref ref) {
    return kernelProfileQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KernelProfileQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KernelProfileQueryRepository>(value),
    );
  }
}

String _$kernelProfileQueryRepositoryHash() =>
    r'7017b3b7309cd85b00b96088918cb316a808ac1f';

/// 已导入的 profile 列表。

@ProviderFor(kernelProfileList)
const kernelProfileListProvider = KernelProfileListProvider._();

/// 已导入的 profile 列表。

final class KernelProfileListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<KernelProfile>>,
          List<KernelProfile>,
          FutureOr<List<KernelProfile>>
        >
    with
        $FutureModifier<List<KernelProfile>>,
        $FutureProvider<List<KernelProfile>> {
  /// 已导入的 profile 列表。
  const KernelProfileListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kernelProfileListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kernelProfileListHash();

  @$internal
  @override
  $FutureProviderElement<List<KernelProfile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<KernelProfile>> create(Ref ref) {
    return kernelProfileList(ref);
  }
}

String _$kernelProfileListHash() => r'7a67a283fb4838394f39e927712e847383ccd0f4';

/// 内置的 profile 列表（不含用户导入）。

@ProviderFor(kernelProfileBuiltinList)
const kernelProfileBuiltinListProvider = KernelProfileBuiltinListProvider._();

/// 内置的 profile 列表（不含用户导入）。

final class KernelProfileBuiltinListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<KernelProfile>>,
          List<KernelProfile>,
          FutureOr<List<KernelProfile>>
        >
    with
        $FutureModifier<List<KernelProfile>>,
        $FutureProvider<List<KernelProfile>> {
  /// 内置的 profile 列表（不含用户导入）。
  const KernelProfileBuiltinListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kernelProfileBuiltinListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kernelProfileBuiltinListHash();

  @$internal
  @override
  $FutureProviderElement<List<KernelProfile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<KernelProfile>> create(Ref ref) {
    return kernelProfileBuiltinList(ref);
  }
}

String _$kernelProfileBuiltinListHash() =>
    r'83e94a585784edea5d8f95f7cf53b75149541ca7';

/// 单份 profile 的原始 HOCON 文本。

@ProviderFor(kernelProfileContent)
const kernelProfileContentProvider = KernelProfileContentFamily._();

/// 单份 profile 的原始 HOCON 文本。

final class KernelProfileContentProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 单份 profile 的原始 HOCON 文本。
  const KernelProfileContentProvider._({
    required KernelProfileContentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'kernelProfileContentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$kernelProfileContentHash();

  @override
  String toString() {
    return r'kernelProfileContentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return kernelProfileContent(ref, release: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is KernelProfileContentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$kernelProfileContentHash() =>
    r'36c8bb0bef4a2df19b1e2c42ca6cba55d51a3988';

/// 单份 profile 的原始 HOCON 文本。

final class KernelProfileContentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  const KernelProfileContentFamily._()
    : super(
        retry: null,
        name: r'kernelProfileContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 单份 profile 的原始 HOCON 文本。

  KernelProfileContentProvider call({required String release}) =>
      KernelProfileContentProvider._(argument: release, from: this);

  @override
  String toString() => r'kernelProfileContentProvider';
}
