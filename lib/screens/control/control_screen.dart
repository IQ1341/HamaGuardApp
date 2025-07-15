import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../widgets/costum_header.dart';
import '../notification/notification_screen.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  final _db = FirebaseDatabase.instance.ref();

  bool isAutoMode = true;
  bool isRepellerOn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchControlStatus();
  }

  // Ambil data dari Firebase
  void fetchControlStatus() async {
    final snapshot = await _db.child('control').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        isAutoMode = (data['mode'] ?? 'auto') == 'auto';
        isRepellerOn = (data['repeller'] ?? false) == true;
        isLoading = false;
      });
    } else {
      // Jika data tidak ada, tetap tampi
    }
  }

  void toggleMode() {
    setState(() {
      isAutoMode = !isAutoMode;
      if (isAutoMode) {
        isRepellerOn = false;
      }
    });

    _db.child('control').update({
      'mode': isAutoMode ? 'auto' : 'manual',
      'repeller': isAutoMode ? false : isRepellerOn,
    });
  }

  void toggleRepeller() {
    setState(() {
      isRepellerOn = !isRepellerOn;
    });

    _db.child('control').update({
      'repeller': isRepellerOn,
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isRepellerOn ? Icons.check_circle : Icons.power_settings_new,
              color: isRepellerOn ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(isRepellerOn ? 'Diaktifkan' : 'Dimatikan'),
          ],
        ),
        content: Text(
          isRepellerOn
              ? 'Pengusir hama berhasil diaktifkan.'
              : 'Pengusir hama dimatikan.',
          style: const TextStyle(fontSize: 16),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Kartu mode
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: isAutoMode
                        ? Colors.blue.shade50
                        : Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                isAutoMode ? Colors.blue : Colors.orange,
                            radius: 28,
                            child: Icon(
                              isAutoMode
                                  ? Icons.autorenew
                                  : Icons.handyman,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isAutoMode
                                      ? 'Mode Otomatis'
                                      : 'Mode Manual',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isAutoMode
                                        ? Colors.blue
                                        : Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  isAutoMode
                                      ? 'Alat akan aktif otomatis sesuai sensor.'
                                      : 'Kamu dapat mengendalikan alat secara manual.',
                                  style: const TextStyle(
                                      color: Colors.black87),
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

                  const SizedBox(height: 20),

                  // Status repeller manual
                  if (!isAutoMode)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: isRepellerOn
                          ? Colors.green.shade50
                          : Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(
                              isRepellerOn
                                  ? Icons.volume_up_rounded
                                  : Icons.volume_off_rounded,
                              color: isRepellerOn
                                  ? Colors.green
                                  : Colors.grey,
                              size: 32,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                isRepellerOn
                                    ? 'Pengusir aktif secara manual.'
                                    : 'Pengusir dalam keadaan mati.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isRepellerOn
                                      ? Colors.green.shade700
                                      : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Tombol kontrol manual
                  if (!isAutoMode)
                    ElevatedButton.icon(
                      onPressed: toggleRepeller,
                      icon: Icon(
                        isRepellerOn
                            ? Icons.power_settings_new_rounded
                            : Icons.volume_up_rounded,
                      ),
                      label: Text(
                        isRepellerOn
                            ? 'Matikan Pengusir'
                            : 'Aktifkan Pengusir Sekarang',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRepellerOn
                            ? Colors.grey.shade700
                            : Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
