/// 对话角色。工具结果不单独成条，挂在发起调用的 assistant 轮次上。
enum ChatRole {
  user,
  assistant;

  /// 名称解析；非法值回落到 [ChatRole.assistant]。
  static ChatRole fromName(String? value) {
    for (final ChatRole item in ChatRole.values) {
      if (item.name == value) return item;
    }
    return ChatRole.assistant;
  }
}
