/// 检查更新失败的原因，展示层据此选文案。
enum UpdateCheckFailure {
  /// `.env` 中没有配置 `API_URL`。
  notConfigured,

  /// 请求超时或网络不可达。
  network,

  /// 响应不是 JSON 对象，或缺少 `version` / `url`。
  invalidResponse,
}
