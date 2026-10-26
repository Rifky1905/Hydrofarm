import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'perawatan_screen.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  static const List<_SensorData> _sensors = [
    _SensorData(
      label: 'pH Air',
      value: '6.0',
      unit: '',
      range: 'Ideal: 5.5 - 6.5',
      icon: Icons.science_outlined,
      status: 'Normal',
      iconColor: AppColors.accent,
      statusColor: AppColors.success,
    ),
    _SensorData(
      label: 'TDS Nutrisi',
      value: '1180',
      unit: 'ppm',
      range: 'Ideal: 1000 - 1400 ppm',
      icon: Icons.opacity_outlined,
      status: 'Normal',
      iconColor: AppColors.secondary,
      statusColor: AppColors.success,
    ),
    _SensorData(
      label: 'Suhu Air',
      value: '27.5',
      unit: '°C',
      range: 'Ideal: 20 - 26 °C',
      icon: Icons.thermostat_outlined,
      status: 'Waspada',
      iconColor: AppColors.warning,
      statusColor: AppColors.warning,
    ),
    _SensorData(
      label: 'Ketinggian Air',
      value: '78',
      unit: '%',
      range: 'Minimal: 60%',
      icon: Icons.water_outlined,
      status: 'Normal',
      iconColor: AppColors.primary,
      statusColor: AppColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text('Monitoring'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Perawatan',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PerawatanScreen(),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kondisi Sistem Hidroponik',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pantau parameter penting secara real-time',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.85,
              children:
                  _sensors.map((sensor) => _SensorCard(data: sensor)).toList(),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Terakhir diperbarui: baru saja',
                style: TextStyle(fontSize: 12, color: AppColors.textLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SensorData {
  const _SensorData({
    required this.label,
    required this.value,
    required this.unit,
    required this.range,
    required this.icon,
    required this.status,
    required this.iconColor,
    required this.statusColor,
  });

  final String label;
  final String value;
  final String unit;
  final String range;
  final IconData icon;
  final String status;
  final Color iconColor;
  final Color statusColor;
}

class _SensorCard extends StatelessWidget {
  const _SensorCard({required this.data});

  final _SensorData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.background,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: data.iconColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data.icon, color: data.iconColor, size: 26),
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: data.statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              data.label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: data.value,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (data.unit.isNotEmpty)
                    TextSpan(
                      text: ' ${data.unit}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              data.range,
              style: const TextStyle(fontSize: 11, color: AppColors.textLight),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: data.statusColor.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                data.status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: data.statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
