import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/kurs_model.dart';
import 'kurs_mini_stat.dart';

class KursCard extends StatelessWidget {
  final KursModel kurs;
  final VoidCallback onView;

  const KursCard({
    super.key,
    required this.kurs,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final isFaol = kurs.status == KursStatus.faol;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Gradient Header ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kurs.rang.color1, kurs.rang.color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                // Icon box
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(kurs.belgi.icon,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                // Name + status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kurs.nomi,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isFaol
                                  ? Icons.check_circle_outline
                                  : Icons.cancel_outlined,
                              color: Colors.white,
                              size: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isFaol ? 'Faol' : 'Nofaol',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── White Body ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  kurs.tavsif,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5),
                ),
                const SizedBox(height: 14),

                // Mini stats
                Row(
                  children: [
                    Expanded(
                      child: KursMiniStat(
                          count: kurs.oqituvchilar,
                          label: "O'qituvchi"),
                    ),
                    Expanded(
                      child: KursMiniStat(
                          count: kurs.guruhlar,
                          label: 'Guruh'),
                    ),
                    Expanded(
                      child: KursMiniStat(
                          count: kurs.oquvchilar,
                          label: "O'quvchi"),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Ko'rish button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onView,
                    icon: const Icon(
                      Icons.remove_red_eye_outlined,
                      size: 17,
                      color: AppColors.textSecondary,
                    ),
                    label: const Text(
                      "Ko'rish",
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: const Color(0xFFF9FAFB),
                    ),
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