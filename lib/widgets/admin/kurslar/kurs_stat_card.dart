import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class KursStatCard extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;
  final Color color;

  const KursStatCard({
    super.key,
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary),
              ),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}