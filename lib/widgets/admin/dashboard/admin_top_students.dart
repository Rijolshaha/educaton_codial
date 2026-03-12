import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/student_model.dart';

class AdminTopStudents extends StatelessWidget {
  final List<StudentModel> students;
  const AdminTopStudents({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: students.asMap().entries.map((e) {
        final i = e.key;
        final s = e.value;
        return Column(
          children: [
            if (i > 0)
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
            _StudentRow(student: s, rank: i + 1),
          ],
        );
      }).toList(),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final StudentModel student;
  final int rank;
  const _StudentRow({required this.student, required this.rank});

  static Color _hex(String hex) =>
      Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));

  static const _rankColors = {
    1: Color(0xFFFFD700),
    2: Color(0xFFE5E7EB),
    3: Color(0xFFFF9800),
  };

  @override
  Widget build(BuildContext context) {
    final rankBg = _rankColors[rank] ?? const Color(0xFFE5E7EB);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: rankBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: rank <= 3
                      ? (rank == 1
                      ? const Color(0xFF92400E)
                      : Colors.white)
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Avatar
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: _hex(student.avatarColor),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(student.avatarEmoji,
                  style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),

          // Name + group
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                Text(student.group,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    )),
              ],
            ),
          ),

          // Coins
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${student.coins}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  )),
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
}