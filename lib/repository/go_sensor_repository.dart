import 'package:dio/dio.dart';
import 'package:green/model/sensor_reading.dart';
import 'package:green/contract/sensor_repository.dart';

class GoSensorRepository implements SensorRepository {
  final Dio _dio;
  GoSensorRepository({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Stream<Map<SensorType, List<SensorReading>>> fetchAll() async* {
    while (true) {
      final r = await _dio.get('http://192.168.100.212:8080/api/readings');
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      final list =
          (r.data['data'] as List)
              .map((e) => SensorReading.fromJson(e as Map<String, dynamic>))
              .where((reading) =>
                reading.timestamp.isAfter(sevenDaysAgo) &&
                reading.timestamp.isBefore(now.add(const Duration(days: 1)))
              )
              .toList();
      final map = <SensorType, List<SensorReading>>{};
      for (var t in SensorType.values) {
        map[t] = list.where((r) => r.type == t).toList();
      }
      yield map;
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
