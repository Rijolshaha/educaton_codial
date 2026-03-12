import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/teacher_model.dart';
import '../../widgets/teacher/gruxlarim/teacher_guruh_card.dart';
import '../../widgets/teacher/gruxlarim/teacher_guruh_students_dialog.dart';

class TeacherGuruhlarimPage extends StatelessWidget {
  // Hozircha mock — keyinchalik API dan olinadi
  final TeacherModel teacher;

  const TeacherGuruhlarimPage({
    super.key,
    required this.teacher,
  });

  void _showStudents(BuildContext context, TeacherGroup guruh) {
    showDialog(
      context: context,
      builder: (_) =>
          TeacherGuruhStudentsDialog(guruh: guruh),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = teacher.groups;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded,
              color: Color(0xFF111827)),
        ),
        title: const Text(
          'Guruhlarim',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827)),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child:
          Divider(height: 1, color: Color(0xFFF3F4F6)),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Subtitle ──
                  Text(
                    "Salom, ${teacher.name.split(' ').first}! 👋",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${groups.length} ta guruhingiz mavjud",
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),

                  // ── Summary stats ──
                  Row(children: [
                    _SummaryChip(
                      icon: Icons.groups_2_outlined,
                      label: 'Guruhlar',
                      value: '${groups.length}',
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    _SummaryChip(
                      icon: Icons.people_outline_rounded,
                      label: "O'quvchilar",
                      value: '${teacher.totalStudents}',
                      color: const Color(0xFF059669),
                    ),
                    const SizedBox(width: 10),
                    _SummaryChip(
                      icon: Icons.trending_up_rounded,
                      label: "O'rtacha",
                      value: '${teacher.avgCoins}',
                      color: AppColors.orange,
                    ),
                  ]),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Group cards ──
          groups.isEmpty
              ? SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(children: [
                Icon(Icons.groups_2_outlined,
                    size: 52,
                    color: Colors.grey.shade300),
                const SizedBox(height: 12),
                const Text(
                  'Guruhlar topilmadi',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14),
                ),
              ]),
            ),
          )
              : SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                16, 0, 16, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (_, i) => TeacherGuruhCard(
                  guruh: groups[i],
                  onShowStudents: () =>
                      _showStudents(context, groups[i]),
                ),
                childCount: groups.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(
              child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ─── Summary Chip ─────────────────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: color),
            ),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}