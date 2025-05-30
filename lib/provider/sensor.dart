import 'package:green/model/sensor_timespan.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:green/model/sensor_reading.dart';
import 'package:green/repository/go_sensor_repository.dart';
import '../contract/sensor_repository.dart';

final sensorRepositoryProvider = Provider<SensorRepository>(
  (ref) => GoSensorRepository(),
);

final sensorDataProvider = StreamProvider.family<
  Map<SensorType, List<SensorReading>>,
  SensorTimespan
>((ref, span) => ref.read(sensorRepositoryProvider).fetchAll(timespan: span));
