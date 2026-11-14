import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Aisupass/features/chat/domain/models/chat_tool.dart';
import 'package:Aisupass/features/chat/presentation/providers/tools/tool_schema.dart';
import 'package:Aisupass/features/escalation/domain/enums/ota_catalog_brand.dart';
import 'package:Aisupass/features/escalation/domain/models/ota_package.dart';
import 'package:Aisupass/features/escalation/presentation/providers/ota_catalog_query_provider.dart';

/// 内置 OTA 清单只读工具。
List<ChatToolDefinition> otaTools(Ref ref) => <ChatToolDefinition>[
  ChatToolDefinition(
    name: 'ota_list_catalog',
    description:
        'List built-in OTA packages for a vendor catalog. Use the package URL '
        'with the Kernel profile import-from-URL capability.',
    parameters: objectSchema(
      properties: <String, dynamic>{
        'brand': stringProperty(
          description: 'Vendor catalog.',
          allowedValues: <String>[
            for (final OtaCatalogBrand brand in OtaCatalogBrand.values)
              brand.name,
          ],
        ),
      },
      required: <String>['brand'],
    ),
    execute: (Map<String, dynamic> arguments) async {
      final OtaCatalogBrand brand = enumArg(
        arguments,
        'brand',
        OtaCatalogBrand.values,
      );
      final List<OtaPackage> packages = await ref.read(
        otaCatalogListProvider(brand: brand).future,
      );
      return jsonEncode(<String, Object?>{
        'brand': brand.name,
        'total': packages.length,
        'items': <Map<String, Object?>>[
          for (final OtaPackage package in packages)
            <String, Object?>{
              'device': package.device,
              'model': package.model,
              'version': package.version,
              'build': package.build,
              'url': package.url,
            },
        ],
      });
    },
  ),
];
