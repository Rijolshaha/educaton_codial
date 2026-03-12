import 'package:flutter/material.dart';

class GuruhStatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const GuruhStatChip({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color),
          ),
        ],
      ),
    );
  }
}