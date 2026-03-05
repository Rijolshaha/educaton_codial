import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/student_model.dart';
import '../../widgets/students/reyting/coin_text.dart';
import '../../widgets/students/reyting/rank_badge.dart';
import '../../widgets/students/reyting/student_avatar.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  String _tab    = 'oquvchilar'; // 'oquvchilar' | 'guruhlar'
  String _period = 'haftalik';   // 'haftalik' | 'oylik' | 'umumiy'

  List<StudentModel> get _students => getStudents(_period);
  List<GroupModel>   get _groups   => getGroups(_period);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    children: const [
                      Text('🏆', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reyting',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            "Eng yaxshi o'quvchilar va guruhlar",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecond,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // O'quvchilar / Guruhlar tab
                  _buildMainTabs(),
                  const SizedBox(height: 12),

                  // Haftalik / Oylik / Umumiy
                  _buildPeriodFilter(),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // ── Body ────────────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _tab == 'oquvchilar'
                    ? _StudentList(
                  key: ValueKey('s$_period'),
                  students: _students,
                )
                    : _GroupList(
                  key: ValueKey('g$_period'),
                  groups: _groups,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main tab toggle ────────────────────────────────────────────────────────
  Widget _buildMainTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _tabItem('oquvchilar', "O'quvchilar"),
          _tabItem('guruhlar',   'Guruhlar'),
        ],
      ),
    );
  }

  Widget _tabItem(String key, String label) {
    final active = _tab == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = key),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: active ? AppColors.white : AppColors.textSecond,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Period filter ──────────────────────────────────────────────────────────
  Widget _buildPeriodFilter() {
    return Row(
      children: [
        _periodItem('haftalik', 'Haftalik'),
        const SizedBox(width: 8),
        _periodItem('oylik',    'Oylik'),
        const SizedBox(width: 8),
        _periodItem('umumiy',   'Umumiy'),
      ],
    );
  }

  Widget _periodItem(String key, String label) {
    final active = _period == key;
    return GestureDetector(
      onTap: () => setState(() => _period = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: active
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: active ? AppColors.white : AppColors.textSecond,
          ),
        ),
      ),
    );
  }
}

// ─── Student List ─────────────────────────────────────────────────────────────
class _StudentList extends StatelessWidget {
  final List<StudentModel> students;

  const _StudentList({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: students.length + 1, // +1 for podium
      itemBuilder: (ctx, i) {
        if (i == 0) {
          return _Podium(students: students.take(3).toList());
        }
        final student = students[i - 1];
        if (student.rank <= 3) return const SizedBox.shrink();
        return _StudentRow(student: student);
      },
    );
  }
}

// ─── Podium ───────────────────────────────────────────────────────────────────
class _Podium extends StatelessWidget {
  final List<StudentModel> students;

  const _Podium({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    if (students.length < 3) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // #2
          Expanded(
            child: _PodiumItem(
              student: students[1],
              podiumHeight: 60,
              avatarSize: 56,
              topIcon: '🥈',
              badgeColor: AppColors.silver,
              rankLabel: '#2',
              rankLabelColor: AppColors.white,
            ),
          ),
          // #1
          Expanded(
            child: _PodiumItem(
              student: students[0],
              podiumHeight: 80,
              avatarSize: 68,
              topIcon: '👑',
              badgeColor: AppColors.gold,
              rankLabel: '#1',
              rankLabelColor: const Color(0xFF92400E),
              isFirst: true,
            ),
          ),
          // #3
          Expanded(
            child: _PodiumItem(
              student: students[2],
              podiumHeight: 45,
              avatarSize: 50,
              topIcon: '🥉',
              badgeColor: AppColors.bronze,
              rankLabel: '#3',
              rankLabelColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final StudentModel student;
  final double podiumHeight;
  final double avatarSize;
  final String topIcon;
  final Color badgeColor;
  final String rankLabel;
  final Color rankLabelColor;
  final bool isFirst;

  const _PodiumItem({
    required this.student,
    required this.podiumHeight,
    required this.avatarSize,
    required this.topIcon,
    required this.badgeColor,
    required this.rankLabel,
    required this.rankLabelColor,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final parts = student.name.split(' ');
    final displayName =
    parts.length >= 2 ? '${parts[0]}\n${parts[1]}' : student.name;

    return Column(
      children: [
        // Crown / medal icon
        Text(topIcon, style: TextStyle(fontSize: isFirst ? 24 : 20)),
        const SizedBox(height: 4),

        // Avatar
        StudentAvatar(
          student: student,
          size: avatarSize,
          border: Border.all(color: badgeColor, width: 3),
        ),
        const SizedBox(height: 8),

        // Name
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),

        // Coins badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _fmt(student.coins),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Podium block
        Container(
          width: double.infinity,
          height: podiumHeight,
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              rankLabel,
              style: TextStyle(
                color: rankLabelColor,
                fontWeight: FontWeight.w900,
                fontSize: isFirst ? 26 : 20,
              ),
            ),
          ),
        ),
      ],
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

// ─── Student Row ──────────────────────────────────────────────────────────────
class _StudentRow extends StatelessWidget {
  final StudentModel student;

  const _StudentRow({required this.student});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push → StudentProfilePage
        // Navigator.push(context, MaterialPageRoute(
        //   builder: (_) => StudentProfilePage(student: student),
        // ));
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            // Rank
            RankBadge(rank: student.rank),
            const SizedBox(width: 10),

            // Avatar
            StudentAvatar(student: student),
            const SizedBox(width: 12),

            // Name + group
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    student.group,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecond,
                    ),
                  ),
                ],
              ),
            ),

            // Coins + gain
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CoinText(coins: student.coins),
                const SizedBox(height: 3),
                Text(
                  'Oxirgi: +${student.gain}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Group List ───────────────────────────────────────────────────────────────
class _GroupList extends StatelessWidget {
  final List<GroupModel> groups;

  const _GroupList({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: groups.length + 1,
      itemBuilder: (ctx, i) {
        if (i == groups.length) return const SizedBox(height: 16);
        return _GroupCard(group: groups[i]);
      },
    );
  }
}

// ─── Group Card ───────────────────────────────────────────────────────────────
class _GroupCard extends StatelessWidget {
  final GroupModel group;

  const _GroupCard({required this.group});

  static const _medalColors = [AppColors.gold, AppColors.silver, AppColors.bronze];
  static const _medals      = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    final hasMedal   = group.rank <= 3;
    final badgeColor = hasMedal ? _medalColors[group.rank - 1] : AppColors.bgCard;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: hasMedal
            ? Border.all(color: badgeColor.withOpacity(0.4), width: 1.5)
            : Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: hasMedal
                  ? Text(_medals[group.rank - 1],
                  style: const TextStyle(fontSize: 22))
                  : Text(
                '#${group.rank}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.textSecond,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Ustoz: ${group.teacher} • ${group.studentCount} o'quvchi",
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecond),
                ),
                Text(
                  "O'rtacha: ${group.avgCoins} coin",
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecond),
                ),
              ],
            ),
          ),

          // Coins + growth
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CoinText(coins: group.totalCoins, fontSize: 16),
              const SizedBox(height: 4),
              Text(
                '↑+${group.growth}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}