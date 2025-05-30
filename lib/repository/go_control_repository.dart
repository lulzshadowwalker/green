import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:green/model/control_status.dart';
import '../contract/control_repository.dart';
import 'package:green/config/api_config.dart';

class GoControlRepository implements ControlRepository {
  final Dio _dio;
  GoControlRepository({Dio? dio})
      : _dio = dio ?? Dio() {
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
  Stream<ControlStatus> watchAll() async* {
    while (true) {
      final r = await _dio.get('${ApiConfig.baseUrl}/control');
      yield ControlStatus.fromJson(r.data);
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Future<ControlStatus> setControl({
    required String sensorType,
    required String mode,
    DateTime? manualUntil,
    int? manualIntValue,
    bool? manualBoolValue,
  }) async {
    final body = <String, dynamic>{'sensor_type': sensorType, 'mode': mode};
    if (manualUntil != null) {
      body['manual_until'] = manualUntil.toUtc().toIso8601String();
    }
    if (manualIntValue != null) {
      body['manual_int_value'] = manualIntValue;
    }
    if (manualBoolValue != null) {
      body['manual_bool_value'] = manualBoolValue;
    }
    final r = await _dio.post(
      '${ApiConfig.baseUrl}/control',
      data: body,
    );
    return ControlStatus.fromJson(r.data);
  }
}
