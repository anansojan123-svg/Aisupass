import 'package:freezed_annotation/freezed_annotation.dart';

part 'ota_package.freezed.dart';

/// 内置历史 OTA 清单里的一条包记录。
///
/// [url] 是可直接交给导入链路的包直链；[version] 是厂商展示用的版本串，
/// [build] 是构建号，用于搜索与排序。
@freezed
abstract class OtaPackage with _$OtaPackage {
  const OtaPackage._();

  const factory OtaPackage({
    required String device,
    required String model,
    required String version,
    required String build,
    required String url,
  }) = _OtaPackage;
}
