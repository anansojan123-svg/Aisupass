import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe_progress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_probe_progress_dto.freezed.dart';
part 'ghost_lock_probe_progress_dto.g.dart';

/// 解析进度快照的 DTO。
///
/// 原生只回 `"<phase> <done> <total>"` 三元组串，解析在 [fromNative]。
@freezed
abstract class GhostLockProbeProgressDto with _$GhostLockProbeProgressDto {
  const GhostLockProbeProgressDto._();

  const factory GhostLockProbeProgressDto({
    @Default(0) int phase,
    @Default(0) int done,
    @Default(0) int total,
  }) = _GhostLockProbeProgressDto;

  factory GhostLockProbeProgressDto.fromJson(Map<String, dynamic> json) =>
      _$GhostLockProbeProgressDtoFromJson(json);

  /// 解析原生返回的三元组串。
  ///
  /// 字段缺失、非数字、负数一律当 `0`：进度丢一帧不影响功能。
  factory GhostLockProbeProgressDto.fromNative(String raw) {
    final List<String> parts = raw.trim().split(' ');
    int at(int index) {
      if (index >= parts.length) return 0;
      final int? value = int.tryParse(parts[index]);
      return value == null || value < 0 ? 0 : value;
    }

    return GhostLockProbeProgressDto(
      phase: at(0),
      done: at(1),
      total: at(2),
    );
  }

  /// 转成领域实体。
  GhostLockProbeProgress toEntity() => GhostLockProbeProgress(
    phase: phase,
    done: done,
    total: total,
  );
}
