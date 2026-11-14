import 'dart:convert';

import 'package:Aisupass/features/web_search/data/models/web_page_content_dto.dart';
import 'package:Aisupass/features/web_search/data/models/web_search_result_dto.dart';
import 'package:dio/dio.dart';

/// 搜索请求失败时抛出的异常。
///
/// 由数据源抛出、presentation 层捕获，`message` 已尽量取服务端可读文案。
class WebSearchException implements Exception {
  const WebSearchException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Bing 搜索数据源：走公开的 RSS 输出，不需要 API Key。
///
/// 用 `format=rss` 而不是抓 HTML：RSS 结构固定、字段有名字，
/// 不会因为页面改版把解析器全打挂。
class WebSearchQueryDatasource {
  WebSearchQueryDatasource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 20),
              // 搜索页对 UA 敏感：默认 Dart UA 常被判成爬虫直接给空结果。
              headers: const <String, String>{
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
                    'AppleWebKit/537.36 (KHTML, like Gecko) '
                    'Chrome/124.0.0.0 Safari/537.36',
                'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
              },
            ),
          );

  final Dio _dio;

  /// Bing 单次返回上限，超出部分它会静默截断，这里先夹住。
  static const int _maxCount = 20;

  static const String _endpoint = 'https://www.bing.com/search';

  /// 响应体上限，避免异常页面把内存吃满。
  static const int _maxBodyChars = 1024 * 1024;

  Future<List<WebSearchResultDto>> search({
    required String query,
    required int count,
    required String market,
  }) async {
    final String keyword = query.trim();
    if (keyword.isEmpty) {
      throw const WebSearchException('Search query is empty');
    }

    final int limit = count < 1
        ? 10
        : (count > _maxCount ? _maxCount : count);

    final Response<String> response;
    try {
      response = await _dio.get<String>(
        _endpoint,
        queryParameters: <String, dynamic>{
          'q': keyword,
          'format': 'rss',
          'count': limit,
          if (market.trim().isNotEmpty) 'mkt': market.trim(),
        },
        options: Options(responseType: ResponseType.plain),
      );
    } on DioException catch (error) {
      throw WebSearchException(
        error.message ?? error.type.name,
        statusCode: error.response?.statusCode,
      );
    }

    final int? status = response.statusCode;
    if (status == null || status < 200 || status >= 300) {
      throw WebSearchException(
        'Search failed with HTTP $status',
        statusCode: status,
      );
    }

    return _parseRss(response.data ?? '');
  }

  /// 抓取网页原始正文。
  ///
  /// 非 2xx 也照常返回：403 的挑战页、登录跳转页本身就是模型要看的证据。
  /// 按字节读取后自行解码，避免 Dio 在缺少 charset 时直接抛解码错误。
  Future<WebPageContentDto> fetchPage({
    required String url,
    required int maxChars,
  }) async {
    final Uri? uri = Uri.tryParse(url.trim());
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      throw WebSearchException('Not an absolute http or https URL: $url');
    }

    final Response<List<int>> response;
    try {
      response = await _dio.get<List<int>>(
        uri.toString(),
        options: Options(
          responseType: ResponseType.bytes,
          // 状态码交给调用方判断，4xx/5xx 的正文同样要拿回来。
          validateStatus: (int? status) => status != null,
          headers: const <String, String>{
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          },
        ),
      );
    } on DioException catch (error) {
      throw WebSearchException(
        error.message ?? error.type.name,
        statusCode: error.response?.statusCode,
      );
    }

    final List<int> bytes = response.data ?? const <int>[];
    final String decoded = _decodeBody(bytes);

    final int total = decoded.length;
    final String text = total > maxChars ? decoded.substring(0, maxChars) : decoded;

    return WebPageContentDto(
      url: url.trim(),
      finalUrl: response.realUri.toString(),
      statusCode: response.statusCode ?? 0,
      contentType: response.headers.value('content-type') ?? '',
      text: text,
      totalChars: total,
    );
  }

  /// 先按 UTF-8 严格解码，失败再带替换符解一次。
  ///
  /// 非 UTF-8 编码（如 GBK）的页面会出现替换符，但至少能看清结构，
  /// 好过整次请求因为解码异常直接失败。
  String _decodeBody(List<int> bytes) {
    try {
      return utf8.decode(bytes);
    } on FormatException {
      return utf8.decode(bytes, allowMalformed: true);
    }
  }

  /// 从 RSS 文本里抽 `<item>`，逐条映射成 DTO。
  ///
  /// 返回空列表说明上游换了格式或被拦截，交由调用方按「无结果」处理。
  List<WebSearchResultDto> _parseRss(String raw) {
    final String body = raw.length > _maxBodyChars
        ? raw.substring(0, _maxBodyChars)
        : raw;

    final Iterable<RegExpMatch> items = RegExp(
      r'<item>(.*?)</item>',
      dotAll: true,
    ).allMatches(body);
    if (items.isEmpty) return const <WebSearchResultDto>[];

    final List<WebSearchResultDto> results = <WebSearchResultDto>[];
    for (final RegExpMatch item in items) {
      final String block = item.group(1) ?? '';
      final WebSearchResultDto? dto = WebSearchResultDto.fromRssFields(
        <String, String>{
          'title': _tag(block, 'title'),
          'link': _tag(block, 'link'),
          'description': _tag(block, 'description'),
          'pubDate': _tag(block, 'pubDate'),
        },
      );
      if (dto != null) results.add(dto);
    }
    return results;
  }

  /// 取单个标签的文本：去 CDATA、反转义、压缩空白。
  String _tag(String block, String name) {
    final RegExpMatch? match = RegExp(
      '<$name>(.*?)</$name>',
      dotAll: true,
    ).firstMatch(block);
    if (match == null) return '';
    String value = match.group(1) ?? '';
    final RegExpMatch? cdata = RegExp(
      r'^\s*<!\[CDATA\[(.*?)\]\]>\s*$',
      dotAll: true,
    ).firstMatch(value);
    if (cdata != null) value = cdata.group(1) ?? '';
    return _unescape(value).replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// 反转义 RSS 里常见的五种实体与数字实体。
  String _unescape(String value) {
    String text = value
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&amp;', '&');

    text = text.replaceAllMapped(
      RegExp(r'&#(\d+);'),
      (Match match) => String.fromCharCode(int.tryParse(match.group(1)!) ?? 63),
    );
    text = text.replaceAllMapped(
      RegExp(r'&#x([0-9a-fA-F]+);'),
      (Match match) =>
          String.fromCharCode(int.tryParse(match.group(1)!, radix: 16) ?? 63),
    );
    return text;
  }
}
