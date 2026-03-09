import 'package:flutter/material.dart';

class TileWidget extends StatelessWidget {
  final int value;

  const TileWidget({super.key, required this.value});

  Color getColor() {
    switch (value) {
      case 2:
        return Colors.grey.shade300;
      case 4:
        return Colors.orange.shade200;
      case 8:
        return Colors.orange.shade400;
      case 16:
        return Colors.deepOrange.shade300;
      case 32:
        return Colors.deepOrange;
      case 64:
        return Colors.deepOrange.shade700;
      case 128:
        return Colors.amber.shade400;
      case 256:
        return Colors.amber.shade600;
      case 512:
        return Colors.amber.shade800;
      case 1024:
        return Colors.yellow.shade700;
      case 2048:
        return Colors.yellow.shade600;
      default:
        return Colors.brown.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      /// animation duration
      duration: const Duration(milliseconds: 200),

      margin: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: getColor(),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Center(
        child: Text(
          value == 0 ? "" : "$value",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}