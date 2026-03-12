import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/student_model.dart';
import '../../widgets/students/reyting/coin_text.dart';
import '../../widgets/students/reyting/rank_badge.dart';
import '../../widgets/students/reyting/student_avatar.dart';
import '../student_public_profile_page.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  String _tab    = 'oquvchilar';
  String _period = 'haftalik';

  List<StudentModel> get _students => getStudents(_period);
  List<GroupModel>   get _groups   => getGroups(_period);

  void _openProfile(BuildContext context, StudentModel student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentPublicProfilePage(student: student),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final students = _students;
    final groups   = _groups;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            // ── Header ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reyting',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            )),
                        Text("Eng yaxshi o'quvchilar va guruhlar",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecond,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Tab toggle ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(children: [
                    _tabItem('oquvchilar', "O'quvchilar"),
                    _tabItem('guruhlar',   'Guruhlar'),
                  ]),
                ),
              ),
            ),

            // ── Period filter ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(children: [
                  _periodItem('haftalik', 'Haftalik'),
                  const SizedBox(width: 8),
                  _periodItem('oylik',    'Oylik'),
                  const SizedBox(width: 8),
                  _periodItem('umumiy',   'Umumiy'),
                ]),
              ),
            ),

            // ── Content ────────────────────────────────────────────
            if (_tab == 'oquvchilar') ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Podium(
                    students: students.take(3).toList(),
                    onTap: (s) => _openProfile(context, s),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (ctx, i) {
                      final student = students[i + 3];
                      if (student.rank <= 3) return const SizedBox.shrink();
                      return _StudentRow(
                        student: student,
                        onTap: () => _openProfile(context, student),
                      );
                    },
                    childCount: (students.length - 3).clamp(0, 999),
                  ),
                ),
              ),
            ] else ...[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (ctx, i) => _GroupCard(group: groups[i]),
                    childCount: groups.length,
                  ),
                ),
              ),
            ],

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
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
            child: Text(label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: active ? AppColors.white : AppColors.textSecond,
                )),
          ),
        ),
      ),
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
              ? [BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )]
              : [],
        ),
        child: Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: active ? AppColors.white : AppColors.textSecond,
            )),
      ),
    );
  }
}

// ─── Podium ───────────────────────────────────────────────────────────────────

class _Podium extends StatelessWidget {
  final List<StudentModel> students;
  final void Function(StudentModel) onTap;

  const _Podium({required this.students, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (students.length < 3) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _PodiumItem(student: students[1], podiumHeight: 60, avatarSize: 56, topIcon: '🥈', badgeColor: AppColors.silver,  rankLabel: '#2', rankLabelColor: AppColors.white,              onTap: onTap)),
          Expanded(child: _PodiumItem(student: students[0], podiumHeight: 80, avatarSize: 68, topIcon: '👑',  badgeColor: AppColors.gold,    rankLabel: '#1', rankLabelColor: const Color(0xFF92400E), isFirst: true, onTap: onTap)),
          Expanded(child: _PodiumItem(student: students[2], podiumHeight: 45, avatarSize: 50, topIcon: '🥉', badgeColor: AppColors.bronze,  rankLabel: '#3', rankLabelColor: AppColors.white,              onTap: onTap)),
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
  final void Function(StudentModel) onTap;

  const _PodiumItem({
    required this.student, required this.podiumHeight, required this.avatarSize,
    required this.topIcon, required this.badgeColor, required this.rankLabel,
    required this.rankLabelColor, required this.onTap, this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final parts = student.name.split(' ');
    final displayName = parts.length >= 2 ? '${parts[0]}\n${parts[1]}' : student.name;

    return GestureDetector(
      onTap: () => onTap(student),
      child: Column(
        children: [
          Text(topIcon, style: TextStyle(fontSize: isFirst ? 24 : 20)),
          const SizedBox(height: 4),
          StudentAvatar(student: student, size: avatarSize, border: Border.all(color: badgeColor, width: 3)),
          const SizedBox(height: 8),
          Text(displayName,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600, height: 1.2)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: AppColors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Text(_fmt(student.coins),
                style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: podiumHeight,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Center(
              child: Text(rankLabel,
                  style: TextStyle(color: rankLabelColor, fontWeight: FontWeight.w900, fontSize: isFirst ? 26 : 20)),
            ),
          ),
        ],
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

// ─── Student Row ──────────────────────────────────────────────────────────────

class _StudentRow extends StatelessWidget {
  final StudentModel student;
  final VoidCallback onTap;

  const _StudentRow({required this.student, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            RankBadge(rank: student.rank),
            const SizedBox(width: 10),
            StudentAvatar(student: student),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.text),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(student.group,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecond)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CoinText(coins: student.coins),
                const SizedBox(height: 3),
                Text('Oxirgi: +${student.gain}',
                    style: TextStyle(fontSize: 11, color: AppColors.green, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Group Card ───────────────────────────────────────────────────────────────

class _GroupCard extends StatelessWidget {
  final GroupModel group;
  const _GroupCard({required this.group});

  static final _medalColors = [AppColors.gold, AppColors.silver, AppColors.bronze];
  static const _medals = ['🥇', '🥈', '🥉'];

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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: hasMedal
                  ? Text(_medals[group.rank - 1], style: const TextStyle(fontSize: 22))
                  : Text('#${group.rank}',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textSecond)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.name,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.text)),
                const SizedBox(height: 3),
                Text("Ustoz: ${group.teacher} • ${group.studentCount} o'quvchi",
                    style: TextStyle(fontSize: 12, color: AppColors.textSecond)),
                Text("O'rtacha: ${group.avgCoins} coin",
                    style: TextStyle(fontSize: 12, color: AppColors.textSecond)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CoinText(coins: group.totalCoins, fontSize: 16),
              const SizedBox(height: 4),
              Text('↑+${group.growth}%',
                  style: TextStyle(fontSize: 12, color: AppColors.green, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}