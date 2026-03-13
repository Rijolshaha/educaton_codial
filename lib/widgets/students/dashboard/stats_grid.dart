import 'package:flutter/material.dart';
import '../../../models/dashboard_model.dart'; // FIX: 4 ta ../ → 3 ta ../
import '../../../constants/app_colors.dart';

class StatsGrid extends StatelessWidget {
  final StatsInfo stats;
  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(
        value: '${stats.lessons}',
        label: 'Darslar',
        icon: Icons.track_changes,
        iconColor: const Color(0xFF4CAF50),
        iconBg: const Color(0xFFE8F5E9),
      ),
      _StatItem(
        value: '${stats.books}',
        label: 'Kitoblar',
        icon: Icons.menu_book_outlined,
        iconColor: const Color(0xFF2D7BFF),
        iconBg: const Color(0xFFE8F4FF),
      ),
      _StatItem(
        value: '${stats.activityPercent}%',
        label: 'Faollik',
        icon: Icons.emoji_events_outlined,
        iconColor: const Color(0xFFF44336),
        iconBg: const Color(0xFFFFEBEE),
      ),
      _StatItem(
        value: '${stats.groups}',
        label: 'Guruhlar',
        icon: Icons.calendar_month_outlined,
        iconColor: const Color(0xFF9C27B0),
        iconBg: const Color(0xFFF3E5F5),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: items.map((item) => _buildStatCard(item)).toList(),
    );
  }

  Widget _buildStatCard(_StatItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });
}