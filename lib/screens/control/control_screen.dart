import 'package:flutter/material.dart';
import '../../widgets/costum_header.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool isAutoMode = true; // default: mode otomatis

  void toggleMode() {
    setState(() {
      isAutoMode = !isAutoMode;
    });
  }

  void triggerRepeller() {
    // fungsi sementara, nanti bisa dihubungkan ke backend/ESP32
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengusir diaktifkan secara manual!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(
        deviceName: 'HamaGuard', // ini wajib diisi
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Mode Operasi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(
                  isAutoMode ? Icons.autorenew : Icons.handyman,
                  color: isAutoMode ? Colors.blue : Colors.orange,
                ),
                title: Text(
                  isAutoMode ? 'Otomatis' : 'Manual',
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: const Text('Mode saat ini'),
                trailing: ElevatedButton(
                  onPressed: toggleMode,
                  child: Text(
                    isAutoMode ? 'Ganti ke Manual' : 'Ganti ke Otomatis',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (!isAutoMode)
              ElevatedButton.icon(
                onPressed: triggerRepeller,
                icon: const Icon(Icons.volume_up),
                label: const Text('Aktifkan Pengusir Sekarang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
