import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:Aisupass/features/escalation/data/datasources/ota_catalog_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/ota_catalog_query_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/enums/ota_catalog_brand.dart';
import 'package:Aisupass/features/escalation/domain/models/ota_package.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ota_catalog_query_repository.dart';

part 'ota_catalog_query_provider.g.dart';

/// 内置 OTA 清单数据源。
@riverpod
OtaCatalogQueryDatasource otaCatalogQueryDatasource(Ref ref) =>
    OtaCatalogQueryDatasource(bundle: rootBundle);

/// 内置 OTA 清单仓储。
@riverpod
OtaCatalogQueryRepository otaCatalogQueryRepository(Ref ref) =>
    OtaCatalogQueryRepositoryImpl(
      datasource: ref.watch(otaCatalogQueryDatasourceProvider),
    );

/// 指定厂商的内置 OTA 列表。
///
/// Pixel 清单有 2000+ 条、JSON 600KB，解析一次就常驻，避免每次开弹窗重解析。
@Riverpod(keepAlive: true)
Future<List<OtaPackage>> otaCatalogList(
  Ref ref, {
  required OtaCatalogBrand brand,
}) => ref.watch(otaCatalogQueryRepositoryProvider).list(brand: brand);
