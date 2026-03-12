import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/teacher_model.dart';
import '../../../pages/teacher/teacher_dashboard_page.dart';
import '../../../pages/teacher/teacher_baholash_page.dart';
import '../../../pages/teacher/teacher_guruhlarim_page.dart';
import '../../../pages/news_page.dart';
import '../../../pages/student/rating_page.dart';
import '../../../pages/student/auksion_page.dart';
import '../../../pages/baholash_nizomi_page.dart';
import '../../../pages/registration_page.dart';

class TeacherMainPage extends StatefulWidget {
  const TeacherMainPage({super.key});

  @override
  State<TeacherMainPage> createState() => _TeacherMainPageState();
}

class _TeacherMainPageState extends State<TeacherMainPage> {
  int _currentIndex = 0;

  // Hozircha mock — keyinchalik API dan
  final TeacherModel _teacher = TeacherModel.mock();

  static const List<String> _titles = [
    'Dashboard',
    'Yangliklar',
    'Baholash',
    'Reyting',
  ];

  void _navigateTo(int index) =>
      setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const TeacherDashboardPage(),
      const NewsPage(),
      const TeacherBaholashPage(),
      const RatingPage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        leading: Builder(
          builder: (ctx) => IconButton(
            onPressed: () => Scaffold.of(ctx).openDrawer(),
            icon: const Icon(Icons.menu_rounded,
                color: Color(0xFF111827), size: 26),
          ),
        ),
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.w800),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined,
                    color: Color(0xFF374151), size: 24),
              ),
              Positioned(
                top: 10, right: 10,
                child: Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFF3F4F6)),
        ),
      ),
      drawer: _TeacherDrawer(
        teacher: _teacher,
        onNavigate: _navigateTo,
        onLogout: () => Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, anim, __) =>
            const RegistrationPage(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration:
            const Duration(milliseconds: 350),
          ),
              (route) => false,
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateTo,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        backgroundColor: Colors.white,
        elevation: 12,
        selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 11),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: _badgeIcon(Icons.newspaper_outlined),
            activeIcon: _badgeIcon(Icons.newspaper_rounded),
            label: 'Yangliklar',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Baholash',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            activeIcon: Icon(Icons.leaderboard_rounded),
            label: 'Reyting',
          ),
        ],
      ),
    );
  }

  static Widget _badgeIcon(IconData icon) => Stack(
    clipBehavior: Clip.none,
    children: [
      Icon(icon),
      Positioned(
        top: -4, right: -6,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(10)),
          child: const Text('5',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800)),
        ),
      ),
    ],
  );
}

// ─── Teacher Drawer ───────────────────────────────────────────────────────────

class _TeacherDrawer extends StatelessWidget {
  final TeacherModel teacher;
  final void Function(int) onNavigate;
  final VoidCallback onLogout;

  const _TeacherDrawer({
    required this.teacher,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
              right: Radius.circular(24))),
      child: Column(
        children: [
          // ── Logo ──
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('C',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                        text: 'COD',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1),
                      ),
                      TextSpan(
                        text: 'IAL',
                        style: TextStyle(
                            color: AppColors.orange,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 8),

          // ── Menu ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              children: [
                _DrawerTile(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(0);
                  },
                ),
                _DrawerTile(
                  icon: Icons.newspaper_outlined,
                  label: 'Yangliklar',
                  badge: 5,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(1);
                  },
                ),
                _DrawerTile(
                  icon: Icons.assignment_outlined,
                  label: 'Baholash',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(2);
                  },
                ),
                _DrawerTile(
                  icon: Icons.leaderboard_outlined,
                  label: 'Reyting',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(3);
                  },
                ),

                // ── Guruhlarim → navigator push ──
                _DrawerTile(
                  icon: Icons.groups_2_outlined,
                  label: 'Guruhlarim',
                  badge: teacher.groups.length, // guruhlar soni
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TeacherGuruhlarimPage(
                            teacher: teacher),
                      ),
                    );
                  },
                ),

                _DrawerTile(
                  icon: Icons.gavel_outlined,
                  label: 'Auksion',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                            const AuctionPage()));
                  },
                ),
                _DrawerTile(
                  icon: Icons.rule_outlined,
                  label: 'Baholash nizomi',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                            const BaholashNizomiPage()));
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // ── Teacher info + logout ──
          SafeArea(
            top: false,
            child: Padding(
              padding:
              const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primary
                              .withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(teacher.avatarEmoji,
                              style: const TextStyle(
                                  fontSize: 24)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              teacher.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF111827)),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            const Text('Ustoz',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: onLogout,
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded,
                            color: AppColors.red, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Chiqish',
                          style: TextStyle(
                              color: AppColors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Drawer Tile ──────────────────────────────────────────────────────────────

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int badge;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(icon,
                    size: 22, color: const Color(0xFF374151)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151)),
                  ),
                ),
                if (badge > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$badge',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}