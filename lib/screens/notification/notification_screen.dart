import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      "type": "warning",
      "title": "Peringatan!",
      "message": "Hama terdeteksi di area sawah A.",
      "time": "16 Mei 2025 - 10:15"
    },
    {
      "type": "safe",
      "title": "Status Aman",
      "message": "Tidak ada aktivitas hama selama 2 jam terakhir.",
      "time": "16 Mei 2025 - 09:00"
    },
    {
      "type": "info",
      "title": "Mode Otomatis Aktif",
      "message": "Sistem kembali ke mode otomatis.",
      "time": "15 Mei 2025 - 17:20"
    },
  ];

  NotificationScreen({super.key});

  Color _getColor(String type) {
    switch (type) {
      case 'warning':
        return Colors.red.shade100;
      case 'safe':
        return Colors.green.shade100;
      case 'info':
      default:
        return Colors.blue.shade100;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'safe':
        return Icons.check_circle_outline;
      case 'info':
      default:
        return Icons.info_outline;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'warning':
        return Colors.red;
      case 'safe':
        return Colors.green;
      case 'info':
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada notifikasi',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                final type = notif["type"] ?? "info";

                return Card(
                  color: _getColor(type),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    leading: Icon(
                      _getIcon(type),
                      color: _getIconColor(type),
                      size: 32,
                    ),
                    title: Text(
                      notif["title"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          notif["message"]!,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notif["time"]!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
