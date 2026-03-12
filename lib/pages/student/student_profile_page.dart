import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/student_model.dart';

// ─── Level model ──────────────────────────────────────────────────────────────

class _LevelData {
  final String emoji;
  final String title;
  final int level;
  final int minCoins;
  final int? maxCoins;

  const _LevelData({
    required this.emoji,
    required this.title,
    required this.level,
    required this.minCoins,
    this.maxCoins,
  });
}

const List<_LevelData> _levels = [
  _LevelData(emoji: '🌱', title: 'Beginner',          level: 1,  minCoins: 0,      maxCoins: 4799),
  _LevelData(emoji: '💻', title: 'Junior',             level: 2,  minCoins: 4800,   maxCoins: 9599),
  _LevelData(emoji: '🚀', title: 'Middle',             level: 3,  minCoins: 9600,   maxCoins: 14399),
  _LevelData(emoji: '⚡', title: 'Senior',             level: 4,  minCoins: 14400,  maxCoins: 19199),
  _LevelData(emoji: '🎯', title: 'Team Lead',          level: 5,  minCoins: 19200,  maxCoins: 23999),
  _LevelData(emoji: '🔧', title: 'Software Engineer',  level: 6,  minCoins: 24000,  maxCoins: 28799),
  _LevelData(emoji: '🏗️', title: 'Principal Engineer', level: 7,  minCoins: 28800,  maxCoins: 33599),
  _LevelData(emoji: '🧠', title: 'Tech Guru',          level: 8,  minCoins: 33600,  maxCoins: 38399),
  _LevelData(emoji: '🏆', title: 'Master',             level: 9,  minCoins: 38400,  maxCoins: 43199),
  _LevelData(emoji: '👑', title: 'Legendary',          level: 10, minCoins: 43200,  maxCoins: null),
];

// ─── Page ─────────────────────────────────────────────────────────────────────

class StudentProfilePage extends StatefulWidget {
  final StudentModel student;

  const StudentProfilePage({super.key, required this.student});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  late String _bio;

  @override
  void initState() {
    super.initState();
    _bio = 'Backend dasturlashga qiziqaman';
  }

