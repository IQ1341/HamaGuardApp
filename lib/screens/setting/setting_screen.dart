import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pengaturan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Contoh opsi 1: Ganti mode manual/otomatis
          ListTile(
            leading: const Icon(Icons.toggle_on),
            title: const Text('Mode Manual/Otomatis'),
            trailing: Switch(
              value: true, // sementara default ON, nanti bisa dihubungkan state nyata
              onChanged: (val) {
              },
            ),
          ),

          const Divider(),

          // Contoh opsi 2: Notifikasi aktif/nonaktif
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifikasi'),
            trailing: Switch(
              value: true,
              onChanged: (val) {
            
              },
            ),
          ),

          const Divider(),

          // Contoh opsi 3: Reset data (tombol)
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Reset Data'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data direset')),
              );
            },
          ),

          const Divider(),

          // Contoh opsi 4: Tentang aplikasi
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang'),
            subtitle: const Text('Versi 1.0.0\nDibuat oleh Tim HamaGuard'),
            isThreeLine: true,
            onTap: () {
              // Bisa tampilkan dialog info lebih lengkap
              showAboutDialog(
                context: context,
                applicationName: 'HamaGuard',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.bug_report, size: 40),
                children: const [
                  Text('Aplikasi pendeteksi dan pengusir hama otomatis.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
