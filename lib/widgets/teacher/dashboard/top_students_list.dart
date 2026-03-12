import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/teacher_model.dart';

class TopStudentsList extends StatelessWidget {
  final List<TeacherStudent> students;
  const TopStudentsList({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: students.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          return Column(
            children: [
              if (i > 0)
                const Divider(height: 1, color: Color(0xFFF3F4F6),
                    indent: 16, endIndent: 16),
              _StudentRow(student: s, rank: i + 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final TeacherStudent student;
  final int rank;
  const _StudentRow({required this.student, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Rank badge
          _RankBadge(rank: rank),
          const SizedBox(width: 12),

          // Avatar
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(student.avatarEmoji,
                  style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),

          // Name + group
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  student.groupName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Coins
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _fmt(student.totalCoins),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text('coin',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  )),
            ],
          ),
        ],
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

// ─── Rank Badge ───────────────────────────────────────────────────────────────

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  static const _colors = {
    1: Color(0xFFFFD700),
    2: Color(0xFFC0C0C0),
    3: Color(0xFFCD7F32),
  };

  @override
  Widget build(BuildContext context) {
    final bgColor = _colors[rank] ?? const Color(0xFFE5E7EB);
    final textColor = rank <= 3
        ? (rank == 1 ? const Color(0xFF92400E) : Colors.white)
        : AppColors.textSecondary;

    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '#$rank',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
      ),
    );
  }
}