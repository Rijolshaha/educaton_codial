import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../models/owner_model.dart';

class OwnerAdminTile extends StatelessWidget {
  final OwnerAdmin admin;

  const OwnerAdminTile({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(admin.avatarEmoji,
                  style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),

          // Name + email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  admin.ism,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  admin.email,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: admin.isFaol
                  ? const Color(0xFFD1FAE5)
                  : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              admin.isFaol ? 'Faol' : 'Nofaol',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: admin.isFaol
                      ? const Color(0xFF059669)
                      : AppColors.red),
            ),
          ),
        ],
      ),
    );
  }
}