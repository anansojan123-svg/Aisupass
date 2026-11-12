import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_profile_edit_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/ghost_lock_profile_config_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_lock_profile_edit_action_repository.dart';

/// GhostLock profile 编辑仓储实现：DTO -> Entity 的唯一转换点。
class GhostLockProfileEditActionRepositoryImpl
    implements GhostLockProfileEditActionRepository {
  GhostLockProfileEditActionRepositoryImpl({required this._datasource});

  final GhostLockProfileEditActionDatasource _datasource;

  @override
  Future<GhostLockProfileConfig> load({required String release}) async =>
      GhostLockProfileConfigDto.fromNative(
        await _datasource.loadProfile(release: release),
      ).toEntity();

  @override
  Future<GhostLockProfileConfig> updateGeneral({
    required String release,
    required Map<String, int> values,
  }) async => GhostLockProfileConfigDto.fromNative(
    await _datasource.updateGeneralFields(release: release, values: values),
  ).toEntity();

  @override
  Future<GhostLockProfileConfig> updateAdvanced({
    required String release,
    required Map<String, int> values,
  }) async => GhostLockProfileConfigDto.fromNative(
    await _datasource.updateAdvancedFields(release: release, values: values),
  ).toEntity();

  @override
  Future<GhostLockProfileConfig> updateRoute({
    required String release,
    required String route,
  }) async => GhostLockProfileConfigDto.fromNative(
    await _datasource.updateRoute(release: release, route: route),
  ).toEntity();

  @override
  Future<GhostLockProfileConfig> updateFallback({
    required String release,
    required String fallbackTo,
  }) async => GhostLockProfileConfigDto.fromNative(
    await _datasource.updateFallback(release: release, fallbackTo: fallbackTo),
  ).toEntity();

  @override
  Future<GhostLockProfileConfig> reset({required String release}) async =>
      GhostLockProfileConfigDto.fromNative(
        await _datasource.resetProfile(release: release),
      ).toEntity();

  @override
  Future<GhostLockProfileConfig> selectBuiltin({
    required String release,
    required String profileRelease,
  }) async => GhostLockProfileConfigDto.fromNative(
    await _datasource.selectBuiltin(
      release: release,
      profileRelease: profileRelease,
    ),
  ).toEntity();

  @override
  Future<GhostLockProfileConfig> selectUserProfile({
    required String release,
    required String name,
  }) async => GhostLockProfileConfigDto.fromNative(
    await _datasource.selectUserProfile(release: release, name: name),
  ).toEntity();

  @override
  Future<bool> export({required String release, required String path}) =>
      _datasource.exportProfile(release: release, path: path);

  @override
  Future<bool> saveModified({required String release}) =>
      _datasource.saveModifiedProfile(release: release);
}
