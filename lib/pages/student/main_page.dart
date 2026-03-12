import 'package:educaton_codial/constants/app_colors.dart';
import 'package:educaton_codial/pages/student/auksion_page.dart';
import 'package:educaton_codial/pages/student/book_page.dart';
import 'package:educaton_codial/pages/student/home_page.dart';
import 'package:educaton_codial/pages/student/rating_page.dart';
import 'package:educaton_codial/pages/student/student_profile_page.dart';
import 'package:educaton_codial/models/student_model.dart';
import 'package:educaton_codial/pages/news_page.dart';
import 'package:educaton_codial/pages/baholash_nizomi_page.dart';
import 'package:educaton_codial/pages/registration_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  static const List<String> _titles = [
    'Bosh sahifa',
    'Reyting',
    'Kitoblar',
    'Auksion',
  ];

  void _navigateTo(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(onNavigate: _navigateTo), // ← callback uzatiladi
      const RatingPage(),
      const BookPage(),
      const AuctionPage(),
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
          _titles[currentIndex],
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
                    border: Border.all(color: Colors.white, width: 1.5),
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
      drawer: _AppDrawer(
        currentIndex: currentIndex,
        onSelect: _navigateTo,
      ),
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _navigateTo,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        backgroundColor: Colors.white,
        elevation: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Bosh sahifa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            activeIcon: Icon(Icons.leaderboard_rounded),
            label: 'Reyting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book_rounded),
            label: 'Kitoblar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel_outlined),
            activeIcon: Icon(Icons.gavel_rounded),
            label: 'Auksion',
          ),
        ],
      ),
    );
  }
}

// ─── Drawer ───────────────────────────────────────────────────────────────────

class _AppDrawer extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onSelect;
  const _AppDrawer({required this.currentIndex, required this.onSelect});

  static const List<_DrawerItem> _items = [
    _DrawerItem(index: 0,  icon: Icons.dashboard_outlined,    activeIcon: Icons.dashboard_rounded,    label: 'Dashboard',       badge: 0),
    _DrawerItem(index: -1, icon: Icons.newspaper_outlined,     activeIcon: Icons.newspaper_rounded,    label: 'Yangliklar',      badge: 5),
    _DrawerItem(index: -2, icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded,       label: 'Profil',          badge: 0),
    _DrawerItem(index: 1,  icon: Icons.leaderboard_outlined,   activeIcon: Icons.leaderboard_rounded,  label: 'Reyting',         badge: 0),
    _DrawerItem(index: 2,  icon: Icons.menu_book_outlined,     activeIcon: Icons.menu_book_rounded,    label: 'Kitoblarim',      badge: 0),
    _DrawerItem(index: 3,  icon: Icons.gavel_outlined,         activeIcon: Icons.gavel_rounded,        label: 'Auksion',         badge: 0),
    _DrawerItem(index: -3, icon: Icons.rule_outlined,          activeIcon: Icons.rule_rounded,         label: 'Baholash nizomi', badge: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24))),
      child: Column(
        children: [
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
                        borderRadius: BorderRadius.circular(12)),
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: _items.length,
              itemBuilder: (ctx, i) {
                final item = _items[i];
                final isActive = item.index >= 0 && item.index == currentIndex;
                return _DrawerTile(
                  item: item,
                  isActive: isActive,
                  onTap: () {
                    Navigator.pop(ctx);
                    if (item.index >= 0) {
                      // Bottom nav sahifalari
                      onSelect(item.index);
                    } else if (item.index == -1) {
                      // Yangliklar
                      Navigator.push(ctx, MaterialPageRoute(
                          builder: (_) => const NewsPage()));
                    } else if (item.index == -2) {
                      // Profil
                      Navigator.push(ctx, MaterialPageRoute(
                          builder: (_) => StudentProfilePage(
                            student: studentsHaftalik[4],
                          )));
                    } else if (item.index == -3) {
                      // Baholash nizomi
                      Navigator.push(ctx, MaterialPageRoute(
                          builder: (_) => const BaholashNizomiPage()));
                    }
                  },
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(
                            color: const Color(0xFF45B7D1).withOpacity(0.15),
                            shape: BoxShape.circle),
                        child: const Center(
                            child: Text('🧔', style: TextStyle(fontSize: 24))),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hasanali Turdialiyev',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Color(0xFF111827)),
                                overflow: TextOverflow.ellipsis),
                            SizedBox(height: 2),
                            Text('Student',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF6B7280))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, anim, __) => const RegistrationPage(),
                        transitionsBuilder: (_, anim, __, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: const Duration(milliseconds: 350),
                      ),
                          (route) => false,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded, color: AppColors.red, size: 20),
                        const SizedBox(width: 10),
                        Text('Chiqish',
                            style: TextStyle(
                                color: AppColors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
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

class _DrawerItem {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badge;
  const _DrawerItem({
    required this.index, required this.icon, required this.activeIcon,
    required this.label, required this.badge,
  });
}

class _DrawerTile extends StatelessWidget {
  final _DrawerItem item;
  final bool isActive;
  final VoidCallback onTap;
  const _DrawerTile({required this.item, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: isActive ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(isActive ? item.activeIcon : item.icon,
                    size: 22,
                    color: isActive ? AppColors.primary : const Color(0xFF374151)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(item.label,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? AppColors.primary : const Color(0xFF374151))),
                ),
                if (item.badge > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('${item.badge}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}