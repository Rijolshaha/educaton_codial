import 'package:educaton_codial/pages/student/home_page/widgets/moch_ontap.dart';
import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/dashboard_model.dart';
import '../services/api_service.dart';
import '../widgets/coin_opportunities.dart';
import '../widgets/coins_card.dart';
import '../widgets/latest_rewards.dart';
import '../widgets/level_card.dart';
import '../widgets/my_groups.dart';
import '../widgets/news_banner.dart';
import '../widgets/quick_actions.dart';
import '../widgets/rank_card.dart';
import '../widgets/stats_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<DashboardModel> _dashboardFuture;

  // 🔧 Toggle: set to false to use live API
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: FutureBuilder<DashboardModel>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
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
                        child: const Text('Qayta urinish')),
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

                        // Card A: Level
                        LevelCard(level: data.level),
                        const SizedBox(height: 14),

                        // Card B: Coins
                        CoinsCard(coins: data.coins),
                        const SizedBox(height: 14),

                        // Card C: Rank
                        RankCard(rank: data.rank),
                        const SizedBox(height: 20),

                        // News Banner
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MochOntap()));
                            },
                            child: NewsBanner(news: data.news)),
                        const SizedBox(height: 20),

                        // Stats Grid
                        StatsGrid(stats: data.stats),
                        const SizedBox(height: 20),

                        // Coin Opportunities
                        CoinOpportunitiesSection(
                          opportunities: data.coinOpportunities,
                        ),
                        const SizedBox(height: 20),

                        // Latest Rewards
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MochOntap()));
                            },
                            child: LatestRewards(rewards: data.latestRewards)),
                        const SizedBox(height: 20),

                        // My Groups
                        MyGroups(groups: data.groups),
                        const SizedBox(height: 20),

                        // Quick Actions
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MochOntap()));
                            },
                            child: const QuickActions()),
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
        Text(
          'Salom, ${user.name}! 👋',
          style: AppTextStyles.greeting,
        ),
        const SizedBox(height: 6),
        const Text(
          "Bugungi natijalaringiz va rivojlanish ko'rsatkichlari",
          style: AppTextStyles.subtitle,
        ),
      ],
    );
  }
}
