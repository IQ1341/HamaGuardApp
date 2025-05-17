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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green),
            SizedBox(width: 8),
            Text('Berhasil'),
          ],
        ),
        content: const Text(
          'Pengusir hama berhasil diaktifkan secara manual.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Tutup',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const CustomHeader(
        deviceName: 'HamaGuard',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Mode Operasi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      isAutoMode ? Icons.autorenew : Icons.handyman,
                      color: isAutoMode ? Colors.blue : Colors.orange,
                      size: 36,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAutoMode ? 'Mode Otomatis' : 'Mode Manual',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAutoMode
                                ? 'Alat akan bekerja secara otomatis sesuai sensor'
                                : 'Kamu dapat mengaktifkan alat secara manual',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isAutoMode,
                      onChanged: (_) => toggleMode(),
                      activeColor: Colors.green,
                    ),
                  ],
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
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
