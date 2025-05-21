import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green/contract/health_repository.dart';
import 'package:green/model/sensor_reading.dart';
import 'package:green/provider/control.dart';
import 'package:green/provider/health.dart';
import 'package:green/provider/sensor.dart';
import 'package:green/provider/summary.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const primary = Color(0xFFFCFBFC);
const secondary = Color(0xFF093731);
const secondaryContent = primary;
const secondaryAlt = Color(0xFFA6D04E);
const accent = Color(0xFF179778);

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, secondary, secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  const TextSpan(text: 'Welcome, '),
                                  TextSpan(
                                    text: 'John Doe',
                                    style: TextStyle(color: accent),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: Text(
                                'Manage your greenhouse with confidence',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HealthCheck(),
                      const SizedBox(height: 12),
                      Text(
                        'The Greenhouse I',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ramtha, Jordan University',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(16),
                  color: primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _InfoTile(icon: Icons.air, label: 'Wind', value: '5 m/s'),
                    _InfoTile(
                      icon: Icons.water_drop_outlined,
                      label: 'Humidity',
                      value: '20 %',
                    ),
                    _InfoTile(
                      icon: Icons.local_florist,
                      label: 'Plant',
                      value: '4 Type',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const DataChart(),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _InformationBox(),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'Smart Greenhouse',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Consumer(
              builder: (context, ref, _) {
                final controlStatusAsync = ref.watch(controlStatusProvider);
                return controlStatusAsync.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (controlStatus) {
                    final controls = [
                      {
                        'sensorType': 'light',
                        'icon': Icons.lightbulb,
                        'title': 'Lighting',
                        'unit': 'Watt',
                        'isBool': false,
                        'min': 0,
                        'max': 255,
                      },
                      {
                        'sensorType': 'heat',
                        'icon': Icons.thermostat_outlined,
                        'title': 'Temperature',
                        'unit': '',
                        'isBool': false,
                        'min': 0,
                        'max': 255,
                      },
                      {
                        'sensorType': 'pump',
                        'icon': Icons.water_drop_outlined,
                        'title': 'Watering',
                        'unit': '',
                        'isBool': true,
                      },
                      {
                        'sensorType': 'fan',
                        'icon': Icons.air_outlined,
                        'title': 'Ventilation',
                        'unit': 'm/s',
                        'isBool': false,
                        'min': 0,
                        'max': 255,
                      },
                      {
                        'sensorType': 'door',
                        'icon': Icons.door_front_door,
                        'title': 'Door',
                        'unit': '',
                        'isBool': true,
                      },
                    ];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridView.count(
                        padding: const EdgeInsets.only(top: 24),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1,
                        children:
                            controls.map((c) {
                              final sensorType = c['sensorType'] as String;
                              final mode = controlStatus.modeFor(sensorType);
                              final value = controlStatus.valueFor(sensorType);
                              return _ControlCard(
                                sensorType: sensorType,
                                icon: c['icon'] as IconData,
                                title: c['title'] as String,
                                mode: mode,
                                value: value,
                                unit: c['unit'] as String,
                                isBool: c['isBool'] as bool,
                                min: c['min'] as int?,
                                max: c['max'] as int?,
                                onToggle: (newMode, newValue, duration) {
                                  ref
                                      .read(controlRepositoryProvider)
                                      .setControl(
                                        sensorType: sensorType,
                                        mode: newMode,
                                        manualIntValue:
                                            c['isBool'] as bool
                                                ? null
                                                : newValue as int?,
                                        manualBoolValue:
                                            c['isBool'] as bool
                                                ? newValue as bool?
                                                : null,
                                        manualUntil:
                                            duration != null
                                                ? DateTime.now().add(duration)
                                                : null,
                                      );
                                },
                              );
                            }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
          ], // <-- end Column children
        ), // <-- end Column
      ), // <-- end SingleChildScrollView
    ); // <-- end Scaffold
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: accent, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _ControlCard extends ConsumerWidget {
  final String sensorType;
  final IconData icon;
  final String title;
  final String mode; // "automatic" or "manual"
  final dynamic value; // int or bool or null
  final String unit;
  final bool isBool;
  final int? min;
  final int? max;
  final void Function(String mode, dynamic value, Duration? duration) onToggle;

  const _ControlCard({
    Key? key,
    required this.sensorType,
    required this.icon,
    required this.title,
    required this.mode,
    required this.value,
    required this.unit,
    required this.isBool,
    this.min,
    this.max,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isManual = mode == 'manual';
    final isOn =
        isBool ? (value == true) : (value != null && value is int && value > 0);

    final background = isManual ? secondary : primary;
    final textColor = isManual ? primary : Colors.black;
    final subtitleColor = isManual ? Colors.white70 : Colors.grey.shade600;

    return Container(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: isManual ? accent : Colors.grey.shade200,
                child: Icon(icon, color: isManual ? Colors.white : accent),
                radius: 20,
              ),
              const Spacer(),
              GestureDetector(
                onTap:
                    isManual
                        ? () {
                          // Switch back to automatic when badge is tapped
                          onToggle('automatic', null, null);
                        }
                        : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isManual ? accent : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isManual ? 'Manual' : 'Auto',
                        style: TextStyle(
                          color: isManual ? Colors.white : Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          decoration:
                              isManual ? TextDecoration.underline : null,
                        ),
                      ),
                      if (isManual)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                isOn ? 'On' : 'Off',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isOn ? accent : subtitleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),
              Switch(
                value: isOn,
                onChanged: (val) {
                  if (isManual) {
                    // Already manual, just toggle state
                    if (isBool) {
                      onToggle('manual', val, null);
                    } else {
                      onToggle('manual', val ? 255 : 0, null);
                    }
                    ref.invalidate(controlStatusProvider);
                  } else {
                    // Was auto, switch to manual and set state
                    if (isBool) {
                      onToggle('manual', val, null);
                    } else {
                      onToggle('manual', val ? 255 : 0, null);
                    }
                    // Show snackbar when switching from auto to manual
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$title is now in manual mode. It will remain manual until you switch back to automatic.',
                          style: const TextStyle(fontSize: 15),
                        ),
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    );
                    ref.invalidate(controlStatusProvider);
                  }
                },
                activeColor: accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SensorChartCard extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final String title;
  final IconData icon;
  final Color primaryColor;

  const SensorChartCard({
    super.key,
    required this.dataPoints,
    required this.title,
    this.icon = Icons.water_drop_outlined,
    this.primaryColor = accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primary,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: secondary,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey.shade200, height: 32, thickness: 1),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(enabled: true),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine:
                      (y) => FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 32,
                      getTitlesWidget:
                          (value, meta) => Text(
                            value.toInt().toString(),
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget:
                          (value, meta) => Text(
                            '${value.toInt() * 3}h',
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: dataPoints.first.x,
                maxX: dataPoints.last.x,
                minY:
                    dataPoints.map((p) => p.y).reduce((a, b) => a < b ? a : b) -
                    5,
                maxY:
                    dataPoints.map((p) => p.y).reduce((a, b) => a > b ? a : b) +
                    5,
                lineBarsData: [
                  LineChartBarData(
                    spots: dataPoints,
                    isCurved: true,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    color: primaryColor,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withOpacity(0.4),
                          primaryColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationBox extends ConsumerWidget {
  const _InformationBox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSummary = ref.watch(summaryStreamProvider);

    return Container(
      decoration: BoxDecoration(
        color: primary,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: secondary,
            ),
          ),
          Divider(color: Colors.grey.shade200, height: 32, thickness: 1),
          asyncSummary.when(
            loading:
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    'Generating summary...',
                    key: const ValueKey('loading'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),
            data:
                (text) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    text,
                    key: ValueKey(text),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
            error:
                (_, __) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    'Error generating summary',
                    key: const ValueKey('error'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red.shade300,
                      height: 1.4,
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class HealthCheck extends ConsumerWidget {
  const HealthCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStatus = ref.watch(healthStatusProvider);

    return asyncStatus.when(
      loading: () {
        final color = Colors.grey;
        return InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => ref.refresh(healthStatusProvider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_empty, color: color),
                const SizedBox(width: 8),
                Text(
                  'Checking...',
                  style: TextStyle(
                    color: color,
                    fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      data: (status) {
        final color =
            status == SystemStatus.active ? Colors.green : Colors.red.shade300;
        final icon =
            status == SystemStatus.active ? Icons.wifi : Icons.wifi_off;
        final text = status == SystemStatus.active ? 'Active' : 'Inactive';
        return InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => ref.refresh(healthStatusProvider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (_, __) {
        final color = Colors.red.shade300;
        return InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => ref.refresh(healthStatusProvider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, color: color),
                const SizedBox(width: 8),
                Text(
                  'Error',
                  style: TextStyle(
                    color: color,
                    fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DataChart extends HookConsumerWidget {
  const DataChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(sensorDataProvider);
    final controller = usePageController();
    final currentPage = useState(0);

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (map) {
        final pages = map.entries.where((e) => e.value.isNotEmpty).toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: SizedBox(
                height: 240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.hardEdge,
                  child: PageView.builder(
                    controller: controller,
                    itemCount: pages.length,
                    onPageChanged: (i) => currentPage.value = i,
                    itemBuilder: (_, i) {
                      final type = pages[i].key;
                      final readings = pages[i].value;
                      final spots =
                          readings
                              .asMap()
                              .entries
                              .map(
                                (e) => FlSpot(e.key.toDouble(), e.value.value),
                              )
                              .toList();
                      return SensorChartCard(
                        title: type.displayName,
                        icon: type.icon,
                        primaryColor: type.color,
                        dataPoints: spots,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (i) {
                final isActive = i == currentPage.value;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: isActive ? 11 : 8,
                  height: isActive ? 11 : 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.black : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
