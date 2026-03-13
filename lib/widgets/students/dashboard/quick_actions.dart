import 'package:flutter/material.dart';
import '../../../models/student_model.dart';
import '../../../pages/baholash_nizomi_page.dart';
import '../../../pages/student/student_profile_page.dart';
import 'moch_ontap.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback? onKitoblarTap;
  final VoidCallback? onReytingTap;
  final VoidCallback? onProfilTap;

  const QuickActions({
    super.key,
    this.onKitoblarTap,
    this.onReytingTap,
    this.onProfilTap,
  });

  @override
  Widget build(BuildContext context) {
    final tiles = <_TileData>[
      _TileData(
        icon: Icons.menu_book,
        title: 'Kitoblar',
        subtitle: '+100 coin',
        colors: const [Color(0xFF2ECC40), Color(0xFF27AE60)],
        onTap: onKitoblarTap ??
                () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MochOntap())),
      ),
      _TileData(
        icon: Icons.rule_rounded,
        title: 'Qoidalar',
        subtitle: "O'qib chiqing",
        colors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BaholashNizomiPage()),
        ),
      ),
      _TileData(
        icon: Icons.emoji_events,
        title: 'Reyting',
        subtitle: "#1-o'rin",
        colors: const [Color(0xFFF59E0B), Color(0xFFD97706)],
        onTap: onReytingTap ??
                () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MochOntap())),
      ),
      _TileData(
        icon: Icons.person_rounded,
        title: 'Profil',
        subtitle: "Ko'rish",
        colors: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
        onTap: onProfilTap ??
                () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => StudentProfilePage(student: studentsHaftalik[4]))),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tiles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, i) => _ActionTile(data: tiles[i]),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.data});
  final _TileData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: data.colors,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(data.icon, size: 34, color: Colors.white),
                const SizedBox(height: 14),
                Text(data.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(data.subtitle,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TileData {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback onTap;

  _TileData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });
}