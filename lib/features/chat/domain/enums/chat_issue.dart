/// 会话级问题，文案由 UI 按语言映射。
enum ChatIssue {
  /// 无问题。
  none,
  noConfig;

  /// 名称解析；非法值回落到 [ChatIssue.none]。
  static ChatIssue fromName(String? value) {
    for (final ChatIssue item in ChatIssue.values) {
      if (item.name == value) return item;
    }
    return ChatIssue.none;
  }
}
