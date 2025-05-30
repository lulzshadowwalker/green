import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:green/contract/health_repository.dart';
import 'package:green/config/api_config.dart';

class GoHealthRepository implements HealthRepository {
  final Dio _dio;

  GoHealthRepository({Dio? dio})
    : _dio = (dio ??
        Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 3),
            receiveTimeout: const Duration(seconds: 3),
          ),
        )
      ) {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: false,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  @override
  Future<SystemStatus> fetchStatus() async {
    try {
      final response = await _dio.head(
        '${ApiConfig.baseUrl}/health',
      );
      return response.statusCode == 200
          ? SystemStatus.active
          : SystemStatus.inactive;
    } on DioException {
      return SystemStatus.inactive;
    }
  }
}
