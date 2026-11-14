import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/domain/models/ghost_lock_execution_field.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;

part 'ghost_lock_execution_field_dto.freezed.dart';
part 'ghost_lock_execution_field_dto.g.dart';

/// 原生快照：通用参数页的一行。
@freezed
abstract class GhostLockExecutionFieldDto with _$GhostLockExecutionFieldDto {
  const GhostLockExecutionFieldDto._();

  const factory GhostLockExecutionFieldDto({
    @Default('') String path,
    @Default(0) int value,
    @Default(false) bool overridden,
  }) = _GhostLockExecutionFieldDto;

  factory GhostLockExecutionFieldDto.fromJson(Map<String, dynamic> json) =>
      _$GhostLockExecutionFieldDtoFromJson(json);

  /// 原生 `GhostLockExecutionField` -> 本 DTO：纯字段搬运。
  factory GhostLockExecutionFieldDto.fromNative(
    pigeon.GhostLockExecutionField field,
  ) => GhostLockExecutionFieldDto(
    path: field.path,
    value: field.value,
    overridden: field.overridden,
  );

  /// 转成领域实体。
  GhostLockExecutionField toEntity() =>
      GhostLockExecutionField(path: path, value: value, overridden: overridden);
}
