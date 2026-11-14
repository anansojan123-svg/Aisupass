// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kernel_profile_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 用户 profile 动作数据源。

@ProviderFor(kernelProfileActionDatasource)
const kernelProfileActionDatasourceProvider =
    KernelProfileActionDatasourceProvider._();

/// 用户 profile 动作数据源。

final class KernelProfileActionDatasourceProvider
    extends
        $FunctionalProvider<
          KernelProfileActionDatasource,
          KernelProfileActionDatasource,
          KernelProfileActionDatasource
        >
    with $Provider<KernelProfileActionDatasource> {
  /// 用户 profile 动作数据源。
  const KernelProfileActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kernelProfileActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kernelProfileActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<KernelProfileActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KernelProfileActionDatasource create(Ref ref) {
    return kernelProfileActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KernelProfileActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KernelProfileActionDatasource>(
        value,
      ),
    );
  }
}

String _$kernelProfileActionDatasourceHash() =>
    r'1271d73aab219a8d87ad6b224faee66c4ddf7f26';

/// 用户 profile 动作仓储。

@ProviderFor(kernelProfileActionRepository)
const kernelProfileActionRepositoryProvider =
    KernelProfileActionRepositoryProvider._();

/// 用户 profile 动作仓储。

final class KernelProfileActionRepositoryProvider
    extends
        $FunctionalProvider<
          KernelProfileActionRepository,
          KernelProfileActionRepository,
          KernelProfileActionRepository
        >
    with $Provider<KernelProfileActionRepository> {
  /// 用户 profile 动作仓储。
  const KernelProfileActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kernelProfileActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kernelProfileActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<KernelProfileActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KernelProfileActionRepository create(Ref ref) {
    return kernelProfileActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KernelProfileActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KernelProfileActionRepository>(
        value,
      ),
    );
  }
}

String _$kernelProfileActionRepositoryHash() =>
    r'7523f7b562f697dada75677dc693ad04380bac4e';

/// 从 boot.img 导入一份 profile，按进度块吐出。

@ProviderFor(importKernelProfile)
const importKernelProfileProvider = ImportKernelProfileFamily._();

/// 从 boot.img 导入一份 profile，按进度块吐出。

final class ImportKernelProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<KernelProfileImportState>,
          KernelProfileImportState,
          Stream<KernelProfileImportState>
        >
    with
        $FutureModifier<KernelProfileImportState>,
        $StreamProvider<KernelProfileImportState> {
  /// 从 boot.img 导入一份 profile，按进度块吐出。
  const ImportKernelProfileProvider._({
    required ImportKernelProfileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'importKernelProfileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$importKernelProfileHash();

  @override
  String toString() {
    return r'importKernelProfileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<KernelProfileImportState> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<KernelProfileImportState> create(Ref ref) {
    final argument = this.argument as String;
    return importKernelProfile(ref, path: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ImportKernelProfileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$importKernelProfileHash() =>
    r'c4926e688391cf27837acb08ba8d6b84542cf352';

/// 从 boot.img 导入一份 profile，按进度块吐出。

final class ImportKernelProfileFamily extends $Family
    with $FunctionalFamilyOverride<Stream<KernelProfileImportState>, String> {
  const ImportKernelProfileFamily._()
    : super(
        retry: null,
        name: r'importKernelProfileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 从 boot.img 导入一份 profile，按进度块吐出。

  ImportKernelProfileProvider call({required String path}) =>
      ImportKernelProfileProvider._(argument: path, from: this);

  @override
  String toString() => r'importKernelProfileProvider';
}

/// 从 OTA 链接导入一份 profile，按进度块吐出。

@ProviderFor(importKernelProfileFromUrl)
const importKernelProfileFromUrlProvider = ImportKernelProfileFromUrlFamily._();

/// 从 OTA 链接导入一份 profile，按进度块吐出。

final class ImportKernelProfileFromUrlProvider
    extends
        $FunctionalProvider<
          AsyncValue<KernelProfileImportState>,
          KernelProfileImportState,
          Stream<KernelProfileImportState>
        >
    with
        $FutureModifier<KernelProfileImportState>,
        $StreamProvider<KernelProfileImportState> {
  /// 从 OTA 链接导入一份 profile，按进度块吐出。
  const ImportKernelProfileFromUrlProvider._({
    required ImportKernelProfileFromUrlFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'importKernelProfileFromUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$importKernelProfileFromUrlHash();

  @override
  String toString() {
    return r'importKernelProfileFromUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<KernelProfileImportState> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<KernelProfileImportState> create(Ref ref) {
    final argument = this.argument as String;
    return importKernelProfileFromUrl(ref, url: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ImportKernelProfileFromUrlProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$importKernelProfileFromUrlHash() =>
    r'b1c7bb91b26e2c0143aead7fe2e125e868ad174e';

/// 从 OTA 链接导入一份 profile，按进度块吐出。

final class ImportKernelProfileFromUrlFamily extends $Family
    with $FunctionalFamilyOverride<Stream<KernelProfileImportState>, String> {
  const ImportKernelProfileFromUrlFamily._()
    : super(
        retry: null,
        name: r'importKernelProfileFromUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 从 OTA 链接导入一份 profile，按进度块吐出。

  ImportKernelProfileFromUrlProvider call({required String url}) =>
      ImportKernelProfileFromUrlProvider._(argument: url, from: this);

  @override
  String toString() => r'importKernelProfileFromUrlProvider';
}

/// 用户 profile 的写操作。
///
/// 无参 `keepAlive` 类，参数走方法入参：带参族函数会按参数缓存。

@ProviderFor(kernelProfileActions)
const kernelProfileActionsProvider = KernelProfileActionsProvider._();

/// 用户 profile 的写操作。
///
/// 无参 `keepAlive` 类，参数走方法入参：带参族函数会按参数缓存。

final class KernelProfileActionsProvider
    extends
        $FunctionalProvider<
          KernelProfileActions,
          KernelProfileActions,
          KernelProfileActions
        >
    with $Provider<KernelProfileActions> {
  /// 用户 profile 的写操作。
  ///
  /// 无参 `keepAlive` 类，参数走方法入参：带参族函数会按参数缓存。
  const KernelProfileActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kernelProfileActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kernelProfileActionsHash();

  @$internal
  @override
  $ProviderElement<KernelProfileActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KernelProfileActions create(Ref ref) {
    return kernelProfileActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KernelProfileActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KernelProfileActions>(value),
    );
  }
}

String _$kernelProfileActionsHash() =>
    r'0d4b8dc943f594ceb5101ee1222c5a379d7ab4bf';
