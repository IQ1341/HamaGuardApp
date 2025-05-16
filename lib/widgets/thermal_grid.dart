import 'package:flutter/material.dart';

class ThermalGrid extends StatelessWidget {
  final List<double> temperatures;

  const ThermalGrid({super.key, required this.temperatures});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 64,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: (context, index) {
          final temp = temperatures[index];
          final color = getColorForTemperature(temp);

          return Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        },
      ),
    );
  }

  Color getColorForTemperature(double temp) {
    if (temp < 26) return Colors.blue[200]!;
    if (temp < 28) return Colors.lightBlue;
    if (temp < 30) return Colors.green;
    if (temp < 32) return Colors.yellow;
    if (temp < 34) return Colors.orange;
    return Colors.red;
  }
}
