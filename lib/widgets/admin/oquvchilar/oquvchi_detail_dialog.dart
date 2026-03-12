import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/student_model.dart';
import '../../../models/oquvchi_admin_model.dart';

class OquvchiDetailDialog extends StatelessWidget {
  final StudentModel student;

  const OquvchiDetailDialog({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final avatarColor = oquvchiAvatarColor(student.avatarColor);
    final groupColor  = oquvchiGroupColor(student.group);
    final ustoz = guruhUstozMap[student.group] ?? '—';

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      insetPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Gradient header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  groupColor,
                  groupColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '#${student.rank} O\'rin',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    color: avatarColor.withOpacity(0.25),
                    shape: BoxShape.circle,
                    border:
                    Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: Text(student.avatarEmoji,
                        style: const TextStyle(fontSize: 34)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  student.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  student.email,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13),
                ),
              ],
            ),
          ),

          // ── Info ──
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.groups_2_outlined,
                  label: 'Guruh',
                  value: student.group,
                  valueColor: groupColor,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.school_outlined,
                  label: 'Ustoz',
                  value: ustoz,
                ),
                const SizedBox(height: 16),
                // Coins row
                Row(children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Coinlar',
                      value: oquvchiFormatCoins(student.coins),
                      icon: '🪙',
                      color: AppColors.orange,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniStat(
                      label: '+Gain',
                      value: '+${student.gain}',
                      icon: '📈',
                      color: const Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniStat(
                      label: "O'rin",
                      value: '#${student.rank}',
                      icon: '🏆',
                      color: rankColor(student.rank),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon,
              size: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary)),
            Text(
              value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color:
                  valueColor ?? AppColors.textPrimary),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color),
          ),
          Text(
            label,
            style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}