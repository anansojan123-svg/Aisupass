/// GhostKey 流水线的五个阶段。
///
/// 三个值都来自上游 `NativeContract`：
/// * [code] 对 `NativeContract.Stage` 的 `wire` 名，原生在 `events` 里原样上报；
/// * [weight] 对 `NativeContract.WEIGHTS`（13/15/38/8/26，合计 100）；
/// * [expectedMs] 对 `NativeContract.EXPECTED_MS`（10s/12s/30s/6s/20s）。
///
/// 上游的 `ENTER_HINT` 不放在这里：它是中文文案，必须走 l10n。
enum GhostKeyStage {
  calibA(code: 'calib_a', weight: 13, expectedMs: 10000),
  calibB(code: 'calib_b', weight: 15, expectedMs: 12000),
  inject(code: 'inject', weight: 38, expectedMs: 30000),
  verify(code: 'verify', weight: 8, expectedMs: 6000),
  ksu(code: 'ksu', weight: 26, expectedMs: 20000);

  const GhostKeyStage({
    required this.code,
    required this.weight,
    required this.expectedMs,
  });

  /// 原生上报的阶段码。
  final String code;

  /// 进度权重。
  final double weight;

  /// 该阶段的预期耗时（毫秒），用于进度爬升斜率。
  final int expectedMs;

  /// 未知码回 `null`（调用方跳过），**不设兜底**。
  ///
  /// 原生只可能上报这 5 个码；出现别的说明契约不一致，不能默默归到某一段
  /// 去加权重。
  static GhostKeyStage? fromCode(String? value) {
    for (final GhostKeyStage stage in GhostKeyStage.values) {
      if (stage.code == value) return stage;
    }
    return null;
  }

  /// 权重总和。
  ///
  /// 运行时求和而不是写死 100：对齐上游 `StageTracker.progress()` 的
  /// `totalW = WEIGHTS.sum()`，避免将来调整权重表后总和 ≠ 100 导致进度越界。
  static double get totalWeight => GhostKeyStage.values.fold<double>(
    0,
    (double sum, GhostKeyStage stage) => sum + stage.weight,
  );
}
