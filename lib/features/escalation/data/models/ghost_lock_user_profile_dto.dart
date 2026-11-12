import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_user_profile_dto.freezed.dart';
part 'ghost_lock_user_profile_dto.g.dart';

/// 原生快照：一份用户导入的 profile。
///
/// 字段与 `pigeon.GhostLockUserProfile` 一一对应。
@freezed
abstract class GhostLockUserProfileDto with _$GhostLockUserProfileDto {
  const GhostLockUserProfileDto._();

  const factory GhostLockUserProfileDto({
    @Default('') String name,
    @Default('') String release,
    @Default(0) int sizeBytes,
    @Default(0) int importedAtMs,
    @Default(false) bool parseError,
  }) = _GhostLockUserProfileDto;

  factory GhostLockUserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$GhostLockUserProfileDtoFromJson(json);

  /// 原生快照 → DTO。
  factory GhostLockUserProfileDto.fromNative(pigeon.GhostLockUserProfile profile) =>
      GhostLockUserProfileDto(
        name: profile.name,
        release: profile.release,
        sizeBytes: profile.sizeBytes,
        importedAtMs: profile.importedAtMs,
        parseError: profile.parseError,
      );

  /// 转成领域实体。
  GhostLockUserProfile toEntity() => GhostLockUserProfile(
    name: name,
    release: release,
    sizeBytes: sizeBytes,
    importedAtMs: importedAtMs,
    parseError: parseError,
  );
}
