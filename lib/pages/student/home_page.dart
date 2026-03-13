import 'package:flutter/material.dart';
import '../../../models/dashboard_model.dart';
import '../../constants/app_colors.dart';
import '../../services/api_service.dart';
import '../../services/config/app_theme.dart' hide AppColors;
import '../../widgets/students/dashboard/coin_opportunities.dart';
import '../../widgets/students/dashboard/coins_card.dart';
import '../../widgets/students/dashboard/latest_rewards.dart';
import '../../widgets/students/dashboard/level_card.dart';
import '../../widgets/students/dashboard/moch_ontap.dart';
import '../../widgets/students/dashboard/my_groups.dart';
import '../../widgets/students/dashboard/news_banner.dart';
import '../../widgets/students/dashboard/quick_actions.dart';
import '../../widgets/students/dashboard/rank_card.dart';
import '../../widgets/students/dashboard/stats_grid.dart';
import '../news_page.dart';
import 'student_profile_page.dart';
import '../../models/student_model.dart';

class HomePage extends StatefulWidget {
  /// 0=Home 1=Reyting 2=Kitoblar 3=Auksion
  final void Function(int index)? onNavigate;

  const HomePage({super.key, this.onNavigate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<DashboardModel> _dashboardFuture;
  static const bool USE_MOCK = true;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = ApiService().fetchDashboard(useMock: USE_MOCK);
  }

  void _refresh() {
    setState(() {
      _dashboardFuture = ApiService().fetchDashboard(useMock: USE_MOCK);
    });
  }

  // NewsPage ga Navigator.push bilan o'tish
  void _openNews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewsPage()),
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

            final data = snapshot.data!;
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

                        // Greeting
                        _buildGreeting(data.user),
                        const SizedBox(height: 20),

                        // Level card
                        LevelCard(level: data.level),
                        const SizedBox(height: 14),

                        // Coins card
                        CoinsCard(coins: data.coins),
                        const SizedBox(height: 14),

                        // Rank card
                        RankCard(
                          rank: data.rank,
                          onRatingTap: () => widget.onNavigate?.call(1),
                        ),
                        const SizedBox(height: 20),

                        // ── Ko'k "Yangi xabarlar" banner → NewsPage ──
                        GestureDetector(
                          onTap: _openNews,
                          child: NewsBanner(
                            news: data.news, onTap: () {  },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Stats grid
                        StatsGrid(stats: data.stats),
                        const SizedBox(height: 20),

                        // Coin opportunities
                        CoinOpportunitiesSection(
                          opportunities: data.coinOpportunities,
                        ),
                        const SizedBox(height: 20),

                        // Latest rewards
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => MochOntap())),
                          child: LatestRewards(rewards: data.latestRewards),
                        ),
                        const SizedBox(height: 20),

                        // My groups
                        MyGroups(groups: data.groups),
                        const SizedBox(height: 20),

                        // Quick actions
                        QuickActions(
                          onKitoblarTap: () => widget.onNavigate?.call(2),
                          onReytingTap: () => widget.onNavigate?.call(1),
                          onProfilTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentProfilePage(
                                student: studentsHaftalik[4],
                              ),
                            ),
                          ),
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