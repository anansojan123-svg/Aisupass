import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_page_content.freezed.dart';

/// 一次网页抓取的结果。
///
/// 保留状态码与内容类型：403 / Cloudflare 挑战页、登录跳转页这些
/// 都属于「拿到了响应但拿不到数据」，模型需要看到证据自己判断，
/// 而不是被统一包装成一句失败。
@freezed
abstract class WebPageContent with _$WebPageContent {
  const WebPageContent._();

  const factory WebPageContent({
    required String url,

    /// 跟随重定向后的最终地址；无重定向时与 [url] 相同。
    required String finalUrl,
    required int statusCode,
    required String contentType,

    /// 响应正文；超出上限时只保留前段。
    required String text,

    /// 正文原始字符数，用于判断是否被截断。
    required int totalChars,
  }) = _WebPageContent;

  bool get ok => statusCode >= 200 && statusCode < 300;

  bool get truncated => totalChars > text.length;
}
