import 'package:Aisupass/features/escalation/data/datasources/ota_catalog_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/ota_package_dto.dart';
import 'package:Aisupass/features/escalation/domain/enums/ota_catalog_brand.dart';
import 'package:Aisupass/features/escalation/domain/models/ota_package.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ota_catalog_query_repository.dart';

/// 内置 OTA 清单仓储实现：JSON → DTO → Entity 的唯一转换点。
class OtaCatalogQueryRepositoryImpl implements OtaCatalogQueryRepository {
  const OtaCatalogQueryRepositoryImpl({required this._datasource});

  final OtaCatalogQueryDatasource _datasource;

  @override
  Future<List<OtaPackage>> list({required OtaCatalogBrand brand}) async {
    final List<Map<String, dynamic>> items = await _datasource.loadItems(
      brand: brand,
    );
    return items
        .map(OtaPackageDto.fromJson)
        .where((OtaPackageDto dto) => dto.url.isNotEmpty)
        .map((OtaPackageDto dto) => dto.toEntity())
        .toList(growable: false);
  }
}
