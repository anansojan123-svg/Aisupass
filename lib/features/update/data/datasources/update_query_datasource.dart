import 'package:Aisupass/core/constants/app_env.dart';
import 'package:Aisupass/features/update/data/models/app_update_dto.dart';
import 'package:Aisupass/features/update/domain/enums/update_check_failure.dart';
import 'package:dio/dio.dart';

/// 检查更新过程中抛出的异常。
class UpdateCheckException implements Exception {
  const UpdateCheckException(this.failure, [this.detail]);

  final UpdateCheckFailure failure;

  /// 底层错误信息，仅用于日志，不直接展示。
  final String? detail;

  @override
  String toString() => 'UpdateCheckException(${failure.name}): ${detail ?? ''}';
}

/// 更新查询数据源：GET `.env` 中 `API_URL` 指向的接口。
class UpdateQueryDatasource {
  const UpdateQueryDatasource({required this._dio});

  final Dio _dio;

  /// 拉取最新版本。
  ///
  /// 接口未配置、网络失败或响应缺 `version` / `url` 时抛 [UpdateCheckException]。
  Future<AppUpdateDto> fetchLatest() async {
    final String? endpoint = AppEnv.apiUrl;
    if (endpoint == null) {
      throw const UpdateCheckException(UpdateCheckFailure.notConfigured);
    }

    final Response<dynamic> response;
    try {
      response = await _dio.get<dynamic>(
        endpoint,
        options: Options(responseType: ResponseType.json),
      );
    } on DioException catch (error) {
      throw UpdateCheckException(UpdateCheckFailure.network, error.message);
    }

    final dynamic data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const UpdateCheckException(UpdateCheckFailure.invalidResponse);
    }

    final AppUpdateDto dto = AppUpdateDto.fromJson(data);
    if (dto.msg.version.isEmpty || dto.msg.appUpdateUrl.isEmpty) {
      throw const UpdateCheckException(UpdateCheckFailure.invalidResponse);
    }
    return dto;
  }
}
