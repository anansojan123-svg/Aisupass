import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_user_profile.freezed.dart';

/// 一份用户导入的 GhostLock profile。
@freezed
abstract class GhostLockUserProfile with _$GhostLockUserProfile {
  const GhostLockUserProfile._();

  const factory GhostLockUserProfile({
    /// 文件名，唯一标识。
    required String name,

    /// 文档里声明的内核 release；解析失败为空串。
    required String release,

    /// 文件字节数。
    required int sizeBytes,

    /// 导入时间（毫秒时间戳）。
    required int importedAtMs,

    /// 文本无法解析出 release。
    required bool parseError,
  }) = _GhostLockUserProfile;
}
