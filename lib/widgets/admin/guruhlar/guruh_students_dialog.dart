import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/guruh_model.dart';
import '../../../../models/student_model.dart';

class GuruhStudentsDialog extends StatelessWidget {
  final AdminGuruh guruh;
  final List<StudentModel> students;

  const GuruhStudentsDialog({
    super.key,
    required this.guruh,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    final kursColor = guruhKursColor(guruh.kurs);

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      insetPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: kursColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(guruhKursIcon(guruh.kurs),
                        color: kursColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guruh.nomi,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                        ),
                        Text(
                          guruh.ustoz,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  // Count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: kursColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${students.length} ta",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kursColor),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded,
                        size: 20, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFF3F4F6)),

            // ── Students list ──
            Expanded(
              child: students.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_off_outlined,
                        size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    const Text(
                      "Bu guruhda o'quvchi yo'q",
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                itemCount: students.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
                itemBuilder: (_, i) => _StudentTile(
                    student: students[i], rank: i + 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Student Tile ─────────────────────────────────────────────────────────────

class _StudentTile extends StatelessWidget {
  final StudentModel student;
  final int rank;

  const _StudentTile({required this.student, required this.rank});

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  Color _hexColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _hexColor(student.avatarColor);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 28,
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: rank <= 3
                    ? AppColors.orange
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),

          // Avatar
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: avatarColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(student.avatarEmoji,
                  style: const TextStyle(fontSize: 18)),
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
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                Text(
                  student.email,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // Coins
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 3),
                  Text(
                    _fmt(student.coins),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.orange),
                  ),
                ],
              ),
              Text(
                '+${student.gain}',
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF059669),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}