  void _editBio() {
    final controller = TextEditingController(text: _bio);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bio tahrirlash',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    )),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              maxLength: 200,
              autofocus: true,
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: "O'zingiz haqingizda yozing...",
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.blue1, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _bio = controller.text.trim());
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue1,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text('Saqlash',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Level helpers ────────────────────────────────────────────────────────────

  _LevelData get _currentLevelData => _levels.lastWhere(
        (l) => widget.student.coins >= l.minCoins,
    orElse: () => _levels.first,
  );

  double get _progressValue {
    final lvl = _currentLevelData;
    if (lvl.maxCoins == null) return 1.0;
    return (widget.student.coins - lvl.minCoins) / (lvl.maxCoins! - lvl.minCoins);
  }

  int get _coinsLeftValue {
    final lvl = _currentLevelData;
    if (lvl.maxCoins == null) return 0;
    return lvl.maxCoins! - widget.student.coins;
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
    final lvl       = _currentLevelData;
    final progress  = _progressValue.clamp(0.0, 1.0);
    final coinsLeft = _coinsLeftValue;
    final pct       = (progress * 100).round();

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFF3F4F6)),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ── Ko'k gradient karta ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.blue1, AppColors.blue2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 90, height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: ClipOval(
                                child: Center(
                                  child: Text(
                                    student.avatarEmoji,
                                    style: const TextStyle(fontSize: 48),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 30, height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Ism
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Email
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.mail_outline_rounded,
                                color: Colors.white70, size: 15),
                            const SizedBox(width: 6),
                            Text(student.email,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Ro'yxatdan o'tgan
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.calendar_today_outlined,
                                color: Colors.white70, size: 14),
                            SizedBox(width: 6),
                            Text("Ro'yxatdan o'tgan: Yanvar 2026",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Coins
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🪙', style: TextStyle(fontSize: 26)),
                            const SizedBox(width: 8),
                            Text(
                              _fmt(student.coins),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: AppColors.coinGold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Stats 2x2 ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      _StatCard(icon: '🪙', value: _fmt(student.coins), label: 'Jami coinlar'),
                      const _StatCard(icon: '👥', value: '1',           label: 'Guruhlar soni'),
                      _StatCard(icon: '🏆', value: '#${student.rank}',  label: "O'rin"),
                      const _StatCard(icon: '📋', value: '3',           label: 'Tranzaksiyalar'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Bio ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Bio',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                )),
                            GestureDetector(
                              onTap: _editBio,
                              child: const Row(
                                children: [
                                  Icon(Icons.edit_outlined,
                                      color: AppColors.blue1, size: 16),
                                  SizedBox(width: 4),
                                  Text('Tahrirlash',
                                      style: TextStyle(
                                        color: AppColors.blue1,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _bio.isEmpty ? "Bio qo'shing..." : _bio,
                          style: TextStyle(
                            fontSize: 14,
                            color: _bio.isEmpty
                                ? AppColors.textSecondary.withOpacity(0.5)
                                : AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Mening guruhlarim ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mening guruhlarim',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            )),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F4FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(student.group,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        )),
                                    const SizedBox(height: 3),
                                    const Text('Ustoz: Otabek Tursunov',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.blue1.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('Dush-Chor-Juma',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blue1,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── So'nggi faoliyat ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("So'nggi faoliyat",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            )),
                        const SizedBox(height: 12),
                        const _ActivityRow(
                            title: 'Dars bahosi',
                            date: '2026-02-10',
                            coins: 420),
                        Divider(height: 1, color: Colors.grey.withOpacity(0.12)),
                        const _ActivityRow(
                            title: 'Yanvar oyi imtihoni',
                            date: '2026-01-31',
                            coins: 525),
                        Divider(height: 1, color: Colors.grey.withOpacity(0.12)),
                        const _ActivityRow(
                            title: 'Dars bahosi',
                            date: '2026-02-07',
                            coins: 338),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Sizning darajangiz karta ─────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5B5F6A), Color(0xFF3F434C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sizning darajangiz',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white70)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Text('✨',
                                      style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text('Level ${lvl.level}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(lvl.emoji,
                                style: const TextStyle(fontSize: 32)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(lvl.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    )),
                                Text('Level ${lvl.level} / 10',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white60)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Keyingi daraja uchun',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white60)),
                            Text(
                              lvl.maxCoins == null
                                  ? 'Maksimal daraja!'
                                  : '$coinsLeft coin qoldi',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white60),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("$pct% to'ldirildi",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white60)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Darajalar xaritasi ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Darajalar xaritasi',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            )),
                        const SizedBox(height: 4),
                        const Text(
                          "Barcha darajalar va ularni qo'lga kiritish uchun zarur bo'lgan coinlar",
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.4),
                        ),
                        const SizedBox(height: 14),
                        ..._levels.map((l) => _LevelCard(
                          level: l,
                          isCurrent: l.level == lvl.level,
                          isUnlocked: student.coins >= l.minCoins,
                          progress: l.level == lvl.level ? progress : null,
                          coinsLeft: l.level == lvl.level ? coinsLeft : null,
                        )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
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

// ─── Stat Card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: AppColors.blue1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              )),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              )),
        ],
      ),
    );
  }
}

// ─── Activity Row ─────────────────────────────────────────────────────────────

class _ActivityRow extends StatelessWidget {
  final String title;
  final String date;
  final int coins;

  const _ActivityRow({
    required this.title,
    required this.date,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  )),
              const SizedBox(height: 3),
              Text(date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  )),
            ],
          ),
          Text('+$coins',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.green,
              )),
        ],
      ),
    );
  }
}

// ─── Level Card ───────────────────────────────────────────────────────────────

class _LevelCard extends StatelessWidget {
  final _LevelData level;
  final bool isCurrent;
  final bool isUnlocked;
  final double? progress;
  final int? coinsLeft;

  const _LevelCard({
    required this.level,
    required this.isCurrent,
    required this.isUnlocked,
    this.progress,
    this.coinsLeft,
  });

  @override
  Widget build(BuildContext context) {
    final rangeText = level.maxCoins != null
        ? '${_fmt(level.minCoins)} - ${_fmt(level.maxCoins!)} coins'
        : '${_fmt(level.minCoins)}+ coins';

    final pct = progress != null ? (progress! * 100).round() : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCurrent ? Colors.white : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: isCurrent
            ? Border.all(color: AppColors.blue1, width: 1.8)
            : Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.blue1.withOpacity(0.1)
                      : isUnlocked
                      ? Colors.green.withOpacity(0.08)
                      : const Color(0xFFEEEFF1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    isUnlocked ? level.emoji : '🔒',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(level.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isUnlocked
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            )),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.blue1,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Hozirgi daraja',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Level ${level.level} • $rangeText',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (isCurrent)
                Text('$pct%',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue1,
                    ))
              else if (isUnlocked)
                const Icon(Icons.check_circle_rounded,
                    color: Colors.green, size: 18)
              else
                const Icon(Icons.lock_outline_rounded,
                    color: AppColors.textSecondary, size: 18),
            ],
          ),
          if (isCurrent && progress != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.blue1),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              coinsLeft != null && coinsLeft! > 0
                  ? '${_fmt(coinsLeft!)} coin qoldi'
                  : 'Daraja tugallandi!',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)},${(n % 1000).toString().padLeft(3, '0')}';
    }
    return n.toString();
  }
}