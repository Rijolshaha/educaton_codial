import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/kurs_model.dart';
import 'kurs_mini_stat.dart';

class KursDetailDialog extends StatelessWidget {
  final KursModel kurs;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const KursDetailDialog({
    super.key,
    required this.kurs,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kurs.rang.color1, kurs.rang.color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(kurs.belgi.icon,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    kurs.nomi,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          // ── Body ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Kurs Nomi', value: kurs.nomi),
                const SizedBox(height: 10),
                _DetailRow(label: 'Tavsif', value: kurs.tavsif),
                const SizedBox(height: 10),

                Row(children: [
                  Expanded(
                    child: _DetailIconBox(
                      label: 'Belgi',
                      icon: kurs.belgi.icon,
                      text: kurs.belgi.label,
                      color: kurs.rang.color1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DetailColorBox(
                      label: 'Rang',
                      color: kurs.rang.color1,
                      text: kurs.rang.label,
                    ),
                  ),
                ]),
                const SizedBox(height: 14),

                // Stats
                Row(children: [
                  Expanded(child: KursMiniStat(
                      count: kurs.oqituvchilar, label: "O'qituvchi")),
                  Expanded(child: KursMiniStat(
                      count: kurs.guruhlar, label: 'Guruh')),
                  Expanded(child: KursMiniStat(
                      count: kurs.oquvchilar, label: "O'quvchi")),
                ]),
                const SizedBox(height: 14),

                // Buttons
                Row(children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined,
                          size: 16, color: Colors.white),
                      label: const Text('Tahrirlash',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE2E2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Icon(Icons.delete_outline,
                        color: AppColors.red, size: 20),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Detail Row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary)),
        const SizedBox(height: 3),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary)),
      ],
    );
  }
}

// ─── Detail Icon Box ──────────────────────────────────────────────────────────

class _DetailIconBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final String text;
  final Color color;
  const _DetailIconBox({
    required this.label,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textPrimary)),
        ]),
      ],
    );
  }
}

// ─── Detail Color Box ─────────────────────────────────────────────────────────

class _DetailColorBox extends StatelessWidget {
  final String label;
  final Color color;
  final String text;
  const _DetailColorBox({
    required this.label,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
          ),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textPrimary)),
        ]),
      ],
    );
  }
}