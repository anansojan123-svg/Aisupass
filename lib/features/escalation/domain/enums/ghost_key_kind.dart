/// GhostKey 一次运行的终局分类。
///
/// 分类由 [GhostKeyActionRepositoryImpl] 依据分段退出码判定，原生不回结论。
enum GhostKeyKind {
  /// 正在运行，尚未拿到终局证据。
  running,

  /// 原生拒绝受理：`alreadyRunning` / `noAdb` / `notShell` / `seccompFiltered` /
  /// `missingBinary` / `noProfile` / `badRequest`，具体码见 `GhostKeyOutcome.reason`。
  notStarted,

  /// 五阶段全通，临时 root 已就绪。
  succeeded,

  /// 五阶段走完，但 `calib_b` 回了 `fallback` 置信度（记降级，不中止）。
  degraded,

  /// `calib_a` 失败（退出码 2）：KASLR slide 解不出。
  calibFailed,

  /// `calib_b` 失败（退出码 3）：线性映射 page_offset 解不出。
  pageOffsetFailed,

  /// 注入失败（退出码 4）：rootd 通道未就绪。
  injectFailed,

  /// 提权校验失败（退出码 5）：临时 root 通道不可用。
  verifyFailed,

  /// 退出码 0，但 `ksu` 阶段被标 `failed`；临时 root 已就绪，只是没接管管理器。
  ksuFailed,

  /// 等待阶段结束超时（或被本侧取消）。
  timedOut,

  /// 以上都不匹配，只有证据没有结论。
  failed;

  /// 安全解析，非法值回落 [failed]。
  ///
  /// 禁止直接调用 `values.byName`：遇到未知名字会抛异常。
  static GhostKeyKind fromName(String? value) {
    for (final GhostKeyKind kind in GhostKeyKind.values) {
      if (kind.name == value) return kind;
    }
    return GhostKeyKind.failed;
  }
}
