import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/core/utils/payload_shell.dart';
import 'package:Aisupass/features/escalation/data/datasources/dirty_frag_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/ghost_key_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_profile_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/ghost_lock_profile_edit_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/dirty_frag_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_key_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_lock_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_lock_profile_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_lock_profile_edit_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_import_result.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_probe_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_profile_config.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_lock_user_profile.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/models/payload_match.dart';
import 'package:Aisupass/features/escalation/domain/models/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_derive_progress.dart';
import 'package:Aisupass/features/escalation/domain/models/vr_offset_result.dart';
import 'package:Aisupass/features/escalation/domain/repositories/dirty_frag_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_query_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_key_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_lock_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_lock_profile_action_repository.dart';
import 'package:Aisupass/features/escalation/domain/repositories/ghost_lock_profile_edit_action_repository.dart';
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as cve98260;
import 'package:Aisupass/generated/dirty_frag.g.dart' as pigeon;
import 'package:Aisupass/generated/ghost_lock.g.dart' as ghost_lock;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'escalation_action_provider.g.dart';

/// 提权链路执行数据源。
@riverpod
EscalationActionDatasource escalationActionDatasource(Ref ref) =>
    EscalationActionDatasource(
      native: ref.watch(adbShellNativeProvider),
      storage: ref.watch(preferencesStoreProvider),
    );

/// 提权链路执行仓储。
@riverpod
EscalationActionRepository escalationActionRepository(Ref ref) =>
    EscalationActionRepositoryImpl(
      datasource: ref.watch(escalationActionDatasourceProvider),
    );

/// 自动匹配并拼出执行载荷的那一行命令。
///
/// 「选哪份」归查询仓储，「拼命令」归执行仓储，两者的装配只在这里发生。
@riverpod
Future<String> runPayload(Ref ref) async {
  final EscalationQueryRepository query = ref.watch(
    escalationQueryRepositoryProvider,
  );
  final EscalationActionRepository action = ref.watch(
    escalationActionRepositoryProvider,
  );

  final PayloadMatch? match = await query.resolve();
  if (match == null) {
    return 'echo ${PayloadShell.quote('当前设备在载荷清单里没有候选')}';
  }
  return action.runPayload(match.payload);
}

/// 用指定载荷拼出执行命令，跳过自动匹配。
///
/// 与 [runPayload] 共用执行仓储，区别只在「哪一条」是调用方给的，还是查出来的。
/// 用户在载荷清单里手动指定时走这里。
@riverpod
Future<String> runPayloadChoice(Ref ref, {required Payload payload}) =>
    ref.watch(escalationActionRepositoryProvider).runPayload(payload);

/// 把临时 root 移交给用户选定的 [manager]。
///
/// 管理器未安装时返回 [HandoffKind.managerMissing]，不抛异常。
@riverpod
Future<HandoffOutcome> handoffRoot(Ref ref, {required RootManager manager}) =>
    ref.watch(escalationActionRepositoryProvider).handoffRoot(manager: manager);

/// root 管理器的写操作。
///
/// 形态同 `aiConfigActions`：无参 `keepAlive` 类持有 [Ref]，参数走方法入参。
/// 带参族函数会按参数缓存，同样的参数第二次调用不再执行方法体。
@Riverpod(keepAlive: true)
RootManagerActions rootManagerActions(Ref ref) => RootManagerActions(ref);

/// 见 [rootManagerActions]。
class RootManagerActions {
  RootManagerActions(this._ref);

  final Ref _ref;

  /// 记住用户选定的管理器，落盘后失效 [selectedRootManagerProvider]。
  Future<void> select(RootManager manager) async {
    await _ref
        .read(escalationActionRepositoryProvider)
        .selectRootManager(manager: manager);
    _ref.invalidate(selectedRootManagerProvider);
  }
}

/// DirtyFrag 运行数据源。
@riverpod
DirtyFragActionDatasource dirtyFragActionDatasource(Ref ref) =>
    DirtyFragActionDatasource(native: pigeon.DirtyFragNative());

/// DirtyFrag 运行仓储。
@riverpod
DirtyFragActionRepository dirtyFragActionRepository(Ref ref) =>
    DirtyFragActionRepositoryImpl(
      datasource: ref.watch(dirtyFragActionDatasourceProvider),
    );

