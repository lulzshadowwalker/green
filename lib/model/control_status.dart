class ControlStatus {
  final Map<String, String> modes; // e.g. {fan: "manual", ...}
  final Map<String, dynamic> values; // e.g. {fan: 255, door: true, ...}

  ControlStatus({required this.modes, required this.values});

  factory ControlStatus.fromJson(Map<String, dynamic> json) {
    final modes = <String, String>{};
    final values = <String, dynamic>{};
    for (final key in json.keys) {
      if (key.endsWith('_mode')) {
        final sensor = key.replaceAll('_mode', '');
        modes[sensor] = json[key] as String;
      } else if (!key.endsWith('_mode')) {
        values[key] = json[key];
      }
    }
    return ControlStatus(modes: modes, values: values);
  }

  String modeFor(String sensor) => modes[sensor] ?? 'automatic';
  dynamic valueFor(String sensor) => values[sensor];
}
