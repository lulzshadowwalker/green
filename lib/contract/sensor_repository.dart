import 'package:green/model/sensor_reading.dart';

abstract class SensorRepository {
  Future<Map<SensorType, List<SensorReading>>> fetchAll();
}
