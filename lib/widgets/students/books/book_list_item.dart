import 'package:flutter/material.dart';
import '../../../models/book_model.dart';
import '../../../constants/app_colors.dart';

class BookListItem extends StatelessWidget {
  final BookModel book;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BookListItem({
    super.key,
    required this.book,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isOqiyapman = book.status == BookStatus.oqiyapman;
    final statusColor = isOqiyapman ? AppColors.blue : AppColors.green;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: book.coverUrl != null
                      ? Image.network(
                    book.coverUrl!,
                    width: 70,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _defaultCover(70, 90),
                  )
                      : _defaultCover(70, 90),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Status badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              book.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          _StatusBadge(
                            label: book.statusLabel,
                            color: statusColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Muallif: ${book.author}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _DateRow(
                          label: 'Boshlangan',
                          date: _formatDate(book.startDate)),
                      if (book.endDate != null)
                        _DateRow(
                            label: 'Tugallangan',
                            date: _formatDate(book.endDate!)),
                      const SizedBox(height: 8),

                      // Actions
                      Row(
                        children: [
                          _ActionButton(
                            icon: Icons.edit_outlined,
                            label: 'Tahrirlash',
                            color: AppColors.primary,
                            onTap: onEdit,
                          ),
                          const SizedBox(width: 8),
                          _ActionButton(
                            icon: Icons.delete_outline,
                            label: "O'chirish",
                            color: Colors.red,
                            onTap: onDelete,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Summary
            if (book.summary.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.scaffold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Xulosa:',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.summary,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _defaultCover(double width, double height) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(Icons.menu_book, color: Colors.grey.shade400, size: 32),
  );
}

// ── Small reusable pieces ───────────────────────

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
          color: color, fontSize: 10, fontWeight: FontWeight.w600),
    ),
  );
}

class _DateRow extends StatelessWidget {
  final String label;
  final String date;
  const _DateRow({required this.label, required this.date});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Row(
      children: [
        Icon(Icons.calendar_today_outlined,
            size: 11, color: Colors.grey.shade500),
        const SizedBox(width: 3),
        Text(
          '$label: $date',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    ),
  );
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.icon,
        required this.label,
        required this.color,
        required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );
}