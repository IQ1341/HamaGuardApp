import 'package:flutter/material.dart';

class ThermalHeatmap extends StatelessWidget {
  final List<double> temperatures;

  const ThermalHeatmap({super.key, required this.temperatures});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: CustomPaint(
          painter: _ThermalPainter(temperatures),
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

    final center = Offset(size.width / 2, size.height / 2);
    final plusPaint = Paint()
      ..color = Colors.white.withOpacity(0.95)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center - const Offset(10, 0), center + const Offset(10, 0), plusPaint);
    canvas.drawLine(center - const Offset(0, 10), center + const Offset(0, 10), plusPaint);
  }

  Color _getColorForTemp(double t) {
    double norm = ((t - 20) / 20).clamp(0.0, 1.0);
    return HSVColor.lerp(
      HSVColor.fromColor(Colors.blue),
      HSVColor.fromColor(Colors.red),
      norm,
    )!
        .toColor();
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
