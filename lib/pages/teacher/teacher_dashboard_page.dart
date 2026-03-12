import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/teacher_model.dart';
import '../../../widgets/teacher/dashboard/teacher_stat_card.dart';
import '../../../widgets/teacher/dashboard/teacher_group_card.dart';
import '../../../widgets/teacher/dashboard/top_students_list.dart';

class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({super.key});

  static final _teacher = TeacherModel.mock();

  @override
  Widget build(BuildContext context) {
    final teacher = _teacher;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            // ── Greeting ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Salom, ${teacher.name}! 👋',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Guruhlaringiz va o'quvchilaringiz statistikasi",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Stat cards ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    TeacherStatCard(
                      label: 'Guruhlar',
                      value: '${teacher.groups.length}',
                      icon: Icons.groups_2_outlined,
                      iconColor: AppColors.blue1,
                      iconBg: AppColors.blue1.withOpacity(0.1),
                    ),
                    const SizedBox(height: 12),
                    TeacherStatCard(
                      label: "O'quvchilar",
                      value: '${teacher.totalStudents}',
                      icon: Icons.people_outline_rounded,
                      iconColor: AppColors.green,
                      iconBg: AppColors.green.withOpacity(0.1),
                    ),
                    const SizedBox(height: 12),
                    TeacherStatCard(
                      label: "O'rtacha coin",
                      value: _fmt(teacher.avgCoins),
                      icon: Icons.emoji_events_outlined,
                      iconColor: AppColors.orange,
                      iconBg: AppColors.orange.withOpacity(0.1),
                    ),
                    const SizedBox(height: 12),
                    TeacherStatCard(
                      label: 'Jami coinlar',
                      value: _fmt(teacher.totalCoins),
                      icon: Icons.trending_up_rounded,
                      iconColor: AppColors.purple,
                      iconBg: AppColors.purple.withOpacity(0.1),
                    ),
                  ],
                ),
              ),
            ),

            // ── Mening guruhlarim ─────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 14),
                child: Text(
                  'Mening guruhlarim',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (ctx, i) => TeacherGroupCard(group: teacher.groups[i]),
                  childCount: teacher.groups.length,
                ),
              ),
            ),

            // ── Top o'quvchilar ───────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                child: Text(
                  "Top o'quvchilar",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TopStudentsList(students: teacher.topStudents),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
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