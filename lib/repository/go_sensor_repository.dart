import 'package:dio/dio.dart';
import 'package:green/model/sensor_reading.dart';
import '../contract/sensor_repository.dart';

class GoSensorRepository implements SensorRepository {
  final Dio _dio;
  GoSensorRepository({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Stream<Map<SensorType, List<SensorReading>>> fetchAll() async* {
    while (true) {
      final r = await _dio.get('http://192.168.100.212:8080/api/readings');
      final list =
          (r.data['data'] as List)
              .map((e) => SensorReading.fromJson(e as Map<String, dynamic>))
              .toList();
      final map = <SensorType, List<SensorReading>>{};
      for (var t in SensorType.values) {
        map[t] = list.where((r) => r.type == t).toList();
      }
      yield map;
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}
