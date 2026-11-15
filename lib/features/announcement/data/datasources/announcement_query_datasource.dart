import 'package:Aisupass/core/constants/app_env.dart';
import 'package:Aisupass/features/announcement/data/models/announcement_dto.dart';
import 'package:Aisupass/features/announcement/domain/enums/announcement_fetch_failure.dart';
import 'package:dio/dio.dart';

/// 拉取公告过程中抛出的异常。
class AnnouncementFetchException implements Exception {
  const AnnouncementFetchException(this.failure, [this.detail]);

  final AnnouncementFetchFailure failure;

  /// 底层错误信息，仅用于日志，不直接展示。
  final String? detail;

  @override
  String toString() =>
      'AnnouncementFetchException(${failure.name}): ${detail ?? ''}';
}

/// 公告查询数据源。
///
/// 与更新接口同域：把 `API_URL` 里的 `id` 换成 `notice`，其余参数原样保留。
class AnnouncementQueryDatasource {
  const AnnouncementQueryDatasource({required this._dio});

  final Dio _dio;

  /// 拉取最新公告。
  ///
  /// 接口未配置、网络失败或响应不是 JSON 对象时抛 [AnnouncementFetchException]。
  Future<AnnouncementDto> fetchLatest() async {
    final String? configured = AppEnv.apiUrl;
    if (configured == null) {
      throw const AnnouncementFetchException(
        AnnouncementFetchFailure.notConfigured,
      );
    }

    final Uri? base = Uri.tryParse(configured);
    if (base == null) {
      throw const AnnouncementFetchException(
        AnnouncementFetchFailure.notConfigured,
      );
    }
    final Uri endpoint = base.replace(
      queryParameters: <String, String>{
        ...base.queryParameters,
        'id': 'notice',
      },
    );

    final Response<dynamic> response;
    try {
      response = await _dio.getUri<dynamic>(
        endpoint,
        options: Options(responseType: ResponseType.json),
      );
    } on DioException catch (error) {
      throw AnnouncementFetchException(
        AnnouncementFetchFailure.network,
        error.message,
      );
    }

    final dynamic data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const AnnouncementFetchException(
        AnnouncementFetchFailure.invalidResponse,
      );
    }
    return AnnouncementDto.fromJson(data);
  }
}
