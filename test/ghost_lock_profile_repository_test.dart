import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_profile_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_profile_edit_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_lock_profile_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_lock_profile_edit_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart' as pigeon;
import 'package:flutter_test/flutter_test.dart';

/// 只替换原生层：仓储与 DTO 映射跑真实实现。
class _FakeProfileNative extends pigeon.GhostLockProfileNative {
  _FakeProfileNative();

  /// 最近一次 [probeProfile] 收到的参数，用于校验六个入参没有错位。
  List<Object?>? probeArgs;

  /// [probeProfile] 的返回值。
  pigeon.GhostLockProbeResult probeResult = _probeResult();

  /// [listImportedProfiles] 的返回值（故意乱序）。
  List<pigeon.GhostLockUserProfile> profiles = <pigeon.GhostLockUserProfile>[];

  /// 各方法返回的固定值。
  String renameResult = '';
  String exportText = '';
  bool removeResult = false;

  /// 最近一次 [importProfileText] 收到的参数。
  List<Object?>? importTextArgs;

  @override
  Future<pigeon.GhostLockProbeResult> probeProfile(
    String input,
    bool insecure,
    String xblPath,
    String uefiPath,
    String vendorBootPath,
    String phys,
    String kallsymsPath,
    String iomemPath,
    String route,
    bool allowMissing,
    bool noDisasm,
  ) async {
    probeArgs = <Object?>[
      input,
      insecure,
      xblPath,
      uefiPath,
      vendorBootPath,
      phys,
      kallsymsPath,
      iomemPath,
      route,
      allowMissing,
      noDisasm,
    ];
    return probeResult;
  }

  @override
  Future<String> profileProgress() async => '0 0 0';

  @override
  Future<pigeon.GhostLockImportResult> saveProfile(
    String release,
    String conf,
    bool overwrite,
  ) async => _importResult(release: release, fileName: '$release.conf');

  @override
  Future<pigeon.GhostLockImportResult> importProfile(
    String input,
    bool insecure,
    bool overwrite,
  ) async => _importResult();

  @override
  Future<List<pigeon.GhostLockUserProfile>> listImportedProfiles() async =>
      profiles;

  @override
  Future<List<String>> listBuiltinReleases() async => <String>[];

  @override
  Future<String> readImportedProfile(String name) async => '';

  @override
  Future<bool> removeImportedProfile(String name) async => removeResult;

  @override
  Future<pigeon.GhostLockImportResult> importProfileText(
    String text,
    String fileName,
    bool overwrite,
  ) async {
    importTextArgs = <Object?>[text, fileName, overwrite];
    return _importResult(fileName: fileName);
  }

  @override
  Future<String> renameImportedProfile(String name, String newName) async =>
      renameResult;

  @override
  Future<String> exportImportedProfile(String name) async => exportText;

  @override
  Future<pigeon.GhostLockImportResult> convertImportedProfile(
    String name,
  ) async => _importResult(fileName: '$name-converted.conf');
}

/// 编辑层原生假实现；只记录调用参数。
class _FakeEditNative extends pigeon.GhostLockProfileEditNative {
  _FakeEditNative();

  String? lastMethod;
  List<Object?>? lastArgs;
  bool overwriteResult = true;
  String activeName = '';
  String activeBuiltin = '';

  @override
  Future<pigeon.GhostLockProfileConfig> loadProfile(String release) async =>
      _config(release);

  @override
  Future<pigeon.GhostLockProfileConfig> updateGeneralFields(
    String release,
    Map<String, int> values,
  ) async => _config(release);

  @override
  Future<pigeon.GhostLockProfileConfig> updateAdvancedFields(
    String release,
    Map<String, int> values,
  ) async => _config(release);

  @override
  Future<pigeon.GhostLockProfileConfig> updateRoute(
    String release,
    String route,
  ) async => _config(release);

  @override
  Future<pigeon.GhostLockProfileConfig> updateFallback(
    String release,
    String fallbackTo,
  ) async => _config(release);

  @override
  Future<pigeon.GhostLockProfileConfig> resetProfile(String release) async =>
      _config(release);

  @override
  Future<pigeon.GhostLockProfileConfig> resetGeneralFields(
    String release,
  ) async {
    lastMethod = 'resetGeneralFields';
    lastArgs = <Object?>[release];
    return _config(release);
  }

