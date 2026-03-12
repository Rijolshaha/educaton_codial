import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/student_model.dart';

class StudentPublicProfilePage extends StatelessWidget {
  final StudentModel student;

  const StudentPublicProfilePage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Orqaga button ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16, color: Color(0xFF111827)),
                      label: const Text('Orqaga',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          )),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // ── Header card (blue) ───────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 28, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 96, height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: ClipOval(
                            child: Center(
                              child: Text(student.avatarEmoji,
                                  style: const TextStyle(fontSize: 52)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Ism
                        Text(student.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            )),
                        const SizedBox(height: 12),

                        // Email + Guruh
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.mail_outline_rounded,
                                color: Colors.white70, size: 15),
                            const SizedBox(width: 5),
                            Text(student.email,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                            const SizedBox(width: 16),
                            const Icon(Icons.group_outlined,
                                color: Colors.white70, size: 15),
                            const SizedBox(width: 5),
                            const Text('Guruh: 1',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Jami Coinlar (orange) ────────────────────────
                  _StatBigCard(
                    label: 'Jami Coinlar',
                    value: _fmt(student.coins),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFE84C0E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.monetization_on_outlined,
                  ),
                  const SizedBox(height: 14),

                  // ── Reyting (purple) ─────────────────────────────
                  _StatBigCard(
                    label: 'Reyting',
                    value: '#${student.rank}',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9B59B6), Color(0xFF7D3C98)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.military_tech_outlined,
                  ),
                  const SizedBox(height: 14),

                  // ── O'qigan Kitoblar (green) ─────────────────────
                  _StatBigCard(
                    label: "O'qigan Kitoblar",
                    value: '${student.books.length}',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF27AE60), Color(0xFF1E8449)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.menu_book_rounded,
                  ),

                  // ── Kitoblari ────────────────────────────────────
                  if (student.books.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: const [
                        Text('Kitoblari',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF111827),
                            )),
                        SizedBox(width: 8),
                        Text('📚', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...student.books.map((book) => _BookCard(book: book)),
                  ],
                ]),
              ),
            ),
          ],
        ),
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

// ─── Big Stat Card ────────────────────────────────────────────────────────────

class _StatBigCard extends StatelessWidget {
  final String label;
  final String value;
  final LinearGradient gradient;
  final IconData icon;

  const _StatBigCard({
    required this.label,
    required this.value,
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: 6),
              Text(value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  )),
            ],
          ),
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}

// ─── Book Card ────────────────────────────────────────────────────────────────

class _BookCard extends StatelessWidget {
  final BookModel book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (book.status) {
      BookStatus.tugatdi          => const Color(0xFF27AE60),
      BookStatus.oqilyabdi        => const Color(0xFF3B82F6),
      BookStatus.rejalashtirilgan => const Color(0xFFF59E0B),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kitob muqovasi (placeholder)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=200&q=80',
                    width: 80, height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80, height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.menu_book_rounded,
                          color: Color(0xFF3B82F6), size: 36),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Ma'lumot
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_outline_rounded,
                                  size: 13, color: statusColor),
                              const SizedBox(width: 4),
                              Text(book.status.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Nomi
                      Text(book.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                            height: 1.3,
                          )),
                      const SizedBox(height: 6),

                      // Muallif
                      Text('Muallif: ${book.author}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          )),
                      const SizedBox(height: 6),

                      // Boshlangan
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_outlined,
                              size: 13, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 4),
                          Text('Boshlangan: ${book.startDate}',
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF6B7280))),
                        ],
                      ),

                      // Tugallangan
                      if (book.endDate != null) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined,
                                size: 13, color: Color(0xFF9CA3AF)),
                            const SizedBox(width: 4),
                            Text('Tugallangan: ${book.endDate}',
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF6B7280))),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // Xulosa
            if (book.summary.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Xulosa:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF374151),
                        )),
                    const SizedBox(height: 4),
                    Text(book.summary,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}