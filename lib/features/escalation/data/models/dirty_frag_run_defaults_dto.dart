import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/generated/dirty_frag.g.dart' as pigeon;

part 'dirty_frag_run_defaults_dto.freezed.dart';
part 'dirty_frag_run_defaults_dto.g.dart';

/// 运行默认值的 DTO，与 `pigeon.DirtyFragRunDefaults` 字段一一对应。
@freezed
abstract class DirtyFragRunDefaultsDto with _$DirtyFragRunDefaultsDto {
  const DirtyFragRunDefaultsDto._();

  const factory DirtyFragRunDefaultsDto({
    @Default(false) bool vrDisarm,
    @Default(true) bool vrAuto,
    @Default(0) int vrOffset,
    @Default(false) bool softReboot,
  }) = _DirtyFragRunDefaultsDto;

  factory DirtyFragRunDefaultsDto.fromJson(Map<String, dynamic> json) =>
      _$DirtyFragRunDefaultsDtoFromJson(json);

  /// 原生 `DirtyFragRunDefaults` -> 本 DTO：纯字段搬运。
  factory DirtyFragRunDefaultsDto.fromNative(pigeon.DirtyFragRunDefaults raw) =>
      DirtyFragRunDefaultsDto(
        vrDisarm: raw.vrDisarm,
        vrAuto: raw.vrAuto,
        vrOffset: raw.vrOffset,
        softReboot: raw.softReboot,
      );

  /// 转成领域实体。
  DirtyFragRunDefaults toEntity() => DirtyFragRunDefaults(
    vrDisarm: vrDisarm,
    vrAuto: vrAuto,
    vrOffset: vrOffset,
    softReboot: softReboot,
  );
}
