
import 'package:flutter/material.dart';

enum SensorType { temperature, humidity, lightLevel, waterLevel, soilMoisture }

class SensorReading {
  final String id;
  final SensorType type;
  final DateTime timestamp;
  final double value;
  SensorReading({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.value,
  });
  factory SensorReading.fromJson(Map<String, dynamic> json) {
    final attr = json['attributes'] as Map<String, dynamic>;
    final typeStr = attr['type'] as String;
    final type = <String, SensorType>{
      'temperature': SensorType.temperature,
      'humidity': SensorType.humidity,
      'light': SensorType.lightLevel,
      'water': SensorType.waterLevel,
      'soil': SensorType.soilMoisture,
    }[typeStr]!;
    return SensorReading(
      id: json['id'] as String,
      type: type,
      timestamp: DateTime.parse(attr['timestamp'] as String),
      value: (attr['value'] as num).toDouble(),
    );
  }
}

extension SensorTypeExt on SensorType {
  String get displayName => <SensorType, String>{
        SensorType.temperature: 'Temperature',
        SensorType.humidity: 'Humidity',
        SensorType.lightLevel: 'Light',
        SensorType.waterLevel: 'Water',
        SensorType.soilMoisture: 'Soil Moisture',
      }[this]!;
  IconData get icon => <SensorType, IconData>{
        SensorType.temperature: Icons.thermostat_outlined,
        SensorType.humidity: Icons.water_drop_outlined,
        SensorType.lightLevel: Icons.wb_sunny_outlined,
        SensorType.waterLevel: Icons.opacity_outlined,
        SensorType.soilMoisture: Icons.grass_outlined,
      }[this]!;
  Color get color => <SensorType, Color>{
        SensorType.temperature: Colors.red,
        SensorType.humidity: Colors.blue,
        SensorType.lightLevel: Colors.amber,
        SensorType.waterLevel: Colors.lightBlue,
        SensorType.soilMoisture: Colors.brown,
      }[this]!;
}
