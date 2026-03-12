import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/ustoz_model.dart';

class UstozCard extends StatelessWidget {
  final UstozModel ustoz;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UstozCard({
    super.key,
    required this.ustoz,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final kursColor = ustozKursColor(ustoz.kurs);
    final avatarColor = ustozAvatarColor(ustoz.avatarColor);
    final isFaol = ustoz.status == UstozStatus.faol;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: kursColor, width: 4)),
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
            // ── Top: avatar + name + status ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: avatarColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      ustoz.avatarEmoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Name + role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ustoz.ism,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Text(
                        'Ustoz',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isFaol
                        ? const Color(0xFFD1FAE5)
                        : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ustoz.statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isFaol
                          ? const Color(0xFF059669)
                          : AppColors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 10),

            // ── Info grid ──
            Row(children: [
              Expanded(
                child: _InfoItem(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: ustoz.email,
                ),
              ),
              Expanded(
                child: _InfoItem(
                  icon: ustozKursIcon(ustoz.kurs),
                  label: 'Kurs',
                  value: ustoz.kurs,
                  valueColor: kursColor,
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: _InfoItem(
                  icon: Icons.groups_2_outlined,
                  label: 'Guruhlar',
                  value: '${ustoz.guruhlarSoni} ta',
                  valueColor: AppColors.primary,
                ),
              ),
              Expanded(
                child: _InfoItem(
                  icon: Icons.people_outline_rounded,
                  label: "O'quvchilar",
                  value: '${ustoz.oquvchilarSoni} ta',
                  valueColor: AppColors.greenDark,
                ),
              ),
            ]),

            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 10),

            // ── Action buttons ──
            Row(children: [
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

// ─── Info Item ────────────────────────────────────────────────────────────────

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────

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
              Text(
                label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}