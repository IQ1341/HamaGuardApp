import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  final String deviceName;
  final VoidCallback? onNotificationTap;
  final bool isDashboard; // parameter baru untuk cek halaman dashboard

  const CustomHeader({
    super.key,
    required this.deviceName,
    this.onNotificationTap,
    this.isDashboard = false, // default false
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  late String _dateString;
  int _notificationCount = 0;
  StreamSubscription<QuerySnapshot>? _notifSubscription;
  late final StreamSubscription<void> _ticker;

  @override
  void initState() {
    super.initState();
    _updateDate();

    // Update tanggal setiap menit
    _ticker = Stream.periodic(const Duration(minutes: 1)).listen((_) {
      if (mounted) _updateDate();
    });

    // Jika di halaman dashboard, listen notifikasi Firestore
    if (widget.isDashboard) {
      _notifSubscription = FirebaseFirestore.instance
          .collection('notifications')
          .snapshots()
          .listen((snapshot) {
        if (!mounted) return;
        setState(() {
          _notificationCount = snapshot.docs.length;
        });
      });
    }
  }

  void _updateDate() {
    final now = DateTime.now();
    final formatted = DateFormat('EEE, dd MMM yyyy').format(now);
    setState(() {
      _dateString = formatted;
    });
  }

  @override
  void dispose() {
    _notifSubscription?.cancel();
    _ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      child: Container(
        color: Colors.green[700],
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        child: SafeArea(
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nama alat dan tanggal
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.deviceName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _dateString,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Tampilkan ikon tergantung isDashboard
              if (widget.isDashboard)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Material(
                      color: Colors.green[600],
                      shape: const CircleBorder(),
                      child: IconButton(
                        padding: const EdgeInsets.all(8),
                        icon: const Icon(Icons.notifications_none,
                            color: Colors.white, size: 28),
                        onPressed: widget.onNotificationTap ??
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Notifikasi belum tersedia')),
                              );
                            },
                        splashRadius: 24,
                      ),
                    ),
                    if (_notificationCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: const BoxConstraints(minWidth: 16),
                          child: Text(
                            _notificationCount > 99
                                ? '99+'
                                : '$_notificationCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              else
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fungsi setting belum tersedia')),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
