enum SensorTimespan {
  sixHours,
  day,
  week,
}

extension SensorTimespanExtension on SensorTimespan {
  Duration get duration {
    switch (this) {
      case SensorTimespan.sixHours:
        return const Duration(hours: 6);
      case SensorTimespan.day:
        return const Duration(days: 1);
      case SensorTimespan.week:
        return const Duration(days: 7);
    }
  }
}
