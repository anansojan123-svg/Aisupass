import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_probe_dto.freezed.dart';
part 'ghost_lock_probe_dto.g.dart';

/// [GhostLockProbe] 的传输对象。
@freezed
abstract class GhostLockProbeDto with _$GhostLockProbeDto {
  const GhostLockProbeDto._();

  const factory GhostLockProbeDto({
    @Default(false) bool ok,
    @Default('') String release,
    @Default('') String conf,
    @Default(<String>[]) List<String> warnings,
    @Default('') String bootPath,
    @Default('') String reason,
  }) = _GhostLockProbeDto;

  factory GhostLockProbeDto.fromJson(Map<String, dynamic> json) =>
      _$GhostLockProbeDtoFromJson(json);

  /// 由原生返回结果构造。
  factory GhostLockProbeDto.fromNative(pigeon.GhostLockProbeResult raw) =>
      GhostLockProbeDto(
        ok: raw.ok,
        release: raw.release,
        conf: raw.conf,
        warnings: raw.warnings,
        bootPath: raw.bootPath,
        reason: raw.reason,
      );

  GhostLockProbe toEntity() => GhostLockProbe(
    ok: ok,
    release: release,
    conf: conf,
    warnings: warnings,
    bootPath: bootPath,
    reason: reason,
  );
}
