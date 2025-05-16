import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  final String deviceName;
  final VoidCallback? onNotificationTap;

  const CustomHeader({
    super.key,
    required this.deviceName,
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 24);

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  late String _dateString;
  late final ticker;

  @override
  void initState() {
    super.initState();
    _updateDate();
    // Update setiap hari (atau bisa sesuaikan interval jika perlu)
    ticker = Stream.periodic(const Duration(minutes: 1)).listen((_) {
      if (mounted) {
        _updateDate();
      }
    });
  }

  void _updateDate() {
    final now = DateTime.now();
    // Format hanya tanggal: Contoh "Fri, 16 May 2025"
    final formatted = DateFormat('EEE, dd MMM yyyy').format(now);
    setState(() {
      _dateString = formatted;
    });
  }

  @override
  void dispose() {
    ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Nama alat dan tanggal di kiri
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.deviceName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _dateString,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Lonceng dalam lingkaran abu-abu lembut
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Material(
              color: Colors.grey.shade200,
              shape: const CircleBorder(),
              child: IconButton(
                padding: const EdgeInsets.all(8),
                icon: const Icon(Icons.notifications_none, color: Colors.black87, size: 28),
                onPressed: widget.onNotificationTap ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifikasi belum tersedia')),
                      );
                    },
                splashRadius: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
