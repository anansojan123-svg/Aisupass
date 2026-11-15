import 'package:Aisupass/features/update/domain/models/app_update.dart';
import 'package:Aisupass/features/update/presentation/providers/update_query_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 检查更新的编排：拉取服务端最新版本并与本机版本比对。
///
/// 不持有 `BuildContext`、不弹提示；结果由调用方呈现。
class UpdateCheckController {
  UpdateCheckController({
    required this._ref,
    required this._version,
    required this._buildNumber,
  });

  final WidgetRef _ref;
  final String _version;
  final String _buildNumber;

  /// 返回需要提示的版本；已是最新时返回 null。
  ///
  /// 接口未配置、网络失败或响应无效时抛 `UpdateCheckException`。
  Future<AppUpdate?> check() async {
    // 每次都重新拉取，避免拿到上一次检查的缓存。
    _ref.invalidate(latestUpdateProvider);
    final AppUpdate latest = await _ref.read(latestUpdateProvider.future);
    return latest.isNewerThan(version: _version, buildNumber: _buildNumber)
        ? latest
        : null;
  }
}
