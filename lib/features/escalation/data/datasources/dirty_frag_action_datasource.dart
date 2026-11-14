import 'package:Aisupass/features/escalation/data/models/dirty_frag_outcome_dto.dart';
import 'package:Aisupass/features/escalation/data/models/dirty_frag_run_defaults_dto.dart';
import 'package:Aisupass/features/escalation/data/models/vr_derive_progress_dto.dart';
import 'package:Aisupass/generated/dirty_frag.g.dart' as pigeon;

/// 一次受理结果；原生 `DirtyFragStartResult` 只在本层出现。
typedef DirtyFragStartOutcome = ({
  bool accepted,
  String sessionId,
  String reason,
});

/// 一次轮询快照：输出已收敛成 [DirtyFragOutcomeDto]，`finished` 留给仓储判终局。
typedef DirtyFragPollSnapshot = ({DirtyFragOutcomeDto outcome, bool finished});

/// 离线偏移提取结果；原生 `VrDeriveResult` 只在本层出现。
typedef VrDeriveOutcome = ({String error, String json});

/// DirtyFrag 运行数据源。
///
/// 只做原生转发与 DTO 收敛，受理判定与结果分型都在仓储实现里。
class DirtyFragActionDatasource {
  DirtyFragActionDatasource({required this._native});

  final pigeon.DirtyFragNative _native;

  /// 本次开机是否已经注入过。
  Future<bool> isArmed() => _native.isArmed();

  /// 读运行默认值（VR 反制 / 自动解析 / 手动偏移 / 成功后软重启）。
  Future<DirtyFragRunDefaultsDto> getRunDefaults() async =>
      DirtyFragRunDefaultsDto.fromNative(await _native.getRunDefaults());

  /// 写运行默认值。设置页改开关时调用。
  Future<void> setRunDefaults({required DirtyFragRunDefaultsDto defaults}) =>
      _native.setRunDefaults(
        pigeon.DirtyFragRunDefaults(
          vrDisarm: defaults.vrDisarm,
          vrAuto: defaults.vrAuto,
          vrOffset: defaults.vrOffset,
          softReboot: defaults.softReboot,
        ),
      );

  /// 受理一次运行。
  Future<DirtyFragStartOutcome> start({
    required String managerPackage,
    required bool vrDisarm,
    required bool vrAuto,
    required int vrOffset,
    required bool softReboot,
  }) async {
    final pigeon.DirtyFragStartResult result = await _native.start(
      pigeon.DirtyFragRequest(
        managerPackage: managerPackage,
        vrDisarm: vrDisarm,
        vrAuto: vrAuto,
        vrOffset: vrOffset,
        softReboot: softReboot,
      ),
    );
    return (
      accepted: result.accepted,
      sessionId: result.sessionId,
      reason: result.reason,
    );
  }

  /// 取走自上次轮询以来积累的输出。
  Future<DirtyFragPollSnapshot> poll({required String sessionId}) async {
    final pigeon.DirtyFragChunk chunk = await _native.poll(sessionId);
    return (
      outcome: DirtyFragOutcomeDto.fromNative(chunk),
      finished: chunk.finished,
    );
  }

  /// 取消运行。进入内核侧之后的阶段取消不掉，只会停止本侧读取。
  Future<void> cancel({required String sessionId}) => _native.cancel(sessionId);

  /// 专家模式开关当前是否为开。
  Future<bool> isExpertModeEnabled() => _native.isExpertModeEnabled();

  /// 切换专家模式。只写偏好，不碰组件启用态。
  Future<void> setExpertModeEnabled({required bool enabled}) =>
      _native.setExpertModeEnabled(enabled);

  /// 开机自启开关当前是否为开。真相是组件启用态，不是偏好。
  Future<bool> isBootAutostartEnabled() => _native.isBootAutostartEnabled();

  /// 切换开机自启。只改组件启用态，不落偏好。
  Future<void> setBootAutostartEnabled({required bool enabled}) =>
      _native.setBootAutostartEnabled(enabled);

  /// 起一次离线偏移提取。阻塞到结束，进度另用 [vrDeriveProgress] 取。
  Future<VrDeriveOutcome> deriveVrOffset({
    required String input,
    bool insecure = false,
  }) async {
    final pigeon.VrDeriveResult result = await _native.deriveVrOffset(
      input,
      insecure,
    );
    return (error: result.error, json: result.json);
  }

  /// 即时进度三元组串。
  Future<VrDeriveProgressDto> vrDeriveProgress() async =>
      VrDeriveProgressDto.fromNative(await _native.vrDeriveProgress());
}
