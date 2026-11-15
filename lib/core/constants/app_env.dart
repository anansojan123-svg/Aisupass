import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 更新接口地址，值来自随包分发的 `.env`。
///
/// 未配置或留空时返回 null，由调用方决定如何处理。
class AppEnv {
  AppEnv._();

  static String? get apiUrl {
    final String value = dotenv.env['API_URL']?.trim() ?? '';
    return value.isEmpty ? null : value;
  }
}
