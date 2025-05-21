import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green/contract/health_repository.dart';
import 'package:green/model/sensor_reading.dart';
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
                  Text(
                    'Smart Greenhouse',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: secondary,
                    ),
                  ),
                  GridView.count(
                    padding: EdgeInsets.only(top: 24),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1,
                    children: const [
                      _ControlCard(
                        isActive: true,
                        icon: Icons.lightbulb,
                        title: 'Lighting',
                        value: '12 Watt',
                      ),
                      _ControlCard(
                        icon: Icons.thermostat_outlined,
                        title: 'Temperature',
                        value: '24° Celsius',
                      ),
                      _ControlCard(
                        icon: Icons.water_drop_outlined,
                        title: 'Watering',
                        value: '200 ml',
                      ),
                      _ControlCard(
                        icon: Icons.air_outlined,
                        title: 'Ventilation',
                        value: '10 m/s',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
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

class _ControlCard extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final String title;
  final String value;

  const _ControlCard({
    this.isActive = false,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final background = isActive ? secondary : primary;
    final textColor = isActive ? primary : Colors.black;
    final subtitleColor = isActive ? Colors.white70 : Colors.grey.shade600;

    return Container(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: isActive ? primary : accent),
              const Spacer(),
              Switch(
                value: isActive,
                onChanged: (_) {},
                activeColor: secondaryAlt,
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
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: subtitleColor),
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
