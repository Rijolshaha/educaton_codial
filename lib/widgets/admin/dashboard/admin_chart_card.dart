import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

/// Umumiy chart wrapper — title, subtitle, headerExtra va child
class AdminChartCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? headerExtra;
  final Widget child;

  const AdminChartCard({
    super.key,
    required this.title,
    this.subtitle,
    this.headerExtra,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
          Text(title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              )),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ],
          if (headerExtra != null) ...[
            const SizedBox(height: 12),
            headerExtra!,
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Umumiy section wrapper — icon, title, child
class AdminSectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const AdminSectionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  )),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

/// Kichik raqam ko'rsatkich (attendance card uchun)
class AdminMiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const AdminMiniStat({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: color,
            )),
        Text(label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            )),
      ],
    );
  }
}