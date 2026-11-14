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

/// 已导入的 profile 列表（最近修改优先）。

@ProviderFor(kernelProfileList)
const kernelProfileListProvider = KernelProfileListProvider._();

/// 已导入的 profile 列表（最近修改优先）。

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
  /// 已导入的 profile 列表（最近修改优先）。
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

/// 当前生效的用户文档名；未选择返回空串。

@ProviderFor(kernelProfileActiveName)
const kernelProfileActiveNameProvider = KernelProfileActiveNameProvider._();

/// 当前生效的用户文档名；未选择返回空串。

final class KernelProfileActiveNameProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 当前生效的用户文档名；未选择返回空串。
  const KernelProfileActiveNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kernelProfileActiveNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kernelProfileActiveNameHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return kernelProfileActiveName(ref);
  }
}

String _$kernelProfileActiveNameHash() =>
    r'304f90f76c0be8e69e02501cf340cb7af7a2047d';

/// 单份 profile 的原始 HOCON 文本；`name` 为空时按 `release` 读内置表。

@ProviderFor(kernelProfileContent)
const kernelProfileContentProvider = KernelProfileContentFamily._();

/// 单份 profile 的原始 HOCON 文本；`name` 为空时按 `release` 读内置表。

final class KernelProfileContentProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 单份 profile 的原始 HOCON 文本；`name` 为空时按 `release` 读内置表。
  const KernelProfileContentProvider._({
    required KernelProfileContentFamily super.from,
    required ({String name, String release}) super.argument,
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
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as ({String name, String release});
    return kernelProfileContent(
      ref,
      name: argument.name,
      release: argument.release,
    );
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
    r'22cdea87517227a9ae05e788fa62512be7266735';

/// 单份 profile 的原始 HOCON 文本；`name` 为空时按 `release` 读内置表。

final class KernelProfileContentFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String>,
          ({String name, String release})
        > {
  const KernelProfileContentFamily._()
    : super(
        retry: null,
        name: r'kernelProfileContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 单份 profile 的原始 HOCON 文本；`name` 为空时按 `release` 读内置表。

  KernelProfileContentProvider call({
    required String name,
    required String release,
  }) => KernelProfileContentProvider._(
    argument: (name: name, release: release),
    from: this,
  );

  @override
  String toString() => r'kernelProfileContentProvider';
}

/// 单份用户文档的可编辑字段。

@ProviderFor(kernelProfileEditor)
const kernelProfileEditorProvider = KernelProfileEditorFamily._();

/// 单份用户文档的可编辑字段。

final class KernelProfileEditorProvider
    extends
        $FunctionalProvider<
          AsyncValue<KernelProfileEditorState>,
          KernelProfileEditorState,
          FutureOr<KernelProfileEditorState>
        >
    with
        $FutureModifier<KernelProfileEditorState>,
        $FutureProvider<KernelProfileEditorState> {
  /// 单份用户文档的可编辑字段。
  const KernelProfileEditorProvider._({
    required KernelProfileEditorFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'kernelProfileEditorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$kernelProfileEditorHash();

  @override
  String toString() {
    return r'kernelProfileEditorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<KernelProfileEditorState> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<KernelProfileEditorState> create(Ref ref) {
    final argument = this.argument as String;
    return kernelProfileEditor(ref, name: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is KernelProfileEditorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$kernelProfileEditorHash() =>
    r'206bc014b708ef705c59d7140d7c534bd96586f7';

/// 单份用户文档的可编辑字段。

final class KernelProfileEditorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<KernelProfileEditorState>, String> {
  const KernelProfileEditorFamily._()
    : super(
        retry: null,
        name: r'kernelProfileEditorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 单份用户文档的可编辑字段。

  KernelProfileEditorProvider call({required String name}) =>
      KernelProfileEditorProvider._(argument: name, from: this);

  @override
  String toString() => r'kernelProfileEditorProvider';
}
