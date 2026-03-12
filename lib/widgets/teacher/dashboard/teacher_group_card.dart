import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/teacher_model.dart';

class TeacherGroupCard extends StatelessWidget {
  final TeacherGroup group;
  final VoidCallback? onTap;

  const TeacherGroupCard({super.key, required this.group, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
            // ── Group name + student count ───────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.blue1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${group.students.length} ta',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // ── Schedule ─────────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined,
                    size: 14, color: AppColors.blue1),
                const SizedBox(width: 5),
                Text(
                  group.schedule,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.blue1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 14),

            // ── Coins stats ──────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Jami coinlar',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(
                        _fmt(group.totalCoins),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("O'rtacha",
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(
                        _fmt(group.avgCoins),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Top students avatars ─────────────────────────────
            const Text("Top o'quvchilar:",
                style: TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            _TopAvatars(students: group.topStudents),
          ],
        ),
      ),
    );
  }

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

// ─── Top avatars row ──────────────────────────────────────────────────────────

class _TopAvatars extends StatelessWidget {
  final List<TeacherStudent> students;
  const _TopAvatars({required this.students});

  @override
  Widget build(BuildContext context) {
    const maxVisible = 4;
    final visible = students.take(maxVisible).toList();
    final extra = students.length - maxVisible;

    return Row(
      children: [
        ...visible.map((s) => Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(s.avatarEmoji,
                  style: const TextStyle(fontSize: 18)),
            ),
          ),
        )),
        if (extra > 0)
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.blue1.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text('+$extra',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue1,
                  )),
            ),
          ),
      ],
    );
  }
}