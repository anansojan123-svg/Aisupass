/// 对话轮次上的非错误提示，文案由 UI 侧按语言映射。
enum ChatNotice {
  /// 无提示。
  none,
  toolCallLimit,
  emptyReply;

  /// 名称解析；非法值回落到 [ChatNotice.none]。
  static ChatNotice fromName(String? value) {
    for (final ChatNotice item in ChatNotice.values) {
      if (item.name == value) return item;
    }
    return ChatNotice.none;
  }
}
