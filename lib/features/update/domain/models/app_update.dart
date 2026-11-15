import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_update.freezed.dart';

/// 服务端发布的最新版本。
@freezed
abstract class AppUpdate with _$AppUpdate {
  const AppUpdate._();

  const factory AppUpdate({
    required String version,
    required String downloadUrl,
    required String notes,
    required bool force,
  }) = _AppUpdate;

  /// 是否比本机版本更新。
  ///
  /// 下载地址为空视为没有更新；远端与本机侧都能解析成整数时按构建号比较，
  /// 否则逐段比较版本名（微验的 `version` 可能填 `611`，也可能填 `1.0`）。
  bool isNewerThan({required String version, required String buildNumber}) {
    if (downloadUrl.isEmpty) return false;

    final int? remote = int.tryParse(this.version);
    final int? local = int.tryParse(buildNumber);
    if (remote != null && local != null) return remote > local;
    return _compareVersion(this.version, version) > 0;
  }
}

/// 逐段比较版本名，返回正数表示 [left] 更新。
///
/// 纯数字段按数值比较，`1.0.10` 大于 `1.0.9`；非数字段退化为字符串比较。
int _compareVersion(String left, String right) {
  final List<String> a = _segments(left);
  final List<String> b = _segments(right);
  final int length = a.length > b.length ? a.length : b.length;

  for (int i = 0; i < length; i += 1) {
    final String l = i < a.length ? a[i] : '0';
    final String r = i < b.length ? b[i] : '0';
    final int? li = int.tryParse(l);
    final int? ri = int.tryParse(r);
    final int diff = li != null && ri != null ? li - ri : l.compareTo(r);
    if (diff != 0) return diff;
  }
  return 0;
}

List<String> _segments(String version) => version
    .split(RegExp(r'[.+-]'))
    .where((String part) => part.isNotEmpty)
    .toList(growable: false);