  @override
  Future<pigeon.GhostLockProfileConfig> resetAdvancedFields(
    String release,
  ) async {
    lastMethod = 'resetAdvancedFields';
    lastArgs = <Object?>[release];
    return _config(release);
  }

  @override
  Future<pigeon.GhostLockProfileConfig> selectBuiltin(
    String release,
    String profileRelease,
  ) async => _config(release);

  @override
  Future<pigeon.GhostLockProfileConfig> selectUserProfile(
    String release,
    String name,
  ) async => _config(release);

  @override
  Future<bool> exportProfile(String release, String path) async => true;

  @override
  Future<String> renderProfile(String release) async => 'release = "6.6.118"\n';

  @override
  Future<String> activeUserProfile() async => activeName;

  @override
  Future<String> activeBuiltinRelease() async => activeBuiltin;

  @override
  Future<bool> saveModifiedProfile(String release) async => true;

  @override
  Future<bool> overwriteProfile(String release, String name) async {
    lastMethod = 'overwriteProfile';
    lastArgs = <Object?>[release, name];
    return overwriteResult;
  }

  @override
  Future<pigeon.GhostLockProfileConfig> beginEditSession(
    String name,
    String deviceRelease,
  ) async {
    lastMethod = 'beginEditSession';
    lastArgs = <Object?>[name, deviceRelease];
    return _config(deviceRelease);
  }

  @override
  Future<pigeon.GhostLockProfileConfig> reloadEditSession() async =>
      _config('6.6.118');

  @override
  Future<bool> editSessionIsLive() async => true;

  @override
  Future<String> editSessionTarget() async => '';

  @override
  Future<String> editSessionRelease() async => '6.6.118';

  @override
  Future<bool> commitEditSession() async => true;

  @override
  Future<bool> saveEditSessionInPlace() async => true;

  @override
  Future<String> saveEditSessionAsNew() async => 'copy.conf';

  @override
  Future<bool> exportEditSession(String path) async => true;

  @override
  Future<void> endEditSession() async {}
}

pigeon.GhostLockProbeResult _probeResult({
  bool ok = true,
  String release = '6.6.118-android15-8',
  String kernelPhysLoad = '0x80000000',
  String kernelPhysOffset = '',
  String physSource = 'xbl_config FDT',
  String analysis = 'route: select_stack',
  List<String> warnings = const <String>[],
}) => pigeon.GhostLockProbeResult(
  ok: ok,
  release: release,
  conf: 'schema_version = 1',
  warnings: warnings,
  bootPath: '/tmp/boot.img',
  reason: '',
  kernelPhysLoad: kernelPhysLoad,
  kernelPhysOffset: kernelPhysOffset,
  physSource: physSource,
  analysis: analysis,
);

pigeon.GhostLockImportResult _importResult({
  bool ok = true,
  String release = '6.6.118-android15-8',
  String fileName = 'a.conf',
  String reason = '',
}) => pigeon.GhostLockImportResult(
  ok: ok,
  release: release,
  fileName: fileName,
  reason: reason,
  requiresOverwrite: false,
);

pigeon.GhostLockProfileConfig _config(String release) =>
    pigeon.GhostLockProfileConfig(
      release: release,
      hasProfile: true,
      roots: <pigeon.GhostLockFieldNode>[],
      general: <pigeon.GhostLockExecutionField>[],
      route: 'select_stack',
      fallbackTo: '',
      invalidPaths: <String>[],
      builtinReleases: <String>[],
    );

pigeon.GhostLockUserProfile _userProfile(String name, int importedAtMs) =>
    pigeon.GhostLockUserProfile(
      name: name,
      release: '6.6.118',
      sizeBytes: 1024,
      importedAtMs: importedAtMs,
      parseError: false,
    );

