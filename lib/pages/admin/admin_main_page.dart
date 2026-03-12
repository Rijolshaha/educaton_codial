import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../pages/admin/admin_dashboard_page.dart';
import '../../../pages/admin/admin_guruhlar_page.dart';
import '../../../pages/admin/admin_kurslar_page.dart';
import '../../../pages/admin/admin_ustozlar_page.dart';
import '../../../pages/admin/admin_oquvchilar_page.dart';
import '../../../pages/news_page.dart';
import '../../../pages/baholash_nizomi_page.dart';
import '../../../pages/registration_page.dart';
import 'admin_auction_page.dart';

// ─── Placeholder page (faqat O'quvchilar uchun hali) ─────────────────────────

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827))),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded,
              color: Color(0xFF111827)),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFF3F4F6)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 64, color: AppColors.primary.withOpacity(0.2)),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            const Text('Tez kunda...',
                style: TextStyle(
                    fontSize: 14, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }
}

// ─── Admin Main Page ──────────────────────────────────────────────────────────

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _currentIndex = 0;

  static const List<String> _titles = [
    'Dashboard',
    'Yangliklar',
    'Guruhlar',
    'Auksion',
  ];

  void _navigateTo(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const AdminDashboardPage(),
      const NewsPage(pageRole: NewsPageRole.admin),
      const AdminGuruhlarPage(),
      const AdminAuksionPage(),
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
                    border:
                    Border.all(color: Colors.white, width: 1.5),
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
      drawer: _AdminDrawer(
        currentIndex: _currentIndex,
        onNavigate: _navigateTo,
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
        selectedLabelStyle:
        const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle:
        const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
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
            icon: Icon(Icons.groups_2_outlined),
            activeIcon: Icon(Icons.groups_2_rounded),
            label: 'Guruhlar',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.gavel_outlined),
            activeIcon: Icon(Icons.gavel_rounded),
            label: 'Auksion',
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

// ─── Admin Drawer ─────────────────────────────────────────────────────────────

class _AdminDrawer extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onNavigate;

  const _AdminDrawer(
      {required this.currentIndex, required this.onNavigate});

  static const List<_DrawerItem> _items = [
    _DrawerItem(index:  0, icon: Icons.dashboard_outlined,     activeIcon: Icons.dashboard_rounded,     label: 'Dashboard',   badge: 0),
    _DrawerItem(index:  1, icon: Icons.newspaper_outlined,     activeIcon: Icons.newspaper_rounded,     label: 'Yangliklar',  badge: 5),
    _DrawerItem(index: -1, icon: Icons.menu_book_outlined,     activeIcon: Icons.menu_book_rounded,     label: 'Kurslar',     badge: 0, routeKey: 'kurslar'),
    _DrawerItem(index: -1, icon: Icons.school_outlined,        activeIcon: Icons.school_rounded,        label: 'Ustozlar',    badge: 0, routeKey: 'ustozlar'),
    _DrawerItem(index:  2, icon: Icons.groups_2_outlined,      activeIcon: Icons.groups_2_rounded,      label: 'Guruhlar',    badge: 0),
    _DrawerItem(index: -1, icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded,        label: "O'quvchilar", badge: 0, routeKey: 'oquvchilar'),
    _DrawerItem(index:  3, icon: Icons.gavel_outlined,         activeIcon: Icons.gavel_rounded,         label: 'Auksion',     badge: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.horizontal(right: Radius.circular(24))),
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

          // ── Menu items ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              itemCount: _items.length,
              itemBuilder: (ctx, i) {
                final item = _items[i];
                final isActive =
                    item.index >= 0 && item.index == currentIndex;
                return _DrawerTile(
                  item: item,
                  isActive: isActive,
                  onTap: () {
                    Navigator.pop(ctx);
                    if (item.index >= 0) {
                      onNavigate(item.index);
                    } else {
                      _push(ctx, item.routeKey ?? '');
                    }
                  },
                );
              },
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // ── Admin info + logout ──
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
                          color: AppColors.orange.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🧑‍💼',
                              style: TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Robiya Anvarova',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Color(0xFF111827)),
                                overflow: TextOverflow.ellipsis),
                            SizedBox(height: 2),
                            Text('Admin',
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
                    onTap: () => Navigator.pushAndRemoveUntil(
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
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded,
                            color: AppColors.red, size: 20),
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

  void _push(BuildContext ctx, String key) {
    Widget page;
    switch (key) {
      case 'kurslar':
        page = const AdminKurslarPage();
        break;
      case 'ustozlar':
        page = const AdminUstozlarPage();       // ✅ ulandi
        break;
      case 'oquvchilar':
        page = const AdminOquvchilarPage();     // ✅ ulandi

        break;
      default:
        page = const BaholashNizomiPage();
    }
    Navigator.push(ctx, MaterialPageRoute(builder: (_) => page));
  }
}

// ─── Drawer Item ──────────────────────────────────────────────────────────────

class _DrawerItem {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badge;
  final String? routeKey;

  const _DrawerItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.badge,
    this.routeKey,
  });
}

// ─── Drawer Tile ──────────────────────────────────────────────────────────────

class _DrawerTile extends StatelessWidget {
  final _DrawerItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerTile(
      {required this.item, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: isActive
            ? AppColors.primary.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 22,
                  color: isActive
                      ? AppColors.primary
                      : const Color(0xFF374151),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isActive
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isActive
                          ? AppColors.primary
                          : const Color(0xFF374151),
                    ),
                  ),
                ),
                if (item.badge > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${item.badge}',
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