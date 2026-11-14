import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/domain/models/device_identity.dart';
import 'package:Aisupass/generated/device_identity.g.dart' as pigeon;

part 'device_identity_dto.freezed.dart';
part 'device_identity_dto.g.dart';

/// 设备身份 DTO，承接 Pigeon 回传的原始取值。
@freezed
abstract class DeviceIdentityDto with _$DeviceIdentityDto {
  const DeviceIdentityDto._();

  const factory DeviceIdentityDto({
    @Default('') String identityText,
    @Default('') String kernelRelease,
    @Default('') String kernelVersion,
    @Default('') String kernelCommit,
    @Default('') String manufacturer,
    @Default('') String model,
    @Default(0) int pageSize,
  }) = _DeviceIdentityDto;

  factory DeviceIdentityDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceIdentityDtoFromJson(json);

  /// 原生 `DeviceIdentity` -> 本 DTO：纯字段搬运。
  factory DeviceIdentityDto.fromNative(pigeon.DeviceIdentity raw) =>
      DeviceIdentityDto(
        identityText: raw.identityText,
        kernelRelease: raw.kernelRelease,
        kernelVersion: raw.kernelVersion,
        kernelCommit: raw.kernelCommit,
        manufacturer: raw.manufacturer,
        model: raw.model,
        pageSize: raw.pageSize,
      );

  /// 转成领域实体。
  DeviceIdentity toEntity() => DeviceIdentity(
    identityText: identityText,
    kernelRelease: kernelRelease,
    kernelVersion: kernelVersion,
    kernelCommit: kernelCommit,
    manufacturer: manufacturer,
    model: model,
    pageSize: pageSize,
  );
}
