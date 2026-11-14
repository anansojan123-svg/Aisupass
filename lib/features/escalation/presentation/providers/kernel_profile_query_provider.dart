import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:Aisupass/core/providers/escalation_native_provider.dart';
import 'package:Aisupass/features/escalation/data/datasources/kernel_profile_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/kernel_profile_query_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile_editor.dart';
import 'package:Aisupass/features/escalation/domain/repositories/kernel_profile_query_repository.dart';

part 'kernel_profile_query_provider.g.dart';

/// 用户 profile 查询数据源。
@riverpod
KernelProfileQueryDatasource kernelProfileQueryDatasource(Ref ref) =>
    KernelProfileQueryDatasource(
      native: ref.watch(cve98260ProfileNativeProvider),
    );

/// 用户 profile 查询仓储。
@riverpod
KernelProfileQueryRepository kernelProfileQueryRepository(Ref ref) =>
    KernelProfileQueryRepositoryImpl(
      datasource: ref.watch(kernelProfileQueryDatasourceProvider),
    );

/// 已导入的 profile 列表（最近修改优先）。
@riverpod
Future<List<KernelProfile>> kernelProfileList(Ref ref) =>
    ref.watch(kernelProfileQueryRepositoryProvider).listImported();

/// 内置的 profile 列表（不含用户导入）。
@riverpod
Future<List<KernelProfile>> kernelProfileBuiltinList(Ref ref) =>
    ref.watch(kernelProfileQueryRepositoryProvider).listBuiltin();

/// 当前生效的用户文档名；未选择返回空串。
@riverpod
Future<String> kernelProfileActiveName(Ref ref) =>
    ref.watch(kernelProfileQueryRepositoryProvider).activeImportedProfile();

/// 单份 profile 的原始 HOCON 文本；`name` 为空时按 `release` 读内置表。
@riverpod
Future<String> kernelProfileContent(
  Ref ref, {
  required String name,
  required String release,
}) => ref
    .watch(kernelProfileQueryRepositoryProvider)
    .readContent(name: name, release: release);

/// 单份用户文档的可编辑字段。
@riverpod
Future<KernelProfileEditorState> kernelProfileEditor(
  Ref ref, {
  required String name,
}) => ref
    .watch(kernelProfileQueryRepositoryProvider)
    .readEditor(name: name);
