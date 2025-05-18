import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../widgets/thermal_heatmap.dart';
import '../../widgets/costum_header.dart';
import '../notification/notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DatabaseReference _sensorRef;
  late DatabaseReference _thermalRef;

  Map<String, dynamic> sensorData = {
    'PIR': '0',
    'Ultrasonik': '0',
    'Status Pengusir': '0',
  };

  List<double> thermalData = List.filled(64, 0.0);

  @override
  void initState() {
    super.initState();

    _sensorRef = FirebaseDatabase.instance.ref('sensor');
    _thermalRef = FirebaseDatabase.instance.ref('thermal/temperatures');

    _sensorRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        setState(() {
          sensorData = {
            'PIR': (data['pir'] == true) ? 'Terdeteksi' : 'Tidak',
            'Ultrasonik':
                data['ultrasonik'] != null ? '${data['ultrasonik']} cm' : '-',
            'Status Pengusir':
                (data['pengusir'] == true) ? 'Aktif' : 'Nonaktif',
          };
        });
      }
    });

    _thermalRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        List<double> temps = [];
        if (data is List) {
          temps = data.map<double>((e) {
            if (e is num) return e.toDouble();
            return 0.0;
          }).toList();
        } else if (data is Map) {
          temps = List<double>.filled(64, 0);
          data.forEach((key, value) {
            int idx = int.tryParse(key) ?? -1;
            if (idx >= 0 && idx < 64) {
              if (value is num) {
                temps[idx] = value.toDouble();
              }
            }
          });
        }

        if (temps.length == 64) {
          setState(() {
            thermalData = temps;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomHeader(
        deviceName: 'HamaGuard',
        notificationCount: 5,
        onNotificationTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationScreen()),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Thermal Sensor Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
              shadowColor: Colors.green.withOpacity(0.2),
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.thermostat_outlined,
                            color: Color.fromRGBO(56, 142, 60, 1), size: 30),
                        SizedBox(width: 12),
                        Text(
                          'Thermal Sensor',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color.fromRGBO(56, 142, 60, 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ThermalHeatmap(temperatures: thermalData),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sensor Cards row (PIR & Ultrasonik)
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    title: 'PIR',
                    value: sensorData['PIR'] ?? '-',
                    icon: Icons.motion_photos_on_outlined,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SensorCard(
                    title: 'Jarak',
                    value: sensorData['Ultrasonik'] ?? '-',
                    icon: Icons.straighten,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Status Pengusir
            SensorCard(
              title: 'Status Pengusir',
              value: sensorData['Status Pengusir'] ?? '-',
              icon: Icons.speaker,
              color: Colors.green.shade700,
              isWide: true,
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
  final bool isWide;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2, // shadow tipis
      shadowColor: color.withOpacity(0.1), // lebih transparan
      color: Colors.white,
      child: Container(
        width: isWide ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
