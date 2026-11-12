import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:Aisupass/features/escalation/data/datasources/kernel_profile_query_datasource.dart';
import 'package:Aisupass/features/escalation/data/repositories/kernel_profile_query_repository_impl.dart';
import 'package:Aisupass/features/escalation/domain/models/kernel_profile.dart';
import 'package:Aisupass/features/escalation/domain/repositories/kernel_profile_query_repository.dart';
import 'package:Aisupass/generated/cve98260.g.dart' as pigeon;

part 'kernel_profile_query_provider.g.dart';

/// 用户 profile 查询数据源。
@riverpod
KernelProfileQueryDatasource kernelProfileQueryDatasource(Ref ref) =>
    KernelProfileQueryDatasource(native: pigeon.Cve98260ProfileNative());

/// 用户 profile 查询仓储。
@riverpod
KernelProfileQueryRepository kernelProfileQueryRepository(Ref ref) =>
    KernelProfileQueryRepositoryImpl(
      datasource: ref.watch(kernelProfileQueryDatasourceProvider),
    );

/// 已导入的 profile 列表。
@riverpod
Future<List<KernelProfile>> kernelProfileList(Ref ref) =>
    ref.watch(kernelProfileQueryRepositoryProvider).listImported();

/// 内置的 profile 列表（不含用户导入）。
@riverpod
Future<List<KernelProfile>> kernelProfileBuiltinList(Ref ref) =>
    ref.watch(kernelProfileQueryRepositoryProvider).listBuiltin();

/// 单份 profile 的原始 HOCON 文本。
@riverpod
Future<String> kernelProfileContent(Ref ref, {required String release}) =>
    ref.watch(kernelProfileQueryRepositoryProvider).readContent(release: release);
