/// 拉取公告失败的原因。
enum AnnouncementFetchFailure {
  /// `.env` 中没有配置 `API_URL`，或地址无法解析。
  notConfigured,

  /// 请求超时或网络不可达。
  network,

  /// 响应不是 JSON 对象。
  invalidResponse,
}
