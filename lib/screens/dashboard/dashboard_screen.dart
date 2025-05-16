import 'dart:math';
import 'package:flutter/material.dart';
import '../../widgets/thermal_grid.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data sementara
    final List<double> thermalData =
        List.generate(64, (index) => 25 + Random().nextDouble() * 10);

    final Map<String, dynamic> sensorData = const {
      'PIR': 'Tidak',
      'Ultrasonik': '50 cm',
      'Status Pengusir': 'Nonaktif',
    };

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Thermal Sensor dalam Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.thermostat_outlined, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Thermal AMG8833 (8x8)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ThermalGrid(temperatures: thermalData),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // PIR & Ultrasonik side by side
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    title: 'PIR',
                    value: sensorData['PIR']!,
                    icon: Icons.motion_photos_on_outlined,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SensorCard(
                    title: 'Ultrasonik',
                    value: sensorData['Ultrasonik']!,
                    icon: Icons.straighten,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status Pengusir
            SensorCard(
              title: 'Status Pengusir',
              value: sensorData['Status Pengusir']!,
              icon: Icons.speaker,
              color: Colors.green,
            ),

            const SizedBox(height: 20),

            // Tombol pengusir manual
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur pengusir manual belum tersedia')),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Aktifkan Pengusir Manual'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
