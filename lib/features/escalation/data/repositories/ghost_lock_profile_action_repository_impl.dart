import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_profile_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/models/ghost_lock_user_profile_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_lock_profile_action_repository.dart';

/// GhostLock profile 仓储实现：DTO -> Entity 的唯一转换点。
class GhostLockProfileActionRepositoryImpl
    implements GhostLockProfileActionRepository {
  GhostLockProfileActionRepositoryImpl({required this._datasource});

  final GhostLockProfileActionDatasource _datasource;

  @override
  Future<GhostLockProbe> probeProfile({
    required String input,
    bool insecure = false,
    String xblPath = '',
    String uefiPath = '',
    String vendorBootPath = '',
    String phys = '',
    String kallsymsPath = '',
    String iomemPath = '',
    String route = '',
    bool allowMissing = false,
    bool noDisasm = false,
  }) async => (await _datasource.probeProfile(
    input: input,
    insecure: insecure,
    xblPath: xblPath,
    uefiPath: uefiPath,
    vendorBootPath: vendorBootPath,
    phys: phys,
    kallsymsPath: kallsymsPath,
    iomemPath: iomemPath,
    route: route,
    allowMissing: allowMissing,
    noDisasm: noDisasm,
  )).toEntity();

  @override
  Future<GhostLockProbeProgress> profileProgress() async =>
      (await _datasource.profileProgress()).toEntity();

  @override
  Future<GhostLockImportResult> saveProfile({
    required String release,
    required String conf,
    bool overwrite = false,
  }) async => (await _datasource.saveProfile(
    release: release,
    conf: conf,
    overwrite: overwrite,
  )).toEntity();

  @override
  Future<List<GhostLockUserProfile>> listImportedProfiles() async {
    final List<GhostLockUserProfileDto> rows = await _datasource
        .listImportedProfiles();
    // 显式排序：不依赖原生返回顺序。
    return rows.map((dto) => dto.toEntity()).toList()
      ..sort((a, b) => b.importedAtMs.compareTo(a.importedAtMs));
  }

  @override
  Future<List<String>> listBuiltinReleases() =>
      _datasource.listBuiltinReleases();

  @override
  Future<String> readImportedProfile({required String name}) =>
      _datasource.readImportedProfile(name: name);

  @override
  Future<bool> removeImportedProfile({required String name}) =>
      _datasource.removeImportedProfile(name: name);

  @override
  Future<GhostLockImportResult> importProfileText({
    required String text,
    required String fileName,
    bool overwrite = false,
  }) async => (await _datasource.importProfileText(
    text: text,
    fileName: fileName,
    overwrite: overwrite,
  )).toEntity();

  @override
  Future<String> renameImportedProfile({
    required String name,
    required String newName,
  }) => _datasource.renameImportedProfile(name: name, newName: newName);

  @override
  Future<String> exportImportedProfile({required String name}) =>
      _datasource.exportImportedProfile(name: name);

  @override
  Future<GhostLockImportResult> convertImportedProfile({
    required String name,
  }) async => (await _datasource.convertImportedProfile(name: name)).toEntity();

  @override
  Future<String> exportLocalFile({
    required String sourcePath,
    required String fileName,
  }) => _datasource.exportLocalFile(
    sourcePath: sourcePath,
    fileName: fileName,
  );

  @override
  Future<List<String>> listExtractedImages() =>
      _datasource.listExtractedImages();
}
