import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/costum_header.dart';
import '../notification/notification_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double threshold = 0.0;
  double calibration = 0.0;

  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref('pengaturan/device1');

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final snapshot = await dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        threshold = (data['threshold'] ?? 0).toDouble();
        calibration = (data['calibration'] ?? 0).toDouble();
      });
    }
  }

  Future<void> _saveToDatabase(String key, double value) async {
    await dbRef.update({key: value});
  }

  void _showInputDialog({
    required String title,
    required double initialValue,
    required Function(double) onSave,
  }) {
    final controller = TextEditingController(text: initialValue.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Masukkan nilai',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null) {
                onSave(value);
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login', // Pastikan ini sudah ada di main.dart
      (route) => false, // Menghapus semua route sebelumnya
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomHeader(
        deviceName: "HamaGuard",
        isDashboard: true,
        onNotificationTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationScreen()),
          );

        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Threshold
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.tune),
              title: const Text('Atur Threshold'),
              subtitle: Text('Nilai saat ini: $threshold'),
              onTap: () {
                _showInputDialog(
                  title: 'Atur Threshold',
                  initialValue: threshold,
                  onSave: (val) {
                    setState(() => threshold = val);
                    _saveToDatabase('threshold', val);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Tentang Aplikasi
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Aplikasi'),
              subtitle: const Text('Versi 1.0.0'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'HamaGuard',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.bug_report, size: 40),
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        'Aplikasi monitoring dan pengusir hama otomatis berbasis sensor.',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Tombol Logout
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Keluar',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Apakah kamu yakin ingin keluar?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _logout();
                        },
                        child: const Text('Keluar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
