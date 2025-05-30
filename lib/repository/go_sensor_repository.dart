import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:green/model/sensor_reading.dart';
import 'package:green/contract/sensor_repository.dart';
import 'package:green/config/api_config.dart';
import 'package:green/model/sensor_timespan.dart';

class GoSensorRepository implements SensorRepository {
  final Dio _dio;
  GoSensorRepository({Dio? dio}) : _dio = (dio ?? Dio()) {
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
  Stream<Map<SensorType, List<SensorReading>>> fetchAll({
    SensorTimespan timespan = SensorTimespan.day,
  }) async* {
    late Duration minInterval;
    if (timespan == SensorTimespan.sixHours) {
      minInterval = Duration(minutes: 15);
    } else if (timespan == SensorTimespan.day) {
      minInterval = Duration(minutes: 25);
    } else if (timespan == SensorTimespan.week) {
      minInterval = Duration(minutes: 60);
    }

    while (true) {
      final r = await _dio.get('${ApiConfig.baseUrl}/readings');
      final now = DateTime.now();
      final from = now.subtract(timespan.duration);
      final list =
          (r.data['data'] as List)
              .map((e) => SensorReading.fromJson(e as Map<String, dynamic>))
              .where(
                (reading) =>
                    reading.timestamp.isAfter(from) &&
                    reading.timestamp.isBefore(
                      now.add(const Duration(days: 1)),
                    ),
              )
              .toList();

      final map = <SensorType, List<SensorReading>>{};
      for (var t in SensorType.values) {
        final readings =
            list.where((r) => r.type == t).toList()
              ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
        final filtered = <SensorReading>[];
        DateTime? lastAdded;
        for (final reading in readings) {
          if (lastAdded == null ||
              reading.timestamp.difference(lastAdded) >= minInterval) {
            filtered.add(reading);
            lastAdded = reading.timestamp;
          }
        }
        map[t] = filtered;
      }
      yield map;
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
