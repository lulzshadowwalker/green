enum SystemStatus {
  active,
  inactive,
}

abstract interface class HealthRepository {
  Future<SystemStatus> fetchStatus();
}
