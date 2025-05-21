import 'package:green/model/sensor_reading.dart';

abstract class SensorRepository {
  Stream<Map<SensorType, List<SensorReading>>> fetchAll();
}
