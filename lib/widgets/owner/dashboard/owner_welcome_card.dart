import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../models/owner_model.dart';

class OwnerWelcomeCard extends StatelessWidget {
  final OwnerModel owner;

  const OwnerWelcomeCard({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Xush kelibsiz, Ega!',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            "Platforma to'liq nazorat ostida. Barcha tizim funktsiyalari bilan ishlashingiz mumkin.",
            style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
                height: 1.4),
          ),
          const SizedBox(height: 20),

          // 2×2 mini stats
          Row(children: [
            Expanded(
              child: _MiniStat(
                  label: 'Adminlar',
                  value: '${owner.welcomeAdminlar}'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MiniStat(
                  label: 'Kurslar',
                  value: '${owner.welcomeKurslar}'),
            ),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: _MiniStat(
                  label: "O'qituvchilar",
                  value: '${owner.welcomeOqituvchilar}'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MiniStat(
                  label: "O'quvchilar",
                  value: '${owner.welcomeOquvchilar}'),
            ),
          ]),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}