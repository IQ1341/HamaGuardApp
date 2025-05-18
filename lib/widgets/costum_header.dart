import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  final String deviceName;
  final VoidCallback? onNotificationTap;
  final int notificationCount; // Tambahan

  const CustomHeader({
    super.key,
    required this.deviceName,
    this.onNotificationTap,
    this.notificationCount = 0,
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
    ticker = Stream.periodic(const Duration(minutes: 1)).listen((_) {
      if (mounted) _updateDate();
    });
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
          // Nama alat dan tanggal
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
                    color: Color.fromRGBO(56, 142, 60, 1),
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

          // Icon lonceng + badge notifikasi
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Material(
              color: const Color.fromARGB(255, 219, 230, 221),
              shape: const CircleBorder(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    icon: const Icon(Icons.notifications_none,
                        color: Color.fromARGB(221, 57, 35, 35), size: 28),
                    onPressed: widget.onNotificationTap ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Notifikasi belum tersedia')),
                          );
                        },
                    splashRadius: 24,
                  ),

                  // Badge jika notificationCount > 0
                  if (widget.notificationCount > 0)
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
                          widget.notificationCount > 99
                              ? '99+'
                              : '${widget.notificationCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
