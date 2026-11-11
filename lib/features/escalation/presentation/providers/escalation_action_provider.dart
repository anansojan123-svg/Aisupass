import 'package:Aisupass/core/providers/adb_shell_provider.dart';
import 'package:Aisupass/core/storage/storage_providers.dart';
import 'package:Aisupass/core/utils/payload_shell.dart';
import 'package:Aisupass/features/escalation/data/datasources/dirty_frag_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/datasources/ghost_key_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/dirty_frag_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/escalation_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/data/repositories/ghost_key_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/dirty_frag_run_defaults.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_preflight.dart';
import 'package:Aisupass/features/escalation/domain/models/ghost_key_run_defaults.dart';
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
import 'package:Aisupass/features/escalation/presentation/providers/escalation_query_provider.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as cve98260;
import 'package:Aisupass/generated/dirty_frag.g.dart' as pigeon;
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
