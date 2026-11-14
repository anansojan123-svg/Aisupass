/// 单次工具调用的执行状态。
enum ChatToolStatus {
  running,
  succeeded,
  failed;

  /// 名称解析；非法值回落到 [ChatToolStatus.succeeded]。
  static ChatToolStatus fromName(String? value) {
    for (final ChatToolStatus item in ChatToolStatus.values) {
      if (item.name == value) return item;
    }
    return ChatToolStatus.succeeded;
  }
}