/// 本次开机是否已经注入过。
@riverpod
Future<bool> dirtyFragArmed(Ref ref) =>
    ref.watch(dirtyFragActionRepositoryProvider).isArmed();

/// 运行默认值（设置页四个开关的当前值）。
@riverpod
Future<DirtyFragRunDefaults> dirtyFragRunDefaults(Ref ref) =>
    ref.watch(dirtyFragActionRepositoryProvider).runDefaults();

/// DirtyFrag 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。
@Riverpod(keepAlive: true)
DirtyFragActions dirtyFragActions(Ref ref) => DirtyFragActions(ref);

/// 见 [dirtyFragActions]。
class DirtyFragActions {
  DirtyFragActions(this._ref);

  final Ref _ref;

  /// 写运行默认值。四个字段整体覆盖。
  Future<void> saveRunDefaults(DirtyFragRunDefaults defaults) async {
    await _ref
        .read(dirtyFragActionRepositoryProvider)
        .saveRunDefaults(defaults: defaults);
    _ref.invalidate(dirtyFragRunDefaultsProvider);
  }

  /// 切换专家模式。
  Future<void> setExpertMode({required bool enabled}) async {
    await _ref
        .read(dirtyFragActionRepositoryProvider)
        .setExpertModeEnabled(enabled: enabled);
    _ref.invalidate(dirtyFragExpertModeProvider);
    _ref.invalidate(dirtyFragBootAutostartProvider);
  }

  /// 切换开机自启。
  Future<void> setBootAutostart({required bool enabled}) async {
    await _ref
        .read(dirtyFragActionRepositoryProvider)
        .setBootAutostartEnabled(enabled: enabled);
    _ref.invalidate(dirtyFragBootAutostartProvider);
  }
}

/// 跑一次 DirtyFrag，按块吐出证据。
@riverpod
Stream<DirtyFragOutcome> runDirtyFrag(
  Ref ref, {
  required RootManager manager,
  int? vrOffsetOverride,
}) => ref
    .watch(dirtyFragActionRepositoryProvider)
    .run(manager: manager, vrOffsetOverride: vrOffsetOverride);

/// 专家模式开关当前状态。
@riverpod
Future<bool> dirtyFragExpertMode(Ref ref) =>
    ref.watch(dirtyFragActionRepositoryProvider).isExpertModeEnabled();

/// 开机自启开关当前状态。真相是组件启用态。
@riverpod
Future<bool> dirtyFragBootAutostart(Ref ref) =>
    ref.watch(dirtyFragActionRepositoryProvider).isBootAutostartEnabled();

/// 从镜像或 OTA 直链算一次 vr 偏移。
@riverpod
Future<VrOffsetResult> deriveVrOffset(
  Ref ref, {
  required String input,
  bool insecure = false,
}) => ref
    .watch(dirtyFragActionRepositoryProvider)
    .deriveVrOffset(input: input, insecure: insecure);

