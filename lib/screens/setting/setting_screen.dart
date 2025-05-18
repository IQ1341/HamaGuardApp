import 'package:flutter/material.dart';
import '../../widgets/costum_header.dart';
import '../../screens/notification/notification_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
            MaterialPageRoute(
              builder: (context) => NotificationScreen(),
            ),
          );
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              secondary: const Icon(Icons.notifications_active_outlined),
              title: const Text('Notifikasi'),
              value: true,
              onChanged: (val) {
                // Tambahkan logika notifikasi di sini jika dibutuhkan
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          'Aplikasi monitoring dan pengusir hama otomatis berbasis sensor.'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
