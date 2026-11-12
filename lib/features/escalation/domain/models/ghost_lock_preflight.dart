import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_lock_preflight.freezed.dart';

/// 运行前自检快照。
///
/// 全部字段来自原生；Dart 侧不重新推导任何一项。
@freezed
abstract class GhostLockPreflight with _$GhostLockPreflight {
  const GhostLockPreflight._();

  const factory GhostLockPreflight({
    /// wire-ADB 是否已连接。
    required bool adbConnected,

    /// shell 身份；`2000` 可用，`-1` 表示没取到。
    required int shellUid,

    /// `/proc/$$/status` 的 `Seccomp`；`-1` 表示没取到。
    required int seccomp,

    /// 设备 `uname -r` 全串；取不到为空串。
    required String release,

    /// 命中的 profile release；未命中为空串。
    required String profileRelease,

    /// 命中的路由 token；未命中为空串。
    required String route,

    /// `nativeLibraryDir/libghostlock.so` 是否存在。
    required bool binaryPresent,

    /// 将传给 `GHOSTLOCK_KSUD` 的路径；空串表示没有可用 ksud。
    required String ksudPath,

    /// profile 编码失败的原因码；成功为空串。
    required String profileError,
  }) = _GhostLockPreflight;

  /// 内核表是否命中。
  bool get profileMatched => profileRelease.isNotEmpty;
}
