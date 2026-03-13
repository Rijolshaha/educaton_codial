class DashboardModel {
  final UserProfile user;
  final LevelInfo level;
  final CoinInfo coins;
  final RankInfo rank;
  final NewsInfo news;
  final StatsInfo stats;
  final List<CoinOpportunity> coinOpportunities;
  final List<RewardItem> latestRewards;
  final List<GroupItem> groups;

  DashboardModel({
    required this.user,
    required this.level,
    required this.coins,
    required this.rank,
    required this.news,
    required this.stats,
    required this.coinOpportunities,
    required this.latestRewards,
    required this.groups,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      user: UserProfile.fromJson(json['user'] ?? {}),
      level: LevelInfo.fromJson(json['level'] ?? {}),
      coins: CoinInfo.fromJson(json['coins'] ?? {}),
      rank: RankInfo.fromJson(json['rank'] ?? {}),
      news: NewsInfo.fromJson(json['news'] ?? {}),
      stats: StatsInfo.fromJson(json['stats'] ?? {}),
      coinOpportunities: (json['coinOpportunities'] as List<dynamic>? ?? [])
          .map((e) => CoinOpportunity.fromJson(e))
          .toList(),
      latestRewards: (json['latestRewards'] as List<dynamic>? ?? [])
          .map((e) => RewardItem.fromJson(e))
          .toList(),
      groups: (json['groups'] as List<dynamic>? ?? [])
          .map((e) => GroupItem.fromJson(e))
          .toList(),
    );
  }

  // 🧪 MOCK DATA — used when API is not connected
  static DashboardModel mock() {
    return DashboardModel(
      user: UserProfile(name: 'Hasanali Turdaliyev'),
      level: LevelInfo(
        title: 'Beginner',
        level: 1,
        progressPercent: 0.68,
        coinsLeft: 1550,
      ),
      coins: CoinInfo(total: 3250, coinsForNextLevel: 1550),
      rank: RankInfo(position: 1, isUp: true),
      news: NewsInfo(unreadCount: 5),
      stats: StatsInfo(lessons: 12, books: 8, activityPercent: 94, groups: 1),
      coinOpportunities: [
        CoinOpportunity(
          icon: 'book',
          title: 'Vazifa topshirish',
          value: '0-100 coin',
          color: 0xFFE8F4FF,
          iconColor: 0xFF2D7BFF,
        ),
        CoinOpportunity(
          icon: 'lightning',
          title: 'Faollik',
          value: '+30 coin',
          color: 0xFFFFF8E1,
          iconColor: 0xFFFFC107,
        ),
        CoinOpportunity(
          icon: 'bookopen',
          title: 'Kitob tahlili',
          value: '+100 coin',
          color: 0xFFE8F5E9,
          iconColor: 0xFF4CAF50,
        ),
        CoinOpportunity(
          icon: 'target',
          title: 'Darsga qatnashish',
          value: '+50 coin',
          color: 0xFFF3E5F5,
          iconColor: 0xFF9C27B0,
        ),
      ],
      latestRewards: [
        RewardItem(title: 'Dars bahosi', date: '2026-02-10', coins: 420),
        RewardItem(title: 'Yanvar oyi imtihoni', date: '2026-01-31', coins: 525),
        RewardItem(title: 'Dars bahosi', date: '2026-02-07', coins: 338),
      ],
      groups: [
        GroupItem(
          name: 'Backend 36',
          teacher: 'Otabek Tursunov',
          schedule: 'Dush-Chor-Juma',
        ),
      ],
    );
  }
}

class UserProfile {
  final String name;
  UserProfile({required this.name});
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      UserProfile(name: json['name'] ?? '');
}

class LevelInfo {
  final String title;
  final int level;
  final double progressPercent;
  final int coinsLeft;
  LevelInfo({
    required this.title,
    required this.level,
    required this.progressPercent,
    required this.coinsLeft,
  });
  factory LevelInfo.fromJson(Map<String, dynamic> json) => LevelInfo(
        title: json['title'] ?? 'Beginner',
        level: json['level'] ?? 1,
        progressPercent: (json['progressPercent'] ?? 0.68).toDouble(),
        coinsLeft: json['coinsLeft'] ?? 0,
      );
}

class CoinInfo {
  final int total;
  final int coinsForNextLevel;
  CoinInfo({required this.total, required this.coinsForNextLevel});
  factory CoinInfo.fromJson(Map<String, dynamic> json) => CoinInfo(
        total: json['total'] ?? 0,
        coinsForNextLevel: json['coinsForNextLevel'] ?? 0,
      );
}

class RankInfo {
  final int position;
  final bool isUp;
  RankInfo({required this.position, required this.isUp});
  factory RankInfo.fromJson(Map<String, dynamic> json) => RankInfo(
        position: json['position'] ?? 1,
        isUp: json['isUp'] ?? true,
      );
}

class NewsInfo {
  final int unreadCount;
  NewsInfo({required this.unreadCount});
  factory NewsInfo.fromJson(Map<String, dynamic> json) =>
      NewsInfo(unreadCount: json['unreadCount'] ?? 0);
}

class StatsInfo {
  final int lessons;
  final int books;
  final int activityPercent;
  final int groups;
  StatsInfo({
    required this.lessons,
    required this.books,
    required this.activityPercent,
    required this.groups,
  });
  factory StatsInfo.fromJson(Map<String, dynamic> json) => StatsInfo(
        lessons: json['lessons'] ?? 0,
        books: json['books'] ?? 0,
        activityPercent: json['activityPercent'] ?? 0,
        groups: json['groups'] ?? 0,
      );
}

class CoinOpportunity {
  final String icon;
  final String title;
  final String value;
  final int color;
  final int iconColor;
  CoinOpportunity({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.iconColor,
  });
  factory CoinOpportunity.fromJson(Map<String, dynamic> json) =>
      CoinOpportunity(
        icon: json['icon'] ?? 'book',
        title: json['title'] ?? '',
        value: json['value'] ?? '',
        color: json['color'] ?? 0xFFE8F4FF,
        iconColor: json['iconColor'] ?? 0xFF2D7BFF,
      );
}

class RewardItem {
  final String title;
  final String date;
  final int coins;
  RewardItem({required this.title, required this.date, required this.coins});
  factory RewardItem.fromJson(Map<String, dynamic> json) => RewardItem(
        title: json['title'] ?? '',
        date: json['date'] ?? '',
        coins: json['coins'] ?? 0,
      );
}

class GroupItem {
  final String name;
  final String teacher;
  final String schedule;
  GroupItem({
    required this.name,
    required this.teacher,
    required this.schedule,
  });
  factory GroupItem.fromJson(Map<String, dynamic> json) => GroupItem(
        name: json['name'] ?? '',
        teacher: json['teacher'] ?? '',
        schedule: json['schedule'] ?? '',
      );
}
