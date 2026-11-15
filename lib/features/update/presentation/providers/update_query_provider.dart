import 'package:Aisupass/features/update/data/datasources/update_query_datasource.dart';
import 'package:Aisupass/features/update/data/repositories/update_query_repository_impl.dart';
import 'package:Aisupass/features/update/domain/models/app_update.dart';
import 'package:Aisupass/features/update/domain/repositories/update_query_repository.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_query_provider.g.dart';

/// 更新查询数据源。
@riverpod
UpdateQueryDatasource updateQueryDatasource(Ref ref) => UpdateQueryDatasource(
  dio: Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  ),
);

/// 更新查询仓储。
@riverpod
UpdateQueryRepository updateQueryRepository(Ref ref) =>
    UpdateQueryRepositoryImpl(
      datasource: ref.watch(updateQueryDatasourceProvider),
    );

/// 服务端最新版本；手动检查前 invalidate 本 provider 即可重新拉取。
@riverpod
Future<AppUpdate> latestUpdate(Ref ref) =>
    ref.watch(updateQueryRepositoryProvider).fetchLatest();
