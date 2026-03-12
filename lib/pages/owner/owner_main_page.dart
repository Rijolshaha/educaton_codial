import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/owner_model.dart';
import '../../../utils/responsive.dart';

// ── Owner pages ──
import '../../../pages/owner/owner_dashboard_page.dart';
import '../../../pages/owner/owner_adminlar_page.dart';

// ── Reuse from Admin ──
import '../../../pages/admin/admin_guruhlar_page.dart';
import '../../../pages/admin/admin_kurslar_page.dart';
import '../../../pages/admin/admin_ustozlar_page.dart';
import '../../../pages/admin/admin_oquvchilar_page.dart';
import '../../../pages/news_page.dart';

// ── Other shared ──
import '../../../pages/registration_page.dart';
import '../admin/admin_auction_page.dart';

class OwnerMainPage extends StatefulWidget {
  const OwnerMainPage({super.key});

  @override
  State<OwnerMainPage> createState() => _OwnerMainPageState();
}

class _OwnerMainPageState extends State<OwnerMainPage> {
  int _currentIndex = 0;
  final _owner = OwnerModel.mock();

  static const List<String> _titles = [
    'Dashboard',
    'Yangliklar',
    'Guruhlar',
    'Auksion',
  ];

  void _navigateTo(int index) =>
      setState(() => _currentIndex = index);

  void _pushPage(BuildContext context, Widget page) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final pages = [
      const OwnerDashboardPage(),
      const NewsPage(),
      const AdminGuruhlarPage(),
      const AdminAuksionPage(),
    ];

    // ── Desktop layout: sidebar + content ──
    if (r.isDesktop || r.isTablet) {
      return Scaffold(
        backgroundColor: AppColors.scaffold,
        body: Row(
          children: [
            // ── Sidebar ──
            _OwnerSidebar(
              owner: _owner,
              currentIndex: _currentIndex,
              onNavigate: _navigateTo,
              onPush: (page) => _pushPage(context, page),
            ),
            // ── Content ──
            Expanded(
              child: IndexedStack(
                  index: _currentIndex, children: pages),
            ),
          ],
        ),
      );
    }

    // ── Phone layout: AppBar + Drawer + BottomNav ──
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
        actions: [_NotifIcon(), const SizedBox(width: 4)],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFF3F4F6)),
        ),
      ),
      drawer: _OwnerDrawerMobile(
        owner: _owner,
        currentIndex: _currentIndex,
        onNavigate: _navigateTo,
        onPush: (page) => _pushPage(context, page),
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
          child: const Text('6',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800)),
        ),
      ),
    ],
  );
}

// ─── Notification Icon ────────────────────────────────────────────────────────

class _NotifIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
    ]);
  }
}

// ─── Desktop Sidebar ──────────────────────────────────────────────────────────

class _OwnerSidebar extends StatelessWidget {
  final OwnerModel owner;
  final int currentIndex;
  final void Function(int) onNavigate;
  final void Function(Widget) onPush;

  const _OwnerSidebar({
    required this.owner,
    required this.currentIndex,
    required this.onNavigate,
    required this.onPush,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final sidebarW = r.isDesktop ? 240.0 : 200.0;

    return Container(
      width: sidebarW,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          // ── Logo ──
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  r.padH, r.padV + 4, r.padH, r.padV),
              child: Row(children: [
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
                const SizedBox(width: 10),
                RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                      text: 'COD',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1),
                    ),
                    TextSpan(
                      text: 'IAL',
                      style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 8),

          // ── Menu items ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              children: [
                _SidebarTile(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isActive: currentIndex == 0,
                  onTap: () => onNavigate(0),
                ),
                _SidebarTile(
                  icon: Icons.newspaper_outlined,
                  activeIcon: Icons.newspaper_rounded,
                  label: 'Yangliklar',
                  badge: 6,
                  isActive: currentIndex == 1,
                  onTap: () => onNavigate(1),
                ),
                _SidebarTile(
                  icon: Icons.shield_outlined,
                  activeIcon: Icons.shield_rounded,
                  label: 'Adminlar',
                  isActive: false,
                  onTap: () => onPush(const OwnerAdminlarPage()),
                ),
                _SidebarTile(
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book_rounded,
                  label: 'Kurslar',
                  isActive: false,
                  onTap: () => onPush(const AdminKurslarPage()),
                ),
                _SidebarTile(
                  icon: Icons.school_outlined,
                  activeIcon: Icons.school_rounded,
                  label: 'Ustozlar',
                  isActive: false,
                  onTap: () => onPush(const AdminUstozlarPage()),
                ),
                _SidebarTile(
                  icon: Icons.groups_2_outlined,
                  activeIcon: Icons.groups_2_rounded,
                  label: 'Guruhlar',
                  isActive: currentIndex == 2,
                  onTap: () => onNavigate(2),
                ),
                _SidebarTile(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: "O'quvchilar",
                  isActive: false,
                  onTap: () =>
                      onPush(const AdminOquvchilarPage()),
                ),
                _SidebarTile(
                  icon: Icons.gavel_outlined,
                  activeIcon: Icons.gavel_rounded,
                  label: 'Auksion',
                  isActive: currentIndex == 3,
                  onTap: () => onNavigate(3),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // ── Owner info + logout ──
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  r.padH, r.padV, r.padH, r.padV),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.orange.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(owner.avatarEmoji,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            owner.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Color(0xFF111827)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text('Ega',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, anim, __) =>
                        const RegistrationPage(),
                        transitionsBuilder: (_, anim, __, child) =>
                            FadeTransition(
                                opacity: anim, child: child),
                        transitionDuration:
                        const Duration(milliseconds: 350),
                      ),
                          (route) => false,
                    ),
                    child: Row(children: [
                      Icon(Icons.logout_rounded,
                          color: AppColors.red, size: 18),
                      const SizedBox(width: 8),
                      Text('Chiqish',
                          style: TextStyle(
                              color: AppColors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ]),
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

// ─── Sidebar Tile ─────────────────────────────────────────────────────────────

class _SidebarTile extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final int badge;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge = 0,
  });

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
                horizontal: 14, vertical: 12),
            child: Row(children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 20,
                color: isActive
                    ? AppColors.primary
                    : const Color(0xFF374151),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isActive
                        ? AppColors.primary
                        : const Color(0xFF374151),
                  ),
                ),
              ),
              if (badge > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('$badge',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800)),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ─── Mobile Drawer ────────────────────────────────────────────────────────────

