import 'package:green/model/sensor_reading.dart';
import 'package:green/model/sensor_timespan.dart';

abstract class SensorRepository {
  Stream<Map<SensorType, List<SensorReading>>> fetchAll({SensorTimespan timespan = SensorTimespan.day});
}