/// 提取进度。只在被监听期间轮询，弹窗关掉就停。
@riverpod
Stream<VrDeriveProgress> vrDeriveProgress(Ref ref) async* {
  while (true) {
    yield await ref
        .watch(dirtyFragActionRepositoryProvider)
        .vrDeriveProgress();
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}

/// GhostKey 运行数据源。
@riverpod
GhostKeyActionDatasource ghostKeyActionDatasource(Ref ref) =>
    GhostKeyActionDatasource(
      native: cve98260.Cve98260Native(),
      storage: ref.watch(preferencesStoreProvider),
    );

/// GhostKey 运行仓储。
@riverpod
GhostKeyActionRepository ghostKeyActionRepository(Ref ref) =>
    GhostKeyActionRepositoryImpl(
      datasource: ref.watch(ghostKeyActionDatasourceProvider),
    );

/// GhostKey 起跑前的六项就绪检查。
@riverpod
Future<GhostKeyPreflight> ghostKeyPreflight(Ref ref) =>
    ref.watch(ghostKeyActionRepositoryProvider).preflight();

/// 运行偏好（设置页两个开关的当前值）。
@riverpod
Future<GhostKeyRunDefaults> ghostKeyRunDefaults(Ref ref) =>
    ref.watch(ghostKeyActionRepositoryProvider).runDefaults();

/// GhostKey 设置页的写操作。
///
/// 同 [rootManagerActions]：无参类，参数走方法入参。
@Riverpod(keepAlive: true)
GhostKeyActions ghostKeyActions(Ref ref) => GhostKeyActions(ref);

/// 见 [ghostKeyActions]。
class GhostKeyActions {
  GhostKeyActions(this._ref);

  final Ref _ref;

  /// 写运行偏好。两个字段整体覆盖。
  Future<void> saveRunDefaults(GhostKeyRunDefaults defaults) async {
    await _ref
        .read(ghostKeyActionRepositoryProvider)
        .saveRunDefaults(defaults: defaults);
    _ref.invalidate(ghostKeyRunDefaultsProvider);
  }
}

/// 跑一次 GhostKey，按块吐出证据。
@riverpod
Stream<GhostKeyOutcome> runGhostKey(Ref ref, {RootManager? manager}) => ref
    .watch(ghostKeyActionRepositoryProvider)
    .run(manager: manager);

/// GhostLock 运行数据源。
@riverpod
GhostLockActionDatasource ghostLockActionDatasource(Ref ref) =>
    GhostLockActionDatasource(native: ghost_lock.GhostLockNative());

/// GhostLock 运行仓储。
@riverpod
GhostLockActionRepository ghostLockActionRepository(Ref ref) =>
    GhostLockActionRepositoryImpl(
      datasource: ref.watch(ghostLockActionDatasourceProvider),
    );

/// 运行前自检。
@riverpod
Future<GhostLockPreflight> ghostLockPreflight(Ref ref) =>
    ref.watch(ghostLockActionRepositoryProvider).preflight();

/// 跑一次 GhostLock，按块吐出证据。
@riverpod
Stream<GhostLockOutcome> runGhostLock(
  Ref ref, {
  RootManager? manager,
  bool safeMode = false,
}) => ref
    .watch(ghostLockActionRepositoryProvider)
    .run(manager: manager, safeMode: safeMode);

/// GhostLock profile 导入数据源。
@riverpod
GhostLockProfileActionDatasource ghostLockProfileActionDatasource(Ref ref) =>
    GhostLockProfileActionDatasource(
      native: ghost_lock.GhostLockProfileNative(),
    );

/// GhostLock profile 导入仓储。
@riverpod
GhostLockProfileActionRepository ghostLockProfileActionRepository(Ref ref) =>
    GhostLockProfileActionRepositoryImpl(
      datasource: ref.watch(ghostLockProfileActionDatasourceProvider),
    );

/// 用户导入的 profile 列表。
@riverpod
Future<List<GhostLockUserProfile>> ghostLockImportedProfiles(Ref ref) =>
    ref.watch(ghostLockProfileActionRepositoryProvider).listImportedProfiles();

/// 内置 GhostLock 内核表的全部 release，升序。
@riverpod
Future<List<String>> ghostLockBuiltinReleases(Ref ref) =>
    ref.watch(ghostLockProfileActionRepositoryProvider).listBuiltinReleases();

/// 单份用户 profile 的原始 HOCON 文本；不存在返回空串。
@riverpod
Future<String> ghostLockImportedProfileContent(
  Ref ref, {
  required String name,
}) => ref
    .watch(ghostLockProfileActionRepositoryProvider)
    .readImportedProfile(name: name);

/// GhostLock 解析进度。只在被监听期间轮询，面板收起就停。
@riverpod
Stream<GhostLockProbeProgress> ghostLockProbeProgress(Ref ref) async* {
  while (true) {
    yield await ref
        .watch(ghostLockProfileActionRepositoryProvider)
        .profileProgress();
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}

/// GhostLock profile 编辑数据源。
@riverpod
GhostLockProfileEditActionDatasource ghostLockProfileEditActionDatasource(
  Ref ref,
) => GhostLockProfileEditActionDatasource(
  native: ghost_lock.GhostLockProfileEditNative(),
);

/// GhostLock profile 编辑仓储。
@riverpod
GhostLockProfileEditActionRepository ghostLockProfileEditActionRepository(
  Ref ref,
) => GhostLockProfileEditActionRepositoryImpl(
  datasource: ref.watch(ghostLockProfileEditActionDatasourceProvider),
);

/// 某个 release 的解析结果（编辑器视图）。
@riverpod
Future<GhostLockProfileConfig> ghostLockProfileConfig(
  Ref ref, {
  required String release,
}) => ref
    .watch(ghostLockProfileEditActionRepositoryProvider)
    .load(release: release);

/// GhostLock profile 导入与编辑的写操作。
///
/// 同 [ghostKeyActions]：无参类，参数走方法入参。
@Riverpod(keepAlive: true)
GhostLockProfileActions ghostLockProfileActions(Ref ref) =>
    GhostLockProfileActions(ref);

/// 见 [ghostLockProfileActions]。
class GhostLockProfileActions {
  GhostLockProfileActions(this._ref);

  final Ref _ref;

  /// 解析内核表但不落盘；结果由调用方暂存，选定落点后再调 [saveProfile]。
  Future<GhostLockProbe> probeProfile({
    required String input,
    bool insecure = false,
  }) => _ref
      .read(ghostLockProfileActionRepositoryProvider)
      .probeProfile(input: input, insecure: insecure);

  /// 把 [probeProfile] 返回的文本落盘。
  Future<GhostLockImportResult> saveProfile({
    required String release,
    required String conf,
    bool overwrite = false,
  }) async {
    final GhostLockImportResult result = await _ref
        .read(ghostLockProfileActionRepositoryProvider)
        .saveProfile(release: release, conf: conf, overwrite: overwrite);
    _ref.invalidate(ghostLockImportedProfilesProvider);
    _ref.invalidate(ghostLockPreflightProvider);
    return result;
  }

  /// 删除一份用户 profile。
  Future<bool> removeImportedProfile({required String name}) async {
    final bool removed = await _ref
        .read(ghostLockProfileActionRepositoryProvider)
        .removeImportedProfile(name: name);
    _ref.invalidate(ghostLockImportedProfilesProvider);
    _ref.invalidate(ghostLockPreflightProvider);
    return removed;
  }

  /// 写通用参数。
  Future<GhostLockProfileConfig> updateGeneral({
    required String release,
    required Map<String, int> values,
  }) => _apply(release, (repo) => repo.updateGeneral(release: release, values: values));

  /// 写高级字段。
  Future<GhostLockProfileConfig> updateAdvanced({
    required String release,
    required Map<String, int> values,
  }) => _apply(
    release,
    (repo) => repo.updateAdvanced(release: release, values: values),
  );

  /// 设置 route；空串恢复为 profile 声明。
  Future<GhostLockProfileConfig> updateRoute({
    required String release,
    required String route,
  }) => _apply(release, (repo) => repo.updateRoute(release: release, route: route));

  /// 设置 fallback。
  Future<GhostLockProfileConfig> updateFallback({
    required String release,
    required String fallbackTo,
  }) => _apply(
    release,
    (repo) => repo.updateFallback(release: release, fallbackTo: fallbackTo),
  );

  /// 清掉该 release 的全部 override。
  Future<GhostLockProfileConfig> reset({required String release}) =>
      _apply(release, (repo) => repo.reset(release: release));

  /// 指定生效的内置表；空串回到设备自身 release。
  Future<GhostLockProfileConfig> selectBuiltin({
    required String release,
    required String profileRelease,
  }) => _apply(
    release,
    (repo) => repo.selectBuiltin(release: release, profileRelease: profileRelease),
  );

  /// 指定生效的用户文档；空串不使用导入层。
  Future<GhostLockProfileConfig> selectUserProfile({
    required String release,
    required String name,
  }) => _apply(
    release,
    (repo) => repo.selectUserProfile(release: release, name: name),
  );

  /// 导出当前生效配置到本地文件。
  Future<bool> exportProfile({required String release, required String path}) =>
      _ref
          .read(ghostLockProfileEditActionRepositoryProvider)
          .export(release: release, path: path);

  /// 另存为一份用户文档。
  Future<bool> saveModified({required String release}) async {
    final bool saved = await _ref
        .read(ghostLockProfileEditActionRepositoryProvider)
        .saveModified(release: release);
    _ref.invalidate(ghostLockImportedProfilesProvider);
    return saved;
  }

  /// 写操作共用：落盘后失效该 release 的解析结果与运行前自检。
  Future<GhostLockProfileConfig> _apply(
    String release,
    Future<GhostLockProfileConfig> Function(GhostLockProfileEditActionRepository repo)
    action,
  ) async {
    final GhostLockProfileConfig config = await action(
      _ref.read(ghostLockProfileEditActionRepositoryProvider),
    );
    _ref.invalidate(ghostLockProfileConfigProvider(release: release));
    _ref.invalidate(ghostLockPreflightProvider);
    return config;
  }
}
