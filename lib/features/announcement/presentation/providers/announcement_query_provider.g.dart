// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 公告查询数据源。

@ProviderFor(announcementQueryDatasource)
const announcementQueryDatasourceProvider =
    AnnouncementQueryDatasourceProvider._();

/// 公告查询数据源。

final class AnnouncementQueryDatasourceProvider
    extends
        $FunctionalProvider<
          AnnouncementQueryDatasource,
          AnnouncementQueryDatasource,
          AnnouncementQueryDatasource
        >
    with $Provider<AnnouncementQueryDatasource> {
  /// 公告查询数据源。
  const AnnouncementQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<AnnouncementQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnnouncementQueryDatasource create(Ref ref) {
    return announcementQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnnouncementQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnnouncementQueryDatasource>(value),
    );
  }
}

String _$announcementQueryDatasourceHash() =>
    r'07edcde8e3003923cc9bfe834a6643149d3efa0b';

/// 公告查询仓储。

@ProviderFor(announcementQueryRepository)
const announcementQueryRepositoryProvider =
    AnnouncementQueryRepositoryProvider._();

/// 公告查询仓储。

final class AnnouncementQueryRepositoryProvider
    extends
        $FunctionalProvider<
          AnnouncementQueryRepository,
          AnnouncementQueryRepository,
          AnnouncementQueryRepository
        >
    with $Provider<AnnouncementQueryRepository> {
  /// 公告查询仓储。
  const AnnouncementQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnnouncementQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnnouncementQueryRepository create(Ref ref) {
    return announcementQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnnouncementQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnnouncementQueryRepository>(value),
    );
  }
}

String _$announcementQueryRepositoryHash() =>
    r'98ac435fbf4e25d9c00e510ed2c0696b7380e8d2';

/// 服务端当前公告。

@ProviderFor(latestAnnouncement)
const latestAnnouncementProvider = LatestAnnouncementProvider._();

/// 服务端当前公告。

final class LatestAnnouncementProvider
    extends
        $FunctionalProvider<
          AsyncValue<Announcement>,
          Announcement,
          FutureOr<Announcement>
        >
    with $FutureModifier<Announcement>, $FutureProvider<Announcement> {
  /// 服务端当前公告。
  const LatestAnnouncementProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestAnnouncementProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestAnnouncementHash();

  @$internal
  @override
  $FutureProviderElement<Announcement> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Announcement> create(Ref ref) {
    return latestAnnouncement(ref);
  }
}

String _$latestAnnouncementHash() =>
    r'fe546a04d1b53b6a22f24a90f2115ecd068b495e';
