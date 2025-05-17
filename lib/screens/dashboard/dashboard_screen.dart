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
    'PIR': 'Memuat...',
    'Ultrasonik': 'Memuat...',
    'Status Pengusir': 'Memuat...',
  };

  List<double> thermalData = List.filled(64, 0.0);

  @override
  void initState() {
    super.initState();

    _sensorRef = FirebaseDatabase.instance.ref('sensor');
    _thermalRef = FirebaseDatabase.instance.ref('thermal/temperatures');

    // Listener sensor data
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

    // Listener thermal data
    _thermalRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        // Firebase RTDB terkadang mengirim List<dynamic> atau Map<dynamic,dynamic>
        List<double> temps = [];
        if (data is List) {
          temps = data.map<double>((e) {
            if (e is num) return e.toDouble();
            return 0.0;
          }).toList();
        } else if (data is Map) {
          // Jika data disimpan sebagai Map index:string -> value
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Thermal Sensor
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
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
                          'Thermal Sensor',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ThermalHeatmap(temperatures: thermalData),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // PIR & Ultrasonik
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    title: 'PIR',
                    value: sensorData['PIR'] ?? '-',
                    icon: Icons.motion_photos_on_outlined,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SensorCard(
                    title: 'Ultrasonik',
                    value: sensorData['Ultrasonik'] ?? '-',
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
              value: sensorData['Status Pengusir'] ?? '-',
              icon: Icons.speaker,
              color: Colors.green,
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
          backgroundColor: color.withAlpha(15),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
