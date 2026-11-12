import 'package:Aisupass/features/escalation/domain/models/ghost_lock_execution_field.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_field_node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_profile_config.freezed.dart';

/// 一次 profile 解析结果（编辑器视图）。
@freezed
abstract class GhostLockProfileConfig with _$GhostLockProfileConfig {
  const GhostLockProfileConfig._();

  const factory GhostLockProfileConfig({
    /// 设备内核 release。
    required String release,

    /// 是否解析到可用 profile。
    required bool hasProfile,

    /// 高级字段树。
    required List<GhostLockProfileFieldNode> roots,

    /// 通用参数。
    required List<GhostLockExecutionField> general,

    /// 当前 route；空串表示未声明。
    required String route,

    /// fallback 目标；空串表示未声明，`none` 表示显式关闭。
    required String fallbackTo,

    /// 违规字段路径；UI 标红。
    required List<String> invalidPaths,

    /// 内置表里的全部 release，升序；供「指定生效表」的下拉使用。
    required List<String> builtinReleases,
  }) = _GhostLockProfileConfig;
}
