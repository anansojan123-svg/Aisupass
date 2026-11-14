import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;

/// GhostLock profile 编辑只读数据源。
///
/// 与 [GhostLockProfileEditActionDatasource] 共用同一套原生接口，
/// 按读/写语义拆分，避免 Action 承载查询。
class GhostLockProfileEditQueryDatasource {
  GhostLockProfileEditQueryDatasource({required this._native});

  final pigeon.GhostLockProfileEditNative _native;

  /// 当前生效的用户文档名；未选用导入层时返回空串。
  Future<String> activeUserProfile() => _native.activeUserProfile();

  /// 当前生效的内置表 release；未指定时返回空串。
  Future<String> activeBuiltinRelease() => _native.activeBuiltinRelease();
}
