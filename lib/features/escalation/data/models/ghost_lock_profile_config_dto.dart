import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/data/models/ghost_lock_execution_field_dto.dart';
import 'package:Aisupass/features/escalation/data/models/ghost_lock_profile_field_node_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;

part 'ghost_lock_profile_config_dto.freezed.dart';
part 'ghost_lock_profile_config_dto.g.dart';

/// 原生快照：一次 profile 解析结果。
@freezed
abstract class GhostLockProfileConfigDto with _$GhostLockProfileConfigDto {
  const GhostLockProfileConfigDto._();

  const factory GhostLockProfileConfigDto({
    @Default('') String release,
    @Default(false) bool hasProfile,
    @Default(<GhostLockProfileFieldNodeDto>[])
    List<GhostLockProfileFieldNodeDto> roots,
    @Default(<GhostLockExecutionFieldDto>[])
    List<GhostLockExecutionFieldDto> general,
    @Default('') String route,
    @Default('') String fallbackTo,
    @Default(<String>[]) List<String> invalidPaths,
    @Default(<String>[]) List<String> builtinReleases,
  }) = _GhostLockProfileConfigDto;

  factory GhostLockProfileConfigDto.fromJson(Map<String, dynamic> json) =>
      _$GhostLockProfileConfigDtoFromJson(json);

  /// 原生 `GhostLockProfileConfig` -> 本 DTO：字段搬运 + 子节点逐个转换。
  factory GhostLockProfileConfigDto.fromNative(
    pigeon.GhostLockProfileConfig config,
  ) => GhostLockProfileConfigDto(
    release: config.release,
    hasProfile: config.hasProfile,
    roots: config.roots
        .map(GhostLockProfileFieldNodeDto.fromNative)
        .toList(growable: false),
    general: config.general
        .map(GhostLockExecutionFieldDto.fromNative)
        .toList(growable: false),
    route: config.route,
    fallbackTo: config.fallbackTo,
    invalidPaths: config.invalidPaths,
    builtinReleases: config.builtinReleases,
  );

  /// 转成领域实体；`roots` 由先序扁平序列还原成树。
  GhostLockProfileConfig toEntity() => GhostLockProfileConfig(
    release: release,
    hasProfile: hasProfile,
    roots: GhostLockProfileFieldNodeDto.treeFrom(roots),
    general: general.map((field) => field.toEntity()).toList(),
    route: route,
    fallbackTo: fallbackTo,
    invalidPaths: invalidPaths,
    builtinReleases: builtinReleases,
  );
}
