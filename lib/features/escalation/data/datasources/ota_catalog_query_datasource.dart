import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:Aisupass/features/escalation/domain/enums/ota_catalog_brand.dart';

/// 内置历史 OTA 清单数据源：清单随包发布，只从 assets 读取。
class OtaCatalogQueryDatasource {
  const OtaCatalogQueryDatasource({required this._bundle});

  final AssetBundle _bundle;

  /// 厂商对应的清单路径。资源布局属于数据层细节，不下沉到 domain。
  static String _assetOf(OtaCatalogBrand brand) => switch (brand) {
    OtaCatalogBrand.google => 'assets/escalation/ota/pixel.json',
    OtaCatalogBrand.realme => 'assets/escalation/ota/realme.json',
  };

  /// 读取 `{"items": [...]}` 结构的清单，返回未收敛的原始条目。
  Future<List<Map<String, dynamic>>> loadItems({
    required OtaCatalogBrand brand,
  }) async {
    final String raw = await _bundle.loadString(_assetOf(brand));
    final Object? decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return const <Map<String, dynamic>>[];
    final Object? items = decoded['items'];
    if (items is! List) return const <Map<String, dynamic>>[];
    return items.whereType<Map<String, dynamic>>().toList(growable: false);
  }
}
