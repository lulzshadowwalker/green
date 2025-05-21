import 'package:dio/dio.dart';
import 'package:green/model/control_status.dart';
import '../contract/control_repository.dart';

class GoControlRepository implements ControlRepository {
  final Dio _dio;
  GoControlRepository({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Stream<ControlStatus> watchAll() async* {
    while (true) {
      final r = await _dio.get('http://192.168.100.212:8080/api/control');
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
    final body = <String, dynamic>{
      'sensor_type': sensorType,
      'mode': mode,
    };
    if (manualUntil != null) {
      body['manual_until'] = manualUntil.toUtc().toIso8601String();
    }
    if (manualIntValue != null) {
      body['manual_int_value'] = manualIntValue;
    }
    if (manualBoolValue != null) {
      body['manual_bool_value'] = manualBoolValue;
    }
    final r = await _dio.post('http://192.168.100.212:8080/api/control', data: body);
    return ControlStatus.fromJson(r.data);
  }
}
