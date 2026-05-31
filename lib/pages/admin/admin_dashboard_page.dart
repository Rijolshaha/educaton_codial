import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/admin_model.dart';
import '../../../services/admin_service.dart';
import '../../../widgets/admin/dashboard/admin_stat_card.dart';
import '../../../widgets/admin/dashboard/admin_bar_chart.dart';
import '../../../widgets/admin/dashboard/admin_line_chart.dart';
import '../../../widgets/admin/dashboard/admin_top_students.dart';
import '../../../widgets/admin/dashboard/admin_group_list.dart';
import '../../../widgets/admin/dashboard/admin_chart_card.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late Future<AdminDashboardModel> _future;

  @override
  void initState() {
    super.initState();
    _future = AdminService().fetchDashboard();
  }

  void _refresh() => setState(() => _future = AdminService().fetchDashboard());

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
        child: FutureBuilder<AdminDashboardModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            final d = snapshot.data ?? AdminDashboardModel.mock();
            final stats = d.stats;

            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
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

                  // Stat cards
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        AdminStatCard(
                          icon: Icons.person_outline_rounded,
                          iconColor: AppColors.blue1,
                          iconBg: const Color(0xFFE8F4FF),
                          label: "Jami o'quvchilar",
                          value: '${stats.totalStudents}',
                          growth: stats.studentGrowth,
                        ),
                        const SizedBox(height: 14),
                        AdminStatCard(
                          icon: Icons.school_outlined,
                          iconColor: AppColors.green,
                          iconBg: const Color(0xFFE8F5E9),
                          label: 'Jami ustozlar',
                          value: '${stats.totalTeachers}',
                          growth: stats.teacherGrowth,
                        ),
                        const SizedBox(height: 14),
                        AdminStatCard(
                          icon: Icons.groups_2_outlined,
                          iconColor: AppColors.orange,
                          iconBg: const Color(0xFFFFF3E0),
                          label: 'Faol guruhlar',
                          value: '${stats.activeGroups}',
                          growth: stats.groupGrowth,
                        ),
                        const SizedBox(height: 14),
                        AdminStatCard(
                          icon: Icons.monetization_on_outlined,
                          iconColor: AppColors.purple,
                          iconBg: const Color(0xFFF3E5F5),
                          label: 'Tarqatilgan coinlar',
                          value: _fmt(stats.totalCoins),
                          growth: stats.coinGrowth,
                        ),
                      ]),
                    ),
                  ),

                  // Bar chart
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: AdminChartCard(
                        title: "Guruhlar bo'yicha coinlar",
                        child: AdminBarChart(data: d.groupBarData),
                      ),
                    ),
                  ),

                  // Line chart: haftalik
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: AdminChartCard(
                        title: 'Haftalik tendensiya',
                        child: AdminLineChart(
                          data: d.weekTrendData,
                          labels: d.weekTrendLabels,
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                  ),

                  // Davomat
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: AdminChartCard(
                        title: 'Kunlik Davomat (Oxirgi 14 kun)',
                        subtitle:
                            "O'quvchilarning darsga qatnashish dinamikasi",
                        headerExtra: Row(
                          children: [
                            AdminMiniStat(
                              value: '${d.ortachaDavomat}%',
                              label: "O'rtacha davomat",
                              color: AppColors.green,
                            ),
                            const SizedBox(width: 24),
                            AdminMiniStat(
                              value: '${d.bugunQatnashdi}',
                              label: 'Bugun qatnashdi',
                              color: AppColors.blue1,
                            ),
                          ],
                        ),
                        child: AdminLineChart(
                          data: d.attendanceData,
                          labels: d.attendanceLabels,
                          color: AppColors.green,
                          filled: true,
                        ),
                      ),
                    ),
                  ),

                  // Top 5
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: AdminSectionCard(
                        icon: Icons.emoji_events_outlined,
                        iconColor: AppColors.coinGold,
                        title: "Top 5 O'quvchilar",
                        child: d.topStudents.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: Text(
                                    "Ma'lumot topilmadi",
                                    style: TextStyle(
                                        color: AppColors.textSecondary),
                                  ),
                                ),
                              )
                            : AdminTopStudents(students: d.topStudents),
                      ),
                    ),
                  ),

                  // Eng faol guruhlar
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    sliver: SliverToBoxAdapter(
                      child: AdminSectionCard(
                        icon: Icons.groups_2_outlined,
                        iconColor: AppColors.blue1,
                        title: 'Eng faol guruhlar',
                        child: d.topGroups.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: Text(
                                    "Ma'lumot topilmadi",
                                    style: TextStyle(
                                        color: AppColors.textSecondary),
                                  ),
                                ),
                              )
                            : AdminGroupList(groups: d.topGroups),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
