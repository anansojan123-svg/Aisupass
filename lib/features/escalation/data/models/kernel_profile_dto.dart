import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';

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

  KernelProfile toEntity() => KernelProfile(release: release, detail: detail);
}
