import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/domain/models/ota_package.dart';

part 'ota_package_dto.freezed.dart';
part 'ota_package_dto.g.dart';

/// [OtaPackage] 的 JSON 形态，字段与 assets 里的清单一一对应。
@freezed
abstract class OtaPackageDto with _$OtaPackageDto {
  const OtaPackageDto._();

  const factory OtaPackageDto({
    @Default('') String device,
    @Default('') String model,
    @Default('') String version,
    @Default('') String build,
    @Default('') String url,
  }) = _OtaPackageDto;

  factory OtaPackageDto.fromJson(Map<String, dynamic> json) =>
      _$OtaPackageDtoFromJson(json);

  OtaPackage toEntity() => OtaPackage(
    device: device,
    model: model,
    version: version,
    build: build,
    url: url,
  );
}
