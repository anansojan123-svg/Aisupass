import 'package:Aisupass/features/escalation/domain/enums/ota_catalog_brand.dart';
import 'package:Aisupass/features/escalation/domain/models/ota_package.dart';

/// 内置 OTA 清单只读仓储接口。
abstract class OtaCatalogQueryRepository {
  /// 读取指定厂商的内置清单。
  Future<List<OtaPackage>> list({required OtaCatalogBrand brand});
}
