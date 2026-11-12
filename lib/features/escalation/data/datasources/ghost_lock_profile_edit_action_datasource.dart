import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;

/// GhostLock profile 编辑数据源。
///
/// 只做原生转发，三层合并与校验都在 Kotlin 侧。
class GhostLockProfileEditActionDatasource {
  GhostLockProfileEditActionDatasource({required this._native});

  final pigeon.GhostLockProfileEditNative _native;

  /// 解析 builtin + imported + override 三层。
  Future<pigeon.GhostLockProfileConfig> loadProfile({
    required String release,
  }) => _native.loadProfile(release);

  /// 写通用参数。
  Future<pigeon.GhostLockProfileConfig> updateGeneralFields({
    required String release,
    required Map<String, int> values,
  }) => _native.updateGeneralFields(release, values);

  /// 写高级字段。
  Future<pigeon.GhostLockProfileConfig> updateAdvancedFields({
    required String release,
    required Map<String, int> values,
  }) => _native.updateAdvancedFields(release, values);

  /// 设置 route；空串恢复为 profile 声明。
  Future<pigeon.GhostLockProfileConfig> updateRoute({
    required String release,
    required String route,
  }) => _native.updateRoute(release, route);

  /// 设置 fallback。
  Future<pigeon.GhostLockProfileConfig> updateFallback({
    required String release,
    required String fallbackTo,
  }) => _native.updateFallback(release, fallbackTo);

  /// 清掉该 release 的全部 override。
  Future<pigeon.GhostLockProfileConfig> resetProfile({
    required String release,
  }) => _native.resetProfile(release);

  /// 指定生效的内置表；空串回到设备自身 release。
  Future<pigeon.GhostLockProfileConfig> selectBuiltin({
    required String release,
    required String profileRelease,
  }) => _native.selectBuiltin(release, profileRelease);

  /// 指定生效的用户文档；空串不使用导入层。
  Future<pigeon.GhostLockProfileConfig> selectUserProfile({
    required String release,
    required String name,
  }) => _native.selectUserProfile(release, name);

  /// 导出当前生效配置到本地文件。
  Future<bool> exportProfile({required String release, required String path}) =>
      _native.exportProfile(release, path);

  /// 另存为一份用户文档。
  Future<bool> saveModifiedProfile({required String release}) =>
      _native.saveModifiedProfile(release);
}
