import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_execution_field.freezed.dart';

/// 通用参数页的一行（execution tuning）。
@freezed
abstract class GhostLockExecutionField with _$GhostLockExecutionField {
  const GhostLockExecutionField._();

  const factory GhostLockExecutionField({
    /// 完整点分路径，如 `execution.race.route_wait_ms`。
    required String path,

    /// 当前值。
    required int value,

    /// 该字段是否被本地 override。
    required bool overridden,
  }) = _GhostLockExecutionField;
}
