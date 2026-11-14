import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/domain/models/ghost_key_preflight.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

part 'ghost_key_preflight_dto.freezed.dart';
part 'ghost_key_preflight_dto.g.dart';

/// [GhostKeyPreflight] 的传输形态，字段与 `pigeon.Cve98260Preflight` 一一对应。
@freezed
abstract class GhostKeyPreflightDto with _$GhostKeyPreflightDto {
  const GhostKeyPreflightDto._();

  const factory GhostKeyPreflightDto({
    @Default(false) bool adbConnected,
    @Default(-1) int shellUid,
    @Default(-1) int seccomp,
    @Default('') String release,
    @Default(false) bool profileMatched,
    @Default(false) bool binaryPresent,
  }) = _GhostKeyPreflightDto;

  factory GhostKeyPreflightDto.fromJson(Map<String, dynamic> json) =>
      _$GhostKeyPreflightDtoFromJson(json);

  /// 原生 `Cve98260Preflight` -> 本 DTO：纯字段搬运。
  factory GhostKeyPreflightDto.fromNative(pigeon.Cve98260Preflight native) =>
      GhostKeyPreflightDto(
        adbConnected: native.adbConnected,
        shellUid: native.shellUid,
        seccomp: native.seccomp,
        release: native.release,
        profileMatched: native.profileMatched,
        binaryPresent: native.binaryPresent,
      );

  GhostKeyPreflight toEntity() => GhostKeyPreflight(
    adbConnected: adbConnected,
    shellUid: shellUid,
    seccomp: seccomp,
    release: release,
    profileMatched: profileMatched,
    binaryPresent: binaryPresent,
  );
}
