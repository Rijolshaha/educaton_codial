import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/student_model.dart';
import '../../services/student_service.dart';
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
  final _service = StudentService();
  final _scrollController = ScrollController();

  static const _studentPage = StudentService.ratingStudentPageSize;
  static const _groupPage = StudentService.ratingGroupPageSize;

  String _tab = 'oquvchilar';
  String _period = 'haftalik';

  List<StudentModel> _allStudents = const [];
  List<GroupModel> _allGroups = const [];
  int _studentVisible = 0;
  int _groupVisible = 0;

  bool _loadingStudents = true;
  bool _loadingGroups = false;
  bool _groupsLoaded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadStudents();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels < pos.maxScrollExtent - 240) return;
    _loadMore();
  }

  void _loadMore() {
    if (_tab == 'oquvchilar') {
      if (_loadingStudents || _studentVisible >= _allStudents.length) return;
      setState(() {
        _studentVisible = (_studentVisible + _studentPage)
            .clamp(0, _allStudents.length);
      });
    } else {
      if (_loadingGroups || !_groupsLoaded) return;
      if (_groupVisible >= _allGroups.length) return;
      setState(() {
        _groupVisible =
            (_groupVisible + _groupPage).clamp(0, _allGroups.length);
      });
    }
  }

  Future<void> _loadStudents({bool refresh = false}) async {
    setState(() {
      _loadingStudents = true;
      _error = null;
      if (refresh) {
        _allStudents = const [];
        _studentVisible = 0;
        _groupsLoaded = false;
        _allGroups = const [];
        _groupVisible = 0;
      }
    });

    try {
      final list =
          await _service.loadRatingStudents(_period, refresh: refresh);
      if (!mounted) return;
      setState(() {
        _allStudents = list;
        _studentVisible = list.length.clamp(0, _studentPage);
        _loadingStudents = false;
      });
      _prefetchGroups();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingStudents = false;
        _error = 'Ma\'lumot yuklanmadi';
      });
    }
  }

  Future<void> _prefetchGroups() async {
    if (_groupsLoaded) return;
    final list = await _service.loadRatingGroups(_period);
    if (!mounted) return;
    setState(() {
      _allGroups = list;
      _groupVisible = list.length.clamp(0, _groupPage);
      _groupsLoaded = true;
    });
  }

  Future<void> _loadGroups() async {
    if (_groupsLoaded) return;
    setState(() => _loadingGroups = true);
    try {
      final list = await _service.loadRatingGroups(_period);
      if (!mounted) return;
      setState(() {
        _allGroups = list;
        _groupVisible = list.length.clamp(0, _groupPage);
        _groupsLoaded = true;
        _loadingGroups = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingGroups = false);
    }
  }

  Future<void> _onRefresh() async {
    _service.clearRatingCache();
    await _loadStudents(refresh: true);
    if (_tab == 'guruhlar') await _loadGroups();
  }

  void _changePeriod(String key) {
    if (_period == key) return;
    setState(() {
      _period = key;
      _groupsLoaded = false;
      _allGroups = const [];
      _groupVisible = 0;
    });
    _service.clearRatingCache();
    _loadStudents(refresh: true);
  }

  void _openProfile(BuildContext context, StudentModel student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentPublicProfilePage(student: student),
      ),
    );
  }

  List<StudentModel> get _visibleStudents =>
      _allStudents.take(_studentVisible).toList();

  List<GroupModel> get _visibleGroups =>
      _allGroups.take(_groupVisible).toList();

  bool get _hasMoreStudents => _studentVisible < _allStudents.length;
  bool get _hasMoreGroups => _groupVisible < _allGroups.length;

  @override
  Widget build(BuildContext context) {
    final students = _visibleStudents;
    final groups = _visibleGroups;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
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
                      _tabItem('guruhlar', 'Guruhlar'),
                    ]),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(children: [
                    _periodItem('haftalik', 'Haftalik'),
                    const SizedBox(width: 8),
                    _periodItem('oylik', 'Oylik'),
                    const SizedBox(width: 8),
                    _periodItem('umumiy', 'Umumiy'),
                  ]),
                ),
              ),
              if (_tab == 'oquvchilar') ...[
                if (_loadingStudents && _allStudents.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 48),
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      ),
                    ),
                  )
                else if (_error != null && _allStudents.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_error!,
                              style: const TextStyle(
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => _loadStudents(refresh: true),
                            child: const Text('Qayta urinish'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_allStudents.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text("Ma'lumot topilmadi",
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  )
                else ...[
                  if (students.length >= 3)
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
                          return _StudentRow(
                            student: student,
                            onTap: () => _openProfile(context, student),
                          );
                        },
                        childCount: (students.length - 3).clamp(0, 999),
                      ),
                    ),
                  ),
                  if (_hasMoreStudents)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ] else ...[
                if (_loadingGroups && !_groupsLoaded)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 48),
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      ),
                    ),
                  )
                else if (groups.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text("Ma'lumot topilmadi",
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => _GroupCard(group: groups[i]),
                        childCount: groups.length,
                      ),
                    ),
                  ),
                if (_hasMoreGroups)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabItem(String key, String label) {
    final active = _tab == key;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_tab == key) return;
          setState(() => _tab = key);
          if (key == 'guruhlar' && !_groupsLoaded) _loadGroups();
        },
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
      onTap: () => _changePeriod(key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
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
          Expanded(
              child: _PodiumItem(
                  student: students[1],
                  podiumHeight: 60,
                  avatarSize: 56,
                  topIcon: '🥈',
                  badgeColor: AppColors.silver,
                  rankLabel: '#2',
                  rankLabelColor: AppColors.white,
                  onTap: onTap)),
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
                  onTap: onTap)),
          Expanded(
              child: _PodiumItem(
                  student: students[2],
                  podiumHeight: 45,
                  avatarSize: 50,
                  topIcon: '🥉',
                  badgeColor: AppColors.bronze,
                  rankLabel: '#3',
                  rankLabelColor: AppColors.white,
                  onTap: onTap)),
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
    required this.student,
    required this.podiumHeight,
    required this.avatarSize,
    required this.topIcon,
    required this.badgeColor,
    required this.rankLabel,
    required this.rankLabelColor,
    required this.onTap,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final parts = student.name.split(' ');
    final displayName =
        parts.length >= 2 ? '${parts[0]}\n${parts[1]}' : student.name;

    return GestureDetector(
      onTap: () => onTap(student),
      child: Column(
        children: [
          Text(topIcon, style: TextStyle(fontSize: isFirst ? 24 : 20)),
          const SizedBox(height: 4),
          StudentAvatar(
              student: student,
              size: avatarSize,
              border: Border.all(color: badgeColor, width: 3)),
          const SizedBox(height: 8),
          Text(displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.2)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12)),
            child: Text(_fmt(student.coins),
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: podiumHeight,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Center(
              child: Text(rankLabel,
                  style: TextStyle(
                      color: rankLabelColor,
                      fontWeight: FontWeight.w900,
                      fontSize: isFirst ? 26 : 20)),
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
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.text),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(student.group,
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecond)),
                ],
              ),
            ),
            CoinText(coins: student.coins),
          ],
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final GroupModel group;
  const _GroupCard({required this.group});

  static final _medalColors = [
    AppColors.gold,
    AppColors.silver,
    AppColors.bronze
  ];
  static const _medals = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    final hasMedal = group.rank <= 3;
    final badgeColor =
        hasMedal ? _medalColors[group.rank - 1] : AppColors.bgCard;

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
          BoxShadow(
              color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: badgeColor, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: hasMedal
                  ? Text(_medals[group.rank - 1],
                      style: const TextStyle(fontSize: 22))
                  : Text('#${group.rank}',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.textSecond)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.text)),
                const SizedBox(height: 3),
                Text(
                    group.studentCount > 0
                        ? "Ustoz: ${group.teacher} • ${group.studentCount} o'quvchi"
                        : 'Ustoz: ${group.teacher}',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecond)),
                if (group.avgCoins > 0)
                  Text("O'rtacha: ${group.avgCoins} coin",
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecond)),
              ],
            ),
          ),
          CoinText(coins: group.totalCoins, fontSize: 16),
        ],
      ),
    );
  }
}
