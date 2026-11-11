import 'package:Aisupass/core/constants/storage_keys.dart';
import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

/// GhostKey 运行数据源。
///
/// 只做原生转发与偏好读写，受理判定与结果分型都在仓储实现里。
class GhostKeyActionDatasource {
  GhostKeyActionDatasource({
    required this._native,
    required this._storage,
  });

  final pigeon.Cve98260Native _native;

  final KeyValueStore _storage;

  /// 运行前自检。
  Future<pigeon.Cve98260Preflight> preflight() => _native.preflight();

  /// 受理一次运行。
  Future<pigeon.Cve98260StartResult> start({
    required pigeon.Cve98260Request request,
  }) => _native.start(request);

  /// 取走自上次轮询以来新增的阶段事件与输出。
  Future<pigeon.Cve98260Chunk> poll({required String sessionId}) =>
      _native.poll(sessionId);

  /// 取消运行。
  Future<void> cancel({required String sessionId}) =>
      _native.cancel(sessionId);

  /// 是否在末段接管 KernelSU；缺省 `true`。
  Future<bool> readRunKsu() =>
      _storage.read<bool>(StorageKeys.ghostKeyRunKsu, defaultValue: true);

  /// 是否接受 `calib_b` 的 fallback 置信度；缺省 `true`。
  Future<bool> readAcceptFallback() => _storage.read<bool>(
    StorageKeys.ghostKeyAcceptFallbackPageOffset,
    defaultValue: true,
  );

  /// 写「接管 KernelSU」开关。
  Future<void> writeRunKsu({required bool value}) =>
      _storage.write<bool>(StorageKeys.ghostKeyRunKsu, value);

  /// 写「接受 fallback」开关。
  Future<void> writeAcceptFallback({required bool value}) => _storage
      .write<bool>(StorageKeys.ghostKeyAcceptFallbackPageOffset, value);
}
