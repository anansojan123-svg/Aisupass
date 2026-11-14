import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_field_node.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;

part 'ghost_lock_profile_field_node_dto.freezed.dart';
part 'ghost_lock_profile_field_node_dto.g.dart';

/// 原生快照：profile 树的一个节点（先序扁平，层级由 `depth` 表达）。
@freezed
abstract class GhostLockProfileFieldNodeDto
    with _$GhostLockProfileFieldNodeDto {
  const GhostLockProfileFieldNodeDto._();

  const factory GhostLockProfileFieldNodeDto({
    @Default('') String path,
    @Default('') String name,
    @Default(0) int depth,
    @Default(0) int value,
    @Default(false) bool provided,
    @Default(false) bool overridden,
  }) = _GhostLockProfileFieldNodeDto;

  factory GhostLockProfileFieldNodeDto.fromJson(Map<String, dynamic> json) =>
      _$GhostLockProfileFieldNodeDtoFromJson(json);

  /// 原生 `GhostLockFieldNode` -> 本 DTO：纯字段搬运。
  factory GhostLockProfileFieldNodeDto.fromNative(
    pigeon.GhostLockFieldNode node,
  ) => GhostLockProfileFieldNodeDto(
    path: node.path,
    name: node.name,
    depth: node.depth,
    value: node.value,
    provided: node.provided,
    overridden: node.overridden,
  );

  /// 先序扁平序列 → 领域树。
  ///
  /// 这是本 DTO 的实体转换点：节点自身没有 `children`，只能整棵一起还原，
  /// 因此不提供单节点的 `toEntity()`。原生侧是逐层 DFS 产出，`depth` 与当前
  /// 层不符即结束本层，不会出现跨层跳跃。
  static List<GhostLockProfileFieldNode> treeFrom(
    List<GhostLockProfileFieldNodeDto> flat,
  ) {
    int index = 0;

    List<GhostLockProfileFieldNode> build(int depth) {
      final List<GhostLockProfileFieldNode> level =
          <GhostLockProfileFieldNode>[];
      while (index < flat.length) {
        final GhostLockProfileFieldNodeDto node = flat[index];
        if (node.depth != depth) break;
        index++;
        level.add(
          GhostLockProfileFieldNode(
            path: node.path,
            name: node.name,
            value: node.value,
            provided: node.provided,
            overridden: node.overridden,
            children: build(depth + 1),
          ),
        );
      }
      return level;
    }

    return build(0);
  }
}
