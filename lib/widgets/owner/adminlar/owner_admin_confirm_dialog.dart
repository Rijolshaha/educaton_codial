import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../models/owner_admin_model.dart';

class OwnerAdminConfirmDialog extends StatelessWidget {
  final OwnerAdminModel admin;

  const OwnerAdminConfirmDialog({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(
          horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.1),
                  shape: BoxShape.circle),
              child: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.red, size: 30),
            ),
            const SizedBox(height: 16),

            const Text(
              "Adminni o'chirish",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textSecondary),
                children: [
                  TextSpan(
                    text: admin.ism,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                  const TextSpan(
                      text: " adminni o'chirishni tasdiqlaysizmi?"),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Bu amalni ortga qaytarib bo'lmaydi!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.red,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(vertical: 13),
                    side:
                    const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Bekor qilish',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    padding:
                    const EdgeInsets.symmetric(vertical: 13),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("O'chirish",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}