/// GhostLock 一次运行的终局分类。
///
/// 分类由 [GhostLockActionRepositoryImpl] 依据原生输出与退出码判定，
/// 原生不回结论。串都逐字取自上游 `src/core/` 的 `pr_*` 调用。
enum GhostLockKind {
  /// 正在运行，尚未拿到终局证据。
  running,

  /// 原生拒绝受理：`alreadyRunning` / `noAdb` / `notShell` /
  /// `seccompFiltered` / `missingBinary` / `noProfile` / `profileInvalid`。
  notStarted,

  /// `KernelSU ready`：内核模块已加载并完成接管。
  succeeded,

  /// `KernelSU already has root; skipping exploit`：本次开机已由 KernelSU 接管。
  alreadyRooted,

  /// 只拿到临时 root，KSU 未接管（`module load pending`）。
  tempRootOnly,

  /// W3 未清掉 seccomp，KSU 被拦。
  seccompBlocked,

  /// KSU 尝试加载但失败。
  ksuFailed,

  /// W1（关闭 SELinux）失败。
  w1Failed,

  /// W2（写凭据）失败。
  w2Failed,

  /// W3（清 seccomp）失败。
  w3Failed,

  /// profile 的 release 与设备内核不一致。
  releaseMismatch,

  /// 竞争进入脏状态，原生已自行停进程。
  dirtyRace,

  /// 等待终局信号超时，或本侧取消。
  timedOut,

  /// 以上都不匹配，只有证据没有结论。
  failed;

  /// 安全解析，非法值回落 [failed]。
  ///
  /// 禁止直接调用 `values.byName`：遇到未知名字会抛异常。
  static GhostLockKind fromName(String? value) {
    for (final GhostLockKind kind in GhostLockKind.values) {
      if (kind.name == value) return kind;
    }
    return GhostLockKind.failed;
  }
}
