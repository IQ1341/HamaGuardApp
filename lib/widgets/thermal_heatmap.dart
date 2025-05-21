import 'package:flutter/material.dart';

class ThermalHeatmap extends StatelessWidget {
  final List<double> temperatures;

  const ThermalHeatmap({super.key, required this.temperatures});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 310,
        height: 310,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color.fromRGBO(56, 142, 60, 1).withOpacity(0.6),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(56, 142, 60, 1).withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(
              painter: _ThermalPainter(temperatures),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThermalPainter extends CustomPainter {
  final List<double> temps;

  _ThermalPainter(this.temps);

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / 8;
    final cellHeight = size.height / 8;

    final blurPaint = Paint()
      ..isAntiAlias = true
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        int i = y * 8 + x;
        double temp = i < temps.length ? temps[i] : 0.0;
        final color = _getColorForTemp(temp);

        final rect = Rect.fromLTWH(
          x * cellWidth,
          y * cellHeight,
          cellWidth,
          cellHeight,
        );

        canvas.drawRect(rect, blurPaint..color = color.withOpacity(0.95));
      }
    }

    // Garis putih di tengah dihilangkan (dihapus)
  }

Color _getColorForTemp(double t) {
    if (t <= 20) {
      return Colors.blue;
    } else if (t <= 25) {
      double ratio = (t - 20) / 5;
      return Color.lerp(Colors.blue, Colors.green, ratio)!;
    } else if (t <= 28) {
      double ratio = (t - 25) / 3;
      return Color.lerp(Colors.green, Colors.yellow, ratio)!;
    } else if (t < 30) {
      double ratio = (t - 28) / 2;
      return Color.lerp(Colors.yellow, Colors.red, ratio)!;
    } else {
      return Colors.red;
    }
  }


  @override
  bool shouldRepaint(covariant _ThermalPainter oldDelegate) {
    if (oldDelegate.temps.length != temps.length) return true;
    for (int i = 0; i < temps.length; i++) {
      if (oldDelegate.temps[i] != temps[i]) return true;
    }
    return false;
  }
}
