import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class AdminStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final double growth;

  const AdminStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.growth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Row(
                children: [
                  const Icon(Icons.trending_up_rounded,
                      color: AppColors.green, size: 16),
                  const SizedBox(width: 3),
                  Text('+${growth.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              )),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              )),
        ],
      ),
    );
  }
}