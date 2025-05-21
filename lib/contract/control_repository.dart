import 'package:green/model/control_status.dart';

abstract class ControlRepository {
  /// Stream of all control statuses (polls GET /api/control every 5 seconds)
  Stream<ControlStatus> watchAll();

  /// Set control mode/value for a sensor (POST /api/control)
  Future<ControlStatus> setControl({
    required String sensorType,
    required String mode, // "automatic" or "manual"
    DateTime? manualUntil,
    int? manualIntValue,
    bool? manualBoolValue,
  });
}
