import 'package:flutter/material.dart';
import '../../../models/dashboard_model.dart';
import '../../constants/app_colors.dart';
import '../../services/student_service.dart';
import '../../services/config/app_theme.dart';
import '../../widgets/students/dashboard/coin_opportunities.dart';
import '../../widgets/students/dashboard/coins_card.dart';
import '../../widgets/students/dashboard/latest_rewards.dart';
import '../../widgets/students/dashboard/level_card.dart';
import '../../widgets/students/dashboard/my_groups.dart';
import '../../widgets/students/dashboard/news_banner.dart';
import '../../widgets/students/dashboard/quick_actions.dart';
import '../../widgets/students/dashboard/rank_card.dart';
import '../../widgets/students/dashboard/stats_grid.dart';
import '../notifications_page.dart';
import 'student_profile_page.dart';

class HomePage extends StatefulWidget {
  /// 0=Home 1=Reyting 2=Kitoblar 3=Auksion
  final void Function(int index)? onNavigate;
  final void Function()? onOpenProfile;

  const HomePage({super.key, this.onNavigate, this.onOpenProfile});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<DashboardModel> _dashboardFuture;
  final _service = StudentService();

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _service.fetchDashboard();
  }

  void _refresh() {
    setState(() => _dashboardFuture = _service.fetchDashboard());
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsPage()),
    );
  }

  Future<void> _openProfile() async {
    if (widget.onOpenProfile != null) {
      widget.onOpenProfile!();
      return;
    }
    final profile = await _service.fetchProfile();
    if (!mounted || profile == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentProfilePage(student: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: FutureBuilder<DashboardModel>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.blue1),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text('Xatolik yuz berdi',
                        style: AppTextStyles.sectionTitle),
                    TextButton(
                      onPressed: _refresh,
                      child: const Text('Qayta urinish'),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data ?? DashboardModel.mock();
            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              color: AppColors.blue1,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildGreeting(data.user),
                        const SizedBox(height: 20),
                        LevelCard(level: data.level),
                        const SizedBox(height: 14),
                        CoinsCard(coins: data.coins),
                        const SizedBox(height: 14),
                        RankCard(
                          rank: data.rank,
                          onRatingTap: () => widget.onNavigate?.call(1),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _openNotifications,
                          child: NewsBanner(news: data.news),
                        ),
                        const SizedBox(height: 20),
                        StatsGrid(stats: data.stats),
                        const SizedBox(height: 20),
                        CoinOpportunitiesSection(
                          opportunities: data.coinOpportunities,
                        ),
                        const SizedBox(height: 20),
                        LatestRewards(rewards: data.latestRewards),
                        const SizedBox(height: 20),
                        MyGroups(groups: data.groups),
                        const SizedBox(height: 20),
                        QuickActions(
                          onKitoblarTap: () => widget.onNavigate?.call(2),
                          onReytingTap: () => widget.onNavigate?.call(1),
                          onProfilTap: _openProfile,
                        ),
                        const SizedBox(height: 32),
                      ]),
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

  Widget _buildGreeting(UserProfile user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Salom, ${user.name}! 👋', style: AppTextStyles.greeting),
        const SizedBox(height: 6),
        const Text(
          "Bugungi natijalaringiz va rivojlanish ko'rsatkichlari",
          style: AppTextStyles.subtitle,
        ),
      ],
    );
  }
}
