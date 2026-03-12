import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/guruh_model.dart';
import 'guruh_info_item.dart';
import 'guruh_card_btn.dart';

class GuruhCard extends StatelessWidget {
  final AdminGuruh guruh;
  final VoidCallback onShowStudents;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GuruhCard({
    super.key,
    required this.guruh,
    required this.onShowStudents,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isFaol    = guruh.status == GuruhStatus.faol;
    final isJadvalA = guruh.jadval == JadvalTuri.jadvalA;
    final kursColor = guruhKursColor(guruh.kurs);

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
              offset: const Offset(0, 2)),
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
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: kursColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(guruhKursIcon(guruh.kurs),
                      color: kursColor, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guruh.nomi,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary),
                      ),
                      Text(
                        guruh.yaratilganSana,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary),
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
                    guruh.statusLabel,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isFaol
                            ? const Color(0xFF059669)
                            : AppColors.red),
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
                child: GuruhInfoItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Ustoz',
                  value: guruh.ustoz,
                ),
              ),
              Expanded(
                child: GuruhInfoItem(
                  icon: guruhKursIcon(guruh.kurs),
                  label: 'Kurs',
                  value: guruh.kurs,
                  valueColor: kursColor,
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: GuruhInfoItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Jadval',
                  value: '${guruh.jadvalLabel} · ${guruh.jadvalKunlar}',
                  valueColor: isJadvalA
                      ? AppColors.primary
                      : const Color(0xFFD97706),
                ),
              ),
              Expanded(
                child: GuruhInfoItem(
                  icon: Icons.people_outline_rounded,
                  label: "O'quvchilar",
                  value: '${guruh.oquvchilar} ta',
                ),
              ),
            ]),

            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 10),

            // ── Action buttons ──
            Row(children: [
              Expanded(
                child: GuruhCardBtn(
                  icon: Icons.groups_outlined,
                  label: "O'quvchilar",
                  color: const Color(0xFF059669),
                  bgColor: const Color(0xFFD1FAE5),
                  onTap: onShowStudents,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GuruhCardBtn(
                  icon: Icons.edit_outlined,
                  label: 'Tahrirlash',
                  color: AppColors.primary,
                  bgColor: const Color(0xFFEEF2FF),
                  onTap: onEdit,
                ),
              ),
              const SizedBox(width: 8),
              GuruhCardBtn(
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