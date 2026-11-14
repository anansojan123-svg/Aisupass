import 'package:Aisupass/core/providers/escalation_native_provider.dart';
import 'package:Aisupass/features/escalation/data/datasources/kernel_profile_action_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/kernel_profile_action_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_import_result.dart';
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

  /// 删除一份用户文档，成功后刷新列表与生效来源。
  Future<bool> remove(String name) async {
    final bool removed = await _ref
        .read(kernelProfileActionRepositoryProvider)
        .removeImportedProfile(name: name);
    if (removed) _invalidateAll();
    return removed;
  }

  /// 写回同一份文档，成功后刷新列表、详情与编辑器缓存。
  Future<KernelProfileImportResult> saveEditor({
    required String name,
    required Map<String, String> values,
  }) async {
    final KernelProfileImportResult result = await _ref
        .read(kernelProfileActionRepositoryProvider)
        .saveEditor(name: name, values: values);
    if (result.ok) {
      _ref.invalidate(kernelProfileListProvider);
      _ref.invalidate(
        kernelProfileContentProvider(name: name, release: result.release),
      );
      _ref.invalidate(kernelProfileEditorProvider(name: name));
    }
    return result;
  }

  /// 另存为新文档，成功后刷新列表；返回新文档名，失败为空串。
  Future<String> saveEditorAs({
    required String name,
    required String documentName,
    required Map<String, String> values,
  }) async {
    final String saved = await _ref
        .read(kernelProfileActionRepositoryProvider)
        .saveEditorAs(name: name, documentName: documentName, values: values);
    if (saved.isNotEmpty) _ref.invalidate(kernelProfileListProvider);
    return saved;
  }

  /// 渲染编辑后的 HOCON 文本，供导出使用。
  Future<String> renderEditor({
    required String name,
    required Map<String, String> values,
  }) => _ref
      .read(kernelProfileActionRepositoryProvider)
      .renderEditor(name: name, values: values);

  /// 指定生效的用户文档；空串清除选择。
  Future<bool> select(String name) async {
    final bool ok = await _ref
        .read(kernelProfileActionRepositoryProvider)
        .selectImportedProfile(name: name);
    if (ok) {
      _ref.invalidate(kernelProfileActiveNameProvider);
      _ref.invalidate(kernelProfileActiveBuiltinProvider);
      _ref.invalidate(kernelProfileListProvider);
    }
    return ok;
  }

  /// 指定生效的内置表；空串清除选择。
  Future<bool> selectBuiltin(String release) async {
    final bool ok = await _ref
        .read(kernelProfileActionRepositoryProvider)
        .selectBuiltinRelease(release: release);
    if (ok) {
      _ref.invalidate(kernelProfileActiveNameProvider);
      _ref.invalidate(kernelProfileActiveBuiltinProvider);
      _ref.invalidate(kernelProfileBuiltinListProvider);
    }
    return ok;
  }

  void _invalidateAll() {
    _ref.invalidate(kernelProfileListProvider);
    _ref.invalidate(kernelProfileActiveNameProvider);
    _ref.invalidate(kernelProfileActiveBuiltinProvider);
  }
}
