// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ota_catalog_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 内置历史 OTA 清单数据源。

@ProviderFor(otaCatalogQueryDatasource)
const otaCatalogQueryDatasourceProvider = OtaCatalogQueryDatasourceProvider._();

/// 内置历史 OTA 清单数据源。

final class OtaCatalogQueryDatasourceProvider
    extends
        $FunctionalProvider<
          OtaCatalogQueryDatasource,
          OtaCatalogQueryDatasource,
          OtaCatalogQueryDatasource
        >
    with $Provider<OtaCatalogQueryDatasource> {
  /// 内置历史 OTA 清单数据源。
  const OtaCatalogQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otaCatalogQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otaCatalogQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<OtaCatalogQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OtaCatalogQueryDatasource create(Ref ref) {
    return otaCatalogQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OtaCatalogQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OtaCatalogQueryDatasource>(value),
    );
  }
}

String _$otaCatalogQueryDatasourceHash() =>
    r'8694ec2f53bf2de474e94931370584cca988862c';

/// 内置历史 OTA 清单仓储。

@ProviderFor(otaCatalogQueryRepository)
const otaCatalogQueryRepositoryProvider = OtaCatalogQueryRepositoryProvider._();

/// 内置历史 OTA 清单仓储。

final class OtaCatalogQueryRepositoryProvider
    extends
        $FunctionalProvider<
          OtaCatalogQueryRepository,
          OtaCatalogQueryRepository,
          OtaCatalogQueryRepository
        >
    with $Provider<OtaCatalogQueryRepository> {
  /// 内置历史 OTA 清单仓储。
  const OtaCatalogQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otaCatalogQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otaCatalogQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<OtaCatalogQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OtaCatalogQueryRepository create(Ref ref) {
    return otaCatalogQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OtaCatalogQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OtaCatalogQueryRepository>(value),
    );
  }
}

String _$otaCatalogQueryRepositoryHash() =>
    r'64ff416a5a6bd49a9567e3a9812bda223e64e4e3';

/// 指定厂商的历史 OTA 列表。
///
/// Pixel 清单有 2000+ 条、JSON 600KB，解析一次就常驻，避免每次开弹窗重解析。

@ProviderFor(otaCatalogList)
const otaCatalogListProvider = OtaCatalogListFamily._();

/// 指定厂商的历史 OTA 列表。
///
/// Pixel 清单有 2000+ 条、JSON 600KB，解析一次就常驻，避免每次开弹窗重解析。

final class OtaCatalogListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OtaPackage>>,
          List<OtaPackage>,
          FutureOr<List<OtaPackage>>
        >
    with $FutureModifier<List<OtaPackage>>, $FutureProvider<List<OtaPackage>> {
  /// 指定厂商的历史 OTA 列表。
  ///
  /// Pixel 清单有 2000+ 条、JSON 600KB，解析一次就常驻，避免每次开弹窗重解析。
  const OtaCatalogListProvider._({
    required OtaCatalogListFamily super.from,
    required OtaCatalogBrand super.argument,
  }) : super(
         retry: null,
         name: r'otaCatalogListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$otaCatalogListHash();

  @override
  String toString() {
    return r'otaCatalogListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<OtaPackage>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OtaPackage>> create(Ref ref) {
    final argument = this.argument as OtaCatalogBrand;
    return otaCatalogList(ref, brand: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OtaCatalogListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$otaCatalogListHash() => r'662cd81134b084c18e85b9faf90abc4024607069';

/// 指定厂商的历史 OTA 列表。
///
/// Pixel 清单有 2000+ 条、JSON 600KB，解析一次就常驻，避免每次开弹窗重解析。

final class OtaCatalogListFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<OtaPackage>>, OtaCatalogBrand> {
  const OtaCatalogListFamily._()
    : super(
        retry: null,
        name: r'otaCatalogListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// 指定厂商的历史 OTA 列表。
  ///
  /// Pixel 清单有 2000+ 条、JSON 600KB，解析一次就常驻，避免每次开弹窗重解析。

  OtaCatalogListProvider call({required OtaCatalogBrand brand}) =>
      OtaCatalogListProvider._(argument: brand, from: this);

  @override
  String toString() => r'otaCatalogListProvider';
}