class _OwnerDrawerMobile extends StatelessWidget {
  final OwnerModel owner;
  final int currentIndex;
  final void Function(int) onNavigate;
  final void Function(Widget) onPush;

  const _OwnerDrawerMobile({
    required this.owner,
    required this.currentIndex,
    required this.onNavigate,
    required this.onPush,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
              right: Radius.circular(24))),
      child: Column(children: [
        // Logo
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Row(children: [
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
                            fontWeight: FontWeight.w900))),
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
            ]),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFF3F4F6)),
        const SizedBox(height: 8),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 4),
            children: [
              _SidebarTile(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard_rounded,
                label: 'Dashboard',
                isActive: currentIndex == 0,
                onTap: () {
                  Navigator.pop(context);
                  onNavigate(0);
                },
              ),
              _SidebarTile(
                icon: Icons.newspaper_outlined,
                activeIcon: Icons.newspaper_rounded,
                label: 'Yangliklar',
                badge: 6,
                isActive: currentIndex == 1,
                onTap: () {
                  Navigator.pop(context);
                  onNavigate(1);
                },
              ),
              _SidebarTile(
                icon: Icons.shield_outlined,
                activeIcon: Icons.shield_rounded,
                label: 'Adminlar',
                isActive: false,
                onTap: () {
                  Navigator.pop(context);
                  onPush(const OwnerAdminlarPage());
                },
              ),
              _SidebarTile(
                icon: Icons.menu_book_outlined,
                activeIcon: Icons.menu_book_rounded,
                label: 'Kurslar',
                isActive: false,
                onTap: () {
                  Navigator.pop(context);
                  onPush(const AdminKurslarPage());
                },
              ),
              _SidebarTile(
                icon: Icons.school_outlined,
                activeIcon: Icons.school_rounded,
                label: 'Ustozlar',
                isActive: false,
                onTap: () {
                  Navigator.pop(context);
                  onPush(const AdminUstozlarPage());
                },
              ),
              _SidebarTile(
                icon: Icons.groups_2_outlined,
                activeIcon: Icons.groups_2_rounded,
                label: 'Guruhlar',
                isActive: currentIndex == 2,
                onTap: () {
                  Navigator.pop(context);
                  onNavigate(2);
                },
              ),
              _SidebarTile(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: "O'quvchilar",
                isActive: false,
                onTap: () {
                  Navigator.pop(context);
                  onPush(const AdminOquvchilarPage());
                },
              ),
              _SidebarTile(
                icon: Icons.gavel_outlined,
                activeIcon: Icons.gavel_rounded,
                label: 'Auksion',
                isActive: currentIndex == 3,
                onTap: () {
                  Navigator.pop(context);
                  onNavigate(3);
                },
              ),
            ],
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
                Row(children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(owner.avatarEmoji,
                          style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(owner.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xFF111827)),
                            overflow: TextOverflow.ellipsis),
                        const Text('Ega',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, anim, __) =>
                      const RegistrationPage(),
                      transitionsBuilder:
                          (_, anim, __, child) =>
                          FadeTransition(
                              opacity: anim, child: child),
                      transitionDuration:
                      const Duration(milliseconds: 350),
                    ),
                        (route) => false,
                  ),
                  child: Row(children: [
                    Icon(Icons.logout_rounded,
                        color: AppColors.red, size: 20),
                    const SizedBox(width: 10),
                    Text('Chiqish',
                        style: TextStyle(
                            color: AppColors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}