import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_key_preflight.freezed.dart';

/// 运行前自检快照。
///
/// 只承载证据，不做结论：为什么不能跑由 UI 按这几个字段翻译成 l10n 文案。
@freezed
abstract class GhostKeyPreflight with _$GhostKeyPreflight {
  const GhostKeyPreflight._();

  const factory GhostKeyPreflight({
    /// ADB 连接是否活着。
    required bool adbConnected,

    /// shell 身份 uid：`2000` = shell，`0` = root，`-1` = 取不到。
    required int shellUid,

    /// `/proc/$$/status` 的 `Seccomp` 字段：`0` = 无过滤器，`-1` = 取不到。
    required int seccomp,

    /// 设备内核 release（`uname -r` 原样）；空串表示取不到。
    required String release,

    /// 该 release 是否命中内置 profile 表。
    required bool profileMatched,

    /// `nativeLibraryDir/libcve98260.so` 是否存在。
    required bool binaryPresent,
  }) = _GhostKeyPreflight;

  /// 当前身份是否 shell。
  bool get isShell => shellUid == 2000;

  /// 当前身份是否已经是 root。
  bool get isRoot => shellUid == 0;

  /// 是否没有 seccomp 过滤器（`0` 是硬条件）。
  bool get seccompClean => seccomp == 0;
}
