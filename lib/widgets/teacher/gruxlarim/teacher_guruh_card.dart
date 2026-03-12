import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/teacher_model.dart';

class TeacherGuruhCard extends StatelessWidget {
  final TeacherGroup guruh;
  final VoidCallback onShowStudents;

  const TeacherGuruhCard({
    super.key,
    required this.guruh,
    required this.onShowStudents,
  });

  // Schedule → kunlar
  bool get _isJadvalA => guruh.schedule.contains('Dushanba');

  Color get _scheduleColor =>
      _isJadvalA ? AppColors.primary : const Color(0xFFD97706);

  String get _kunlarShort =>
      _isJadvalA ? 'Du-Ch-Ju' : 'Se-Pa-Sh';

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
            left: BorderSide(color: AppColors.primary, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // ── Top row: icon + name + student count ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.dns_outlined,
                      color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guruh.name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 12,
                            color: _scheduleColor),
                        const SizedBox(width: 4),
                        Text(
                          _kunlarShort,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _scheduleColor),
                        ),
                      ]),
                    ],
                  ),
                ),
                // Student count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people_outline_rounded,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        '${guruh.students.length} ta',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 12),

            // ── Stats row ──
            Row(children: [
              Expanded(
                child: _StatItem(
                  icon: '🪙',
                  label: 'Jami coin',
                  value: _fmt(guruh.totalCoins),
                  color: AppColors.orange,
                ),
              ),
              Container(
                  width: 1, height: 36,
                  color: const Color(0xFFF3F4F6)),
              Expanded(
                child: _StatItem(
                  icon: '📊',
                  label: "O'rtacha",
                  value: _fmt(guruh.avgCoins),
                  color: const Color(0xFF059669),
                ),
              ),
              Container(
                  width: 1, height: 36,
                  color: const Color(0xFFF3F4F6)),
              Expanded(
                child: _StatItem(
                  icon: '🏆',
                  label: 'Top coin',
                  value: guruh.students.isEmpty
                      ? '0'
                      : _fmt(guruh.topStudents.first.totalCoins),
                  color: const Color(0xFFFFB800),
                ),
              ),
            ]),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 12),

            // ── Schedule full row ──
            Row(children: [
              const Icon(Icons.schedule_outlined,
                  size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  guruh.schedule,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ]),
            const SizedBox(height: 10),

            // ── O'quvchilarni ko'rish button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onShowStudents,
                icon: const Icon(Icons.groups_outlined,
                    size: 18, color: Colors.white),
                label: const Text(
                  "O'quvchilarni ko'rish",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                  const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stat Item ────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color),
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}