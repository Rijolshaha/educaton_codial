import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/dashboard_model.dart';

class RankCard extends StatelessWidget {
  final RankInfo rank;
  const RankCard({super.key, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sizning o'rningiz",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '#${rank.position}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      rank.isUp ? Icons.trending_up : Icons.trending_down,
                      color: rank.isUp ? AppColors.green : Colors.red,
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "To'liq reyting →",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.blue1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('🏅', style: TextStyle(fontSize: 26)),
            ),
          ),
        ],
      ),
    );
  }
}
