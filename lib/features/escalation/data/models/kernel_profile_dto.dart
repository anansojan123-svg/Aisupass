import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

part 'kernel_profile_dto.freezed.dart';
part 'kernel_profile_dto.g.dart';

/// [KernelProfile] 的传输形态，字段与 `pigeon.KernelProfile` 一一对应。
@freezed
abstract class KernelProfileDto with _$KernelProfileDto {
  const KernelProfileDto._();

  const factory KernelProfileDto({
    @Default('') String release,
    @Default('') String detail,
  }) = _KernelProfileDto;

  factory KernelProfileDto.fromJson(Map<String, dynamic> json) =>
      _$KernelProfileDtoFromJson(json);

  factory KernelProfileDto.fromNative(pigeon.KernelProfile native) =>
      KernelProfileDto(release: native.release, detail: native.detail);

  KernelProfile toEntity() =>
      KernelProfile(release: release, detail: detail);
}
