import 'package:Aisupass/features/announcement/data/datasources/announcement_query_datasource.dart';
import 'package:Aisupass/features/announcement/data/repositories/announcement_query_repository_impl.dart';
import 'package:Aisupass/features/announcement/domain/models/announcement.dart';
import 'package:Aisupass/features/announcement/domain/repositories/announcement_query_repository.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'announcement_query_provider.g.dart';

/// 公告查询数据源。
@riverpod
AnnouncementQueryDatasource announcementQueryDatasource(Ref ref) =>
    AnnouncementQueryDatasource(
      dio: Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ),
    );

/// 公告查询仓储。
@riverpod
AnnouncementQueryRepository announcementQueryRepository(Ref ref) =>
    AnnouncementQueryRepositoryImpl(
      datasource: ref.watch(announcementQueryDatasourceProvider),
    );

/// 服务端当前公告。
@riverpod
Future<Announcement> latestAnnouncement(Ref ref) =>
    ref.watch(announcementQueryRepositoryProvider).fetchLatest();
