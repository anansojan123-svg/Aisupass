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

  /// 把当前生效配置渲染为 HOCON 文本；无法解析时返回空串。
  Future<String> renderProfile({required String release}) =>
      _native.renderProfile(release);

  /// 另存为一份用户文档。
  Future<bool> saveModifiedProfile({required String release}) =>
      _native.saveModifiedProfile(release);

  /// 只重置通用参数的 override。
  Future<pigeon.GhostLockProfileConfig> resetGeneralFields({
    required String release,
  }) => _native.resetGeneralFields(release);

  /// 只重置路由与高级字段的 override。
  Future<pigeon.GhostLockProfileConfig> resetAdvancedFields({
    required String release,
  }) => _native.resetAdvancedFields(release);

  /// 把当前生效配置写回用户文档 [name]。
  Future<bool> overwriteProfile({
    required String release,
    required String name,
  }) => _native.overwriteProfile(release, name);

  /// 打开编辑会话；[name] 为空串表示内置/设备态。
  Future<pigeon.GhostLockProfileConfig> beginEditSession({
    required String name,
    required String deviceRelease,
  }) => _native.beginEditSession(name, deviceRelease);

  /// 丢弃未保存改动并重新解析。
  Future<pigeon.GhostLockProfileConfig> reloadEditSession() =>
      _native.reloadEditSession();

  /// 会话是否编辑当前生效配置。
  Future<bool> editSessionIsLive() => _native.editSessionIsLive();

  /// 会话目标的文档名；内置/设备态返回空串。
  Future<String> editSessionTarget() => _native.editSessionTarget();

  /// 会话实际使用的 release。
  Future<String> editSessionRelease() => _native.editSessionRelease();

  /// 把会话 override 写入 live override。
  Future<bool> commitEditSession() => _native.commitEditSession();

  /// 用会话结果整篇覆盖目标文档。
  Future<bool> saveEditSessionInPlace() => _native.saveEditSessionInPlace();

  /// 会话结果另存为新文档；失败返回空串。
  Future<String> saveEditSessionAsNew() => _native.saveEditSessionAsNew();

  /// 会话结果导出到 [path]。
  Future<bool> exportEditSession({required String path}) =>
      _native.exportEditSession(path);

  /// 关闭会话。
  Future<void> endEditSession() => _native.endEditSession();
}
