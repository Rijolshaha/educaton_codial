import 'package:educaton_codial/pages/student/home_page/widgets/moch_ontap.dart';
import 'package:flutter/material.dart';

/// ====== QUICK ACTIONS GRID (2x2) ======
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = <_TileData>[
      _TileData(
        icon: Icons.menu_book,
        title: 'Kitoblar',
        subtitle: '+100 coin',
        colors: const [Color(0xFF2ECC40), Color(0xFF27AE60)],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MochOntap()),
        ),
      ),
      _TileData(
        icon: Icons.menu_book_outlined,
        title: 'Qoidalar',
        subtitle: "O'qib chiqing",
        colors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MochOntap()),
        ),
      ),
      _TileData(
        icon: Icons.emoji_events,
        title: 'Reyting',
        subtitle: "#1-o'rin",
        colors: const [Color(0xFFF59E0B), Color(0xFFD97706)],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MochOntap()),
        ),
      ),
      _TileData(
        icon: Icons.group,
        title: "Ko'rish",
        subtitle: 'Guruhlar',
        colors: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MochOntap()),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tiles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.45, // rasmga yaqin proportion
        ),
        itemBuilder: (context, i) => _ActionTile(data: tiles[i]),
      ),
    );
  }
}

/// ====== TILE WIDGET ======
class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.data});

  final _TileData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: data.onTap, // ✅ onTap ishlaydi
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
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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

/// ====== TILE DATA MODEL ======
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