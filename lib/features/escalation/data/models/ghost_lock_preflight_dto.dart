import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;

part 'ghost_lock_preflight_dto.freezed.dart';
part 'ghost_lock_preflight_dto.g.dart';

/// 自检快照的 DTO，与 `pigeon.GhostLockPreflight` 字段一一对应。
@freezed
abstract class GhostLockPreflightDto with _$GhostLockPreflightDto {
  const GhostLockPreflightDto._();

  const factory GhostLockPreflightDto({
    @Default(false) bool adbConnected,
    @Default(-1) int shellUid,
    @Default(-1) int seccomp,
    @Default('') String release,
    @Default('') String profileRelease,
    @Default('') String route,
    @Default(false) bool binaryPresent,
    @Default('') String ksudPath,
    @Default('') String profileError,
  }) = _GhostLockPreflightDto;

  factory GhostLockPreflightDto.fromJson(Map<String, dynamic> json) =>
      _$GhostLockPreflightDtoFromJson(json);

  /// 原生 `GhostLockPreflight` -> 本 DTO：纯字段搬运。
  factory GhostLockPreflightDto.fromNative(pigeon.GhostLockPreflight native) =>
      GhostLockPreflightDto(
        adbConnected: native.adbConnected,
        shellUid: native.shellUid,
        seccomp: native.seccomp,
        release: native.release,
        profileRelease: native.profileRelease,
        route: native.route,
        binaryPresent: native.binaryPresent,
        ksudPath: native.ksudPath,
        profileError: native.profileError,
      );

  /// 转成领域实体。
  GhostLockPreflight toEntity() => GhostLockPreflight(
    adbConnected: adbConnected,
    shellUid: shellUid,
    seccomp: seccomp,
    release: release,
    profileRelease: profileRelease,
    route: route,
    binaryPresent: binaryPresent,
    ksudPath: ksudPath,
    profileError: profileError,
  );
}
