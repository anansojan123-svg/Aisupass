import 'package:Aisupass/core/providers/escalation_native_provider.dart';
import 'package:Aisupass/features/escalation/data/datasources/kernel_profile_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/kernel_profile_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_state.dart';
import 'package:Aisupass/features/escalation/domain/repositories/kernel_profile_action_repository.dart';
import 'package:Aisupass/features/escalation/presentation/providers/kernel_profile_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kernel_profile_action_provider.g.dart';

/// 用户 profile 动作数据源。
@riverpod
KernelProfileActionDatasource kernelProfileActionDatasource(Ref ref) =>
    KernelProfileActionDatasource(
      native: ref.watch(cve98260ProfileNativeProvider),
    );

/// 用户 profile 动作仓储。
@riverpod
KernelProfileActionRepository kernelProfileActionRepository(Ref ref) =>
    KernelProfileActionRepositoryImpl(
      datasource: ref.watch(kernelProfileActionDatasourceProvider),
      query: ref.watch(kernelProfileQueryDatasourceProvider),
    );

/// 从 boot.img 导入一份 profile，按进度块吐出。
@riverpod
Stream<KernelProfileImportState> importKernelProfile(
  Ref ref, {
  required String path,
}) => ref
    .watch(kernelProfileActionRepositoryProvider)
    .importBootImage(path: path);

/// 从 OTA 链接导入一份 profile，按进度块吐出。
@riverpod
Stream<KernelProfileImportState> importKernelProfileFromUrl(
  Ref ref, {
  required String url,
}) => ref
    .watch(kernelProfileActionRepositoryProvider)
    .importBootImageFromUrl(url: url);

/// 用户 profile 的写操作。
///
/// 无参 `keepAlive` 类，参数走方法入参：带参族函数会按参数缓存。
@Riverpod(keepAlive: true)
KernelProfileActions kernelProfileActions(Ref ref) => KernelProfileActions(ref);

/// 见 [kernelProfileActions]。
class KernelProfileActions {
  KernelProfileActions(this._ref);

  final Ref _ref;

  /// 删除一份用户 profile，成功后刷新列表。
  Future<bool> remove(String release) async {
    final bool removed = await _ref
        .read(kernelProfileActionRepositoryProvider)
        .removeImportedProfile(release: release);
    _ref.invalidate(kernelProfileListProvider);
    return removed;
  }
}
