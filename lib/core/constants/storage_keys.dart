/// 键值存储中跨数据源共用的键。
abstract final class StorageKeys {
  /// 用户选定的 root 管理器包名。
  static const String escalationSelectedRootManager =
      'escalation.selected_root_manager';

  /// GhostKey 是否在末段接管 KernelSU。
  static const String ghostKeyRunKsu = 'escalation.ghost_key.run_ksu';

  /// GhostKey 是否接受 calib_b 的 fallback 置信度。
  static const String ghostKeyAcceptFallbackPageOffset =
      'escalation.ghost_key.accept_fallback_page_offset';
}
