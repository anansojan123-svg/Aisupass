/// 一次运行的结果状态。
///
/// 与原生 `RunLogStore.RunResult` 一一对应；原生只回枚举名，可读文案走 l10n。
enum RunLogResult {
  running,
  success,
  failed,
  stopped,
  interrupted;

  /// 原生回的是枚举名（`RUNNING` 等）。未知一律按「中断」处理，
  /// 因为未知意味着文件尾没有写 `# result=`，属于没走完收尾。
  static RunLogResult fromNative(String raw) => switch (raw) {
    'RUNNING' => RunLogResult.running,
    'SUCCESS' => RunLogResult.success,
    'FAILED' => RunLogResult.failed,
    'STOPPED' => RunLogResult.stopped,
    _ => RunLogResult.interrupted,
  };

  /// 回写给原生时用的枚举名。
  String get nativeName => switch (this) {
    RunLogResult.running => 'RUNNING',
    RunLogResult.success => 'SUCCESS',
    RunLogResult.failed => 'FAILED',
    RunLogResult.stopped => 'STOPPED',
    RunLogResult.interrupted => 'INTERRUPTED',
  };
}
