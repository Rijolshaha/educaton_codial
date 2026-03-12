import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/admin_model.dart';
import '../../../models/student_model.dart';
import '../../../widgets/admin/dashboard/admin_stat_card.dart';
import '../../../widgets/admin/dashboard/admin_bar_chart.dart';
import '../../../widgets/admin/dashboard/admin_line_chart.dart';
import '../../../widgets/admin/dashboard/admin_top_students.dart';
import '../../../widgets/admin/dashboard/admin_group_list.dart';
import '../../../widgets/admin/dashboard/admin_chart_card.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  static const _stats = AdminStats.mock;

  static String _fmt(int n) {
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
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            // ── Header ──────────────────────────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin Dashboard',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        )),
                    SizedBox(height: 4),
                    Text('Umumiy statistika va tahlil',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        )),
                  ],
                ),
              ),
            ),

            // ── Stat cards ───────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  AdminStatCard(
                    icon: Icons.person_outline_rounded,
                    iconColor: AppColors.blue1,
                    iconBg: const Color(0xFFE8F4FF),
                    label: "Jami o'quvchilar",
                    value: '${_stats.totalStudents}',
                    growth: _stats.studentGrowth,
                  ),
                  const SizedBox(height: 14),
                  AdminStatCard(
                    icon: Icons.school_outlined,
                    iconColor: AppColors.green,
                    iconBg: const Color(0xFFE8F5E9),
                    label: 'Jami ustozlar',
                    value: '${_stats.totalTeachers}',
                    growth: _stats.teacherGrowth,
                  ),
                  const SizedBox(height: 14),
                  AdminStatCard(
                    icon: Icons.groups_2_outlined,
                    iconColor: AppColors.orange,
                    iconBg: const Color(0xFFFFF3E0),
                    label: 'Faol guruhlar',
                    value: '${_stats.activeGroups}',
                    growth: _stats.groupGrowth,
                  ),
                  const SizedBox(height: 14),
                  AdminStatCard(
                    icon: Icons.monetization_on_outlined,
                    iconColor: AppColors.purple,
                    iconBg: const Color(0xFFF3E5F5),
                    label: 'Tarqatilgan coinlar',
                    value: _fmt(_stats.totalCoins),
                    growth: _stats.coinGrowth,
                  ),
                ]),
              ),
            ),

            // ── Bar chart: Guruhlar bo'yicha coinlar ─────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: AdminChartCard(
                  title: "Guruhlar bo'yicha coinlar",
                  child: AdminBarChart(data: groupBarData),
                ),
              ),
            ),

            // ── Line chart: Haftalik tendensiya ──────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: AdminChartCard(
                  title: 'Haftalik tendensiya',
                  child: AdminLineChart(
                    data: weekTrendData,
                    labels: weekTrendLabels,
                    color: AppColors.orange,
                  ),
                ),
              ),
            ),

            // ── Area chart: Kunlik Davomat ────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: AdminChartCard(
                  title: 'Kunlik Davomat (Oxirgi 14 kun)',
                  subtitle: "O'quvchilarning darsga qatnashish dinamikasi",
                  headerExtra: const Row(
                    children: [
                      AdminMiniStat(
                        value: '89%',
                        label: "O'rtacha davomat",
                        color: AppColors.green,
                      ),
                      SizedBox(width: 24),
                      AdminMiniStat(
                        value: '47',
                        label: 'Bugun qatnashdi',
                        color: AppColors.blue1,
                      ),
                    ],
                  ),
                  child: AdminLineChart(
                    data: attendanceData,
                    labels: attendanceLabels,
                    color: AppColors.green,
                    filled: true,
                  ),
                ),
              ),
            ),

            // ── Top 5 o'quvchilar ─────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: AdminSectionCard(
                  icon: Icons.emoji_events_outlined,
                  iconColor: AppColors.coinGold,
                  title: "Top 5 O'quvchilar",
                  child: AdminTopStudents(
                    students: studentsHaftalik.take(5).toList(),
                  ),
                ),
              ),
            ),

            // ── Eng faol guruhlar ─────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              sliver: SliverToBoxAdapter(
                child: AdminSectionCard(
                  icon: Icons.groups_2_outlined,
                  iconColor: AppColors.blue1,
                  title: 'Eng faol guruhlar',
                  child: AdminGroupList(groups: groupsHaftalik),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}