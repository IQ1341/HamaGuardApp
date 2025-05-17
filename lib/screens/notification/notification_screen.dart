import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      "title": "Peringatan!",
      "message": "Hama terdeteksi di area sawah A.",
      "time": "16 Mei 2025 - 10:15"
    },
    {
      "title": "Status Aman",
      "message": "Tidak ada aktivitas hama selama 2 jam terakhir.",
      "time": "16 Mei 2025 - 09:00"
    },
    {
      "title": "Mode Otomatis Aktif",
      "message": "Sistem kembali ke mode otomatis.",
      "time": "15 Mei 2025 - 17:20"
    },
  ];

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada notifikasi',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blue),
                  title: Text(
                    notif["title"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(notif["message"]!),
                  trailing: Text(
                    notif["time"]!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              },
            ),
    );
  }
}
