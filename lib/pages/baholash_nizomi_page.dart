import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class BaholashNizomiPage extends StatelessWidget {
  const BaholashNizomiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
        ),
        title: const Text(
          'Baholash Nizomi',
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [

          // ── Sarlavha ──────────────────────────────────────────────
          const Row(
            children: [
              Icon(Icons.menu_book_outlined,
                  color: AppColors.blue1, size: 28),
              SizedBox(width: 10),
              Text(
                'Baholash Nizomi',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Coin tizimi qanday ishlaydi va qoidalar',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // ── Coin Tizimi — ko'k karta ──────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.blue1, AppColors.blue2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text('🪙', style: TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coin Tizimi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "CODIAL platformasida coin tizimi orqali sizning faolligingiz va yutuqlaringiz baholanadi. Yig'ilgan coinlaringizni oy oxiridagi auksionlarda qimmatli sovg'alarga almashtira olasiz!",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Har bir darsda olish mumkin bo'lgan coinlar ───────────
          const Text(
            "Har bir darsda olish mumkin bo'lgan coinlar",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          _CoinRuleCard(
            icon: Icons.menu_book_outlined,
            iconColor: AppColors.blue1,
            bgColor: const Color(0xFFE8F4FF),
            title: 'Vazifa',
            subtitle: 'Uyga vazifa baholash',
            value: '0-100',
            valueColor: AppColors.blue1,
          ),
          const SizedBox(height: 10),
          _CoinRuleCard(
            icon: Icons.check_circle_outline_rounded,
            iconColor: AppColors.green,
            bgColor: const Color(0xFFE8F5E9),
            title: 'Darsga qatnashdi',
            subtitle: 'Darsda qatnashganlik uchun',
            value: '+25',
            valueColor: AppColors.green,
          ),
          const SizedBox(height: 10),
          _CoinRuleCard(
            icon: Icons.check_circle_outline_rounded,
            iconColor: AppColors.green,
            bgColor: const Color(0xFFE8F5E9),
            title: 'Vaqtida keldi',
            subtitle: 'Darsga kechikmasdan kelganlik uchun',
            value: '+25',
            valueColor: AppColors.green,
          ),
          const SizedBox(height: 10),
          _CoinRuleCard(
            icon: Icons.emoji_events_outlined,
            iconColor: AppColors.green,
            bgColor: const Color(0xFFE8F5E9),
            title: 'Darsdagi faollik',
            subtitle: 'Darsda faol ishtirok etish',
            value: '+30',
            valueColor: AppColors.green,
          ),
          const SizedBox(height: 10),
          _CoinRuleCard(
            icon: Icons.menu_book_outlined,
            iconColor: AppColors.purple,
            bgColor: const Color(0xFFF3E5F5),
            title: "Soha bo'yicha o'rganish",
            subtitle: "Qo'shimcha darslar va kurslar",
            value: '+100',
            valueColor: AppColors.purple,
          ),
          const SizedBox(height: 10),
          _CoinRuleCard(
            icon: Icons.menu_book_outlined,
            iconColor: AppColors.orange,
            bgColor: const Color(0xFFFFF3E0),
            title: "Kitob o'qish",
            subtitle: "Dasturlash kitoblarini o'qish",
            value: '+100',
            valueColor: AppColors.orange,
          ),
          const SizedBox(height: 10),
          _CoinRuleCard(
            icon: Icons.check_circle_outline_rounded,
            iconColor: const Color(0xFF00BCD4),
            bgColor: const Color(0xFFE0F7FA),
            title: 'Tozalik',
            subtitle: 'Tartib va tozalikni saqlash',
            value: '+25',
            valueColor: const Color(0xFF00BCD4),
          ),
          const SizedBox(height: 10),
          _CoinRuleCard(
            icon: Icons.emoji_events_outlined,
            iconColor: const Color(0xFFE91E63),
            bgColor: const Color(0xFFFCE4EC),
            title: 'Podcast tinglash',
            subtitle: "O'quv podcastlarini tinglash",
            value: '+50',
            valueColor: const Color(0xFFE91E63),
          ),
          const SizedBox(height: 10),

          // Oylik imtihon — sariq, range
          _CoinRuleCard(
            icon: Icons.emoji_events_outlined,
            iconColor: const Color(0xFFF59E0B),
            bgColor: const Color(0xFFFFFDE7),
            title: 'Oylik Imtihon',
            subtitle: "Har oy oxirida o'tkaziladigan imtihon bahosi",
            value: '0-500 coin',
            valueColor: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 10),

          // Maksimal summary karta
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    color: AppColors.green, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Maksimal har darsda: ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextSpan(
                              text: '~455 coin',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Oylik potensial: ~5960 coin',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Dars jadvali ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calendar_month_outlined,
                        color: AppColors.blue1, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Dars jadvali',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Variant A
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Variant A',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary)),
                      SizedBox(height: 4),
                      Text('Dushanba - Chorshanba - Juma',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.blue1,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Variant B
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Variant B',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary)),
                      SizedBox(height: 4),
                      Text('Seshanba - Payshanba - Shanba',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.orange,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 16, color: AppColors.blue1),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "Baholash faqat dars kunlarida amalga oshiriladi va o'sha kun tugagunicha tahrirlash mumkin.",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Muhim qoidalar ────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: AppColors.orange, size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      'Muhim qoidalar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ..._rules.map((rule) => _RuleItem(text: rule)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Maqsadingiz nimada — gradient karta ───────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF4444)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('🎯', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 8),
                    Text(
                      'Maqsadingiz nimada?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Ko'proq coin yig'ing, reyting jadvalida yuqori o'rinlarga chiqing va oy oxiridagi auksionlarda ajoyib sovg'alarni yutib oling! Har bir darsda faol qatnashing, vazifalaringizni sifatli bajaring va kitob o'qing!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Muhim qoidalar ro'yxati ─────────────────────────────────────────────────

const List<String> _rules = [
  'Har bir mukofot turi darsda faqat bir marta beriladi',
  'Imtihon bahosi oyiga bir marta qo\'yiladi',
  'Baholash faqat dars kunlari amalga oshiriladi',
  'Kun tugagach baholar qulflanadi va o\'zgartirib bo\'lmaydi',
  'Yig\'ilgan coinlarni auksionlarda ishlatish mumkin',
  'Reyting har kuni yangilanadi',
];

// ─── Widgets ─────────────────────────────────────────────────────────────────

class _CoinRuleCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final String value;
  final Color valueColor;

  const _CoinRuleCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    )),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final String text;
  const _RuleItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: AppColors.green, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}