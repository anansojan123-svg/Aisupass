import 'package:Aisupass/features/escalation/domain/models/ghost_lock_import_result.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_import_result_dto.freezed.dart';
part 'ghost_lock_import_result_dto.g.dart';

/// 一次导入的结果。
///
/// 字段与 `pigeon.GhostLockImportResult` 一一对应。
@freezed
abstract class GhostLockImportResultDto with _$GhostLockImportResultDto {
  const GhostLockImportResultDto._();

  const factory GhostLockImportResultDto({
    @Default(false) bool ok,
    @Default('') String release,
    @Default('') String fileName,
    @Default('') String reason,
    @Default(false) bool requiresOverwrite,
  }) = _GhostLockImportResultDto;

  factory GhostLockImportResultDto.fromJson(Map<String, dynamic> json) =>
      _$GhostLockImportResultDtoFromJson(json);

  /// 原生快照 → DTO。
  factory GhostLockImportResultDto.fromNative(
    pigeon.GhostLockImportResult result,
  ) => GhostLockImportResultDto(
    ok: result.ok,
    release: result.release,
    fileName: result.fileName,
    reason: result.reason,
    requiresOverwrite: result.requiresOverwrite,
  );

  /// 转成领域实体。
  GhostLockImportResult toEntity() => GhostLockImportResult(
    ok: ok,
    release: release,
    fileName: fileName,
    reason: reason,
    requiresOverwrite: requiresOverwrite,
  );
}
