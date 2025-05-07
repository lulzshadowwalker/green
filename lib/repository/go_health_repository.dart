import 'package:dio/dio.dart';
import 'package:green/contract/health_repository.dart';

class GoHealthRepository implements HealthRepository {
  final Dio _dio;

  GoHealthRepository({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 3), receiveTimeout: const Duration(seconds: 3)));

  @override
  Future<SystemStatus> fetchStatus() async {
    try {
      final response = await _dio.head('https://green.lulzie.online/api/health');
      return response.statusCode == 200 ? SystemStatus.active : SystemStatus.inactive;
    } on DioException {
      return SystemStatus.inactive;
    }
  }
}
