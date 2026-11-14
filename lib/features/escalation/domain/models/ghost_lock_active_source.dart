import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_active_source.freezed.dart';

/// 当前生效来源：内置层选中的 release 与「我的配置」文档名。
///
/// 空串表示该层跟随设备（内置层）或不使用导入层（用户层）。
@freezed
abstract class GhostLockActiveSource with _$GhostLockActiveSource {
  const GhostLockActiveSource._();

  const factory GhostLockActiveSource({
    required String builtin,
    required String user,
  }) = _GhostLockActiveSource;
}
