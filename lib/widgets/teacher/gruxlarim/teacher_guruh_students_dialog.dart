import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/teacher_model.dart';

class TeacherGuruhStudentsDialog extends StatelessWidget {
  final TeacherGroup guruh;

  const TeacherGuruhStudentsDialog({
    super.key,
    required this.guruh,
  });

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
    // Sort students by coins descending
    final students = List<TeacherStudent>.from(guruh.students)
      ..sort((a, b) => b.totalCoins.compareTo(a.totalCoins));

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
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.dns_outlined,
                        color: AppColors.primary, size: 22),
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
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                        ),
                        Text(
                          "${students.length} ta o'quvchi",
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  // Avg coins badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🪙',
                            style: TextStyle(fontSize: 11)),
                        const SizedBox(width: 3),
                        Text(
                          _fmt(guruh.avgCoins),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.orange),
                        ),
                      ],
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
                        size: 48,
                        color: Colors.grey.shade300),
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
                    student: students[i],
                    rank: i + 1,
                    fmtFn: _fmt),
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
  final TeacherStudent student;
  final int rank;
  final String Function(int) fmtFn;

  const _StudentTile({
    required this.student,
    required this.rank,
    required this.fmtFn,
  });

  Color _rankColor() {
    if (rank == 1) return const Color(0xFFFFB800);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 10),
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
              '#$rank',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: _rankColor()),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),

          // Avatar
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(student.avatarEmoji,
                  style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 10),

          // Name
          Expanded(
            child: Text(
              student.name,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
          ),

          // Coins
          Row(
            children: [
              const Text('🪙',
                  style: TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text(
                fmtFn(student.totalCoins),
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }
}