import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/student_model.dart';
import '../../../models/oquvchi_admin_model.dart';

class OquvchiCard extends StatelessWidget {
  final StudentModel student;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OquvchiCard({
    super.key,
    required this.student,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final avatarColor = oquvchiAvatarColor(student.avatarColor);
    final groupColor  = oquvchiGroupColor(student.group);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: groupColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ── Top row ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: avatarColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(student.avatarEmoji,
                        style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 10),

                // Name + email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary),
                      ),
                      Text(
                        student.email,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Rank badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: rankBgColor(student.rank),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🏆',
                          style: TextStyle(fontSize: 11)),
                      const SizedBox(width: 3),
                      Text(
                        '#${student.rank}',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: rankColor(student.rank)),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 10),

            // ── Info row ──
            Row(children: [
              // Guruh chip
              Expanded(
                child: Row(children: [
                  Icon(Icons.groups_2_outlined,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Guruh',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 1),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: groupColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            student.group,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: groupColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),

              // Coins
              Expanded(
                child: Row(children: [
                  const Text('🪙',
                      style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Coinlar',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary)),
                      const SizedBox(height: 1),
                      Text(
                        oquvchiFormatCoins(student.coins),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.orange),
                      ),
                    ],
                  ),
                ]),
              ),

              // Gain
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('+gain',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 1),
                  Text(
                    '+${student.gain}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF059669)),
                  ),
                ],
              ),
            ]),

            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 10),

            // ── Action buttons ──
            Row(children: [
              Expanded(
                child: _ActionBtn(
                  icon: Icons.visibility_outlined,
                  label: "Ko'rish",
                  color: const Color(0xFF059669),
                  bgColor: const Color(0xFFD1FAE5),
                  onTap: onView,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionBtn(
                  icon: Icons.edit_outlined,
                  label: 'Tahrirlash',
                  color: AppColors.primary,
                  bgColor: const Color(0xFFEEF2FF),
                  onTap: onEdit,
                ),
              ),
              const SizedBox(width: 8),
              _ActionBtn(
                icon: Icons.delete_outline_rounded,
                label: '',
                color: AppColors.red,
                bgColor: const Color(0xFFFEE2E2),
                onTap: onDelete,
                compact: true,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;
  final bool compact;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 9, horizontal: compact ? 14 : 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            if (!compact && label.isNotEmpty) ...[
              const SizedBox(width: 5),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ],
          ],
        ),
      ),
    );
  }
}