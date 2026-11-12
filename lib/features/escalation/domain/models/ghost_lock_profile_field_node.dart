import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_profile_field_node.freezed.dart';

/// profile 树的一个节点：分组或叶子。
@freezed
abstract class GhostLockProfileFieldNode with _$GhostLockProfileFieldNode {
  const GhostLockProfileFieldNode._();

  const factory GhostLockProfileFieldNode({
    /// 完整点分路径，如 `task_struct.cred`。
    required String path,

    /// 末段键名，用于显示。
    required String name,

    /// 当前值；[provided] 为 false 时这个 0 不代表真实值。
    required int value,

    /// 该字段在 profile 里是否提供了值。
    required bool provided,

    /// 该字段或任一子孙是否被 override。
    required bool overridden,

    /// 子节点；叶子为空列表。
    required List<GhostLockProfileFieldNode> children,
  }) = _GhostLockProfileFieldNode;

  /// 是否分组节点。
  bool get isGroup => children.isNotEmpty;
}
