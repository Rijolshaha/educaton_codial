import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class KursMiniStat extends StatelessWidget {
  final int count;
  final String label;

  const KursMiniStat({
    super.key,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}