void main() {
  group('GhostLockProbe 实体', () {
    test('phys 为空串时 hasKernelPhysLoad 为 false', () {
      const GhostLockProbe probe = GhostLockProbe(
        ok: true,
        release: '6.6.118',
        conf: '',
        warnings: <String>[],
        bootPath: '',
        reason: '',
        kernelPhysLoad: '',
        kernelPhysOffset: '',
        physSource: '',
        analysis: '',
      );
      expect(probe.hasKernelPhysLoad, isFalse);
    });

    test('phys 有值时 hasKernelPhysLoad 为 true', () {
      const GhostLockProbe probe = GhostLockProbe(
        ok: true,
        release: '6.6.118',
        conf: '',
        warnings: <String>[],
        bootPath: '',
        reason: '',
        kernelPhysLoad: '0x80000000',
        kernelPhysOffset: '0x40000000',
        physSource: 'manual',
        analysis: '',
      );
      expect(probe.hasKernelPhysLoad, isTrue);
    });
  });

  group('GhostLockProfileActionRepositoryImpl', () {
    test('probeProfile 入参按顺序透传，不串位', () async {
      final _FakeProfileNative native = _FakeProfileNative();
      final GhostLockProfileActionRepositoryImpl repo =
          GhostLockProfileActionRepositoryImpl(
            datasource: GhostLockProfileActionDatasource(native: native),
          );

      await repo.probeProfile(
        input: '/cache/boot.img',
        insecure: true,
        xblPath: '/cache/xbl.img',
        uefiPath: '/cache/uefi.img',
        vendorBootPath: '/cache/vendor_boot.img',
        phys: '0x80000000',
        kallsymsPath: '/cache/kallsyms.txt',
        iomemPath: '/cache/iomem.txt',
        route: 'select_stack',
        allowMissing: true,
        noDisasm: true,
      );

      expect(native.probeArgs, <Object?>[
        '/cache/boot.img',
        true,
        '/cache/xbl.img',
        '/cache/uefi.img',
        '/cache/vendor_boot.img',
        '0x80000000',
        '/cache/kallsyms.txt',
        '/cache/iomem.txt',
        'select_stack',
        true,
        true,
      ]);
    });

    test('probeProfile 新字段映射到实体', () async {
      final _FakeProfileNative native = _FakeProfileNative()
        ..probeResult = _probeResult(
          kernelPhysLoad: '0x80000000',
          kernelPhysOffset: '0x40000000',
          physSource: 'vendor_boot header (MediaTek)',
          analysis: 'family: 6.6',
          warnings: <String>['pselect infeasible'],
        );
      final GhostLockProfileActionRepositoryImpl repo =
          GhostLockProfileActionRepositoryImpl(
            datasource: GhostLockProfileActionDatasource(native: native),
          );

      final GhostLockProbe probe = await repo.probeProfile(input: 'a.img');

      expect(probe.kernelPhysLoad, '0x80000000');
      expect(probe.kernelPhysOffset, '0x40000000');
      expect(probe.physSource, 'vendor_boot header (MediaTek)');
      expect(probe.analysis, 'family: 6.6');
      expect(probe.warnings, <String>['pselect infeasible']);
      expect(probe.hasKernelPhysLoad, isTrue);
    });

    test('解析失败时 ok 与 reason 都要保留', () async {
      final _FakeProfileNative native = _FakeProfileNative()
        ..probeResult = pigeon.GhostLockProbeResult(
          ok: false,
          release: '',
          conf: '',
          warnings: <String>[],
          bootPath: '',
          reason: 'primitive absent: rtmutex fixed',
          kernelPhysLoad: '',
          kernelPhysOffset: '',
          physSource: 'unset',
          analysis: 'primitive: fixed',
        );
      final GhostLockProfileActionRepositoryImpl repo =
          GhostLockProfileActionRepositoryImpl(
            datasource: GhostLockProfileActionDatasource(native: native),
          );

      final GhostLockProbe probe = await repo.probeProfile(input: 'a.img');

      expect(probe.ok, isFalse);
      expect(probe.reason, 'primitive absent: rtmutex fixed');
      expect(probe.analysis, 'primitive: fixed');
      expect(probe.hasKernelPhysLoad, isFalse);
    });

    test('listImportedProfiles 按导入时间倒序', () async {
      final _FakeProfileNative native = _FakeProfileNative()
        ..profiles = <pigeon.GhostLockUserProfile>[
          _userProfile('old.conf', 100),
          _userProfile('new.conf', 300),
          _userProfile('mid.conf', 200),
        ];
      final GhostLockProfileActionRepositoryImpl repo =
          GhostLockProfileActionRepositoryImpl(
            datasource: GhostLockProfileActionDatasource(native: native),
          );

      final List<GhostLockUserProfile> list = await repo.listImportedProfiles();

      expect(
        list.map((GhostLockUserProfile p) => p.name).toList(),
        <String>['new.conf', 'mid.conf', 'old.conf'],
      );
    });

    test('importProfileText 透传文本、文件名与覆盖标记', () async {
      final _FakeProfileNative native = _FakeProfileNative();
      final GhostLockProfileActionRepositoryImpl repo =
          GhostLockProfileActionRepositoryImpl(
            datasource: GhostLockProfileActionDatasource(native: native),
          );

      final GhostLockImportResult result = await repo.importProfileText(
        text: 'release = "6.6.118"',
        fileName: 'x.conf',
        overwrite: true,
      );

      expect(native.importTextArgs, <Object?>[
        'release = "6.6.118"',
        'x.conf',
        true,
      ]);
      expect(result.ok, isTrue);
      expect(result.fileName, 'x.conf');
    });

    test('renameImportedProfile 返回空串表示失败', () async {
      final _FakeProfileNative native = _FakeProfileNative();
      final GhostLockProfileActionRepositoryImpl repo =
          GhostLockProfileActionRepositoryImpl(
            datasource: GhostLockProfileActionDatasource(native: native),
          );

      expect(
        await repo.renameImportedProfile(name: 'a.conf', newName: 'b'),
        '',
      );

      native.renameResult = 'b.conf';
      expect(
        await repo.renameImportedProfile(name: 'a.conf', newName: 'b'),
        'b.conf',
      );
    });

    test('exportImportedProfile 原样返回渲染文本', () async {
      final _FakeProfileNative native = _FakeProfileNative()
        ..exportText = 'release = "6.6.118"\n';
      final GhostLockProfileActionRepositoryImpl repo =
          GhostLockProfileActionRepositoryImpl(
            datasource: GhostLockProfileActionDatasource(native: native),
          );

      expect(
        await repo.exportImportedProfile(name: 'a.conf'),
        'release = "6.6.118"\n',
      );
    });

    test('convertImportedProfile 映射转换后的文件名', () async {
      final _FakeProfileNative native = _FakeProfileNative();
      final GhostLockProfileActionRepositoryImpl repo =
          GhostLockProfileActionRepositoryImpl(
            datasource: GhostLockProfileActionDatasource(native: native),
          );

      final GhostLockImportResult result = await repo.convertImportedProfile(
        name: 'old.conf',
      );

      expect(result.ok, isTrue);
      expect(result.fileName, 'old.conf-converted.conf');
    });
  });

  group('GhostLockProfileEditActionRepositoryImpl', () {
    test('resetGeneral 只调 resetGeneralFields', () async {
      final _FakeEditNative native = _FakeEditNative();
      final GhostLockProfileEditActionRepositoryImpl repo =
          GhostLockProfileEditActionRepositoryImpl(
            datasource: GhostLockProfileEditActionDatasource(native: native),
          );

      final GhostLockProfileConfig config = await repo.resetGeneral(
        release: '6.6.118',
      );

      expect(native.lastMethod, 'resetGeneralFields');
      expect(native.lastArgs, <Object?>['6.6.118']);
      expect(config.release, '6.6.118');
    });

    test('resetAdvanced 只调 resetAdvancedFields', () async {
      final _FakeEditNative native = _FakeEditNative();
      final GhostLockProfileEditActionRepositoryImpl repo =
          GhostLockProfileEditActionRepositoryImpl(
            datasource: GhostLockProfileEditActionDatasource(native: native),
          );

      await repo.resetAdvanced(release: '6.6.118');

      expect(native.lastMethod, 'resetAdvancedFields');
    });

    test('overwriteProfile 透传 release 与文件名', () async {
      final _FakeEditNative native = _FakeEditNative();
      final GhostLockProfileEditActionRepositoryImpl repo =
          GhostLockProfileEditActionRepositoryImpl(
            datasource: GhostLockProfileEditActionDatasource(native: native),
          );

      final bool ok = await repo.overwriteProfile(
        release: '6.6.118',
        name: 'a.conf',
      );

      expect(native.lastMethod, 'overwriteProfile');
      expect(native.lastArgs, <Object?>['6.6.118', 'a.conf']);
      expect(ok, isTrue);
    });

    test('overwriteProfile 原生返回 false 时如实上报', () async {
      final _FakeEditNative native = _FakeEditNative()..overwriteResult = false;
      final GhostLockProfileEditActionRepositoryImpl repo =
          GhostLockProfileEditActionRepositoryImpl(
            datasource: GhostLockProfileEditActionDatasource(native: native),
          );

      expect(
        await repo.overwriteProfile(release: '6.6.118', name: 'a.conf'),
        isFalse,
      );
    });
  });
}
