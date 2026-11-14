import 'package:Aisupass/features/web_search/domain/models/web_page_content.dart';
import 'package:flutter/foundation.dart';

/// 网页抓取的传输对象。
@immutable
class WebPageContentDto {
  const WebPageContentDto({
    required this.url,
    required this.finalUrl,
    required this.statusCode,
    required this.contentType,
    required this.text,
    required this.totalChars,
  });

  final String url;
  final String finalUrl;
  final int statusCode;
  final String contentType;
  final String text;
  final int totalChars;

  WebPageContent toEntity() => WebPageContent(
    url: url,
    finalUrl: finalUrl,
    statusCode: statusCode,
    contentType: contentType,
    text: text,
    totalChars: totalChars,
  );
}
