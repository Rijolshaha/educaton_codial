import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class GuruhConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const GuruhConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_outline,
                  color: AppColors.red, size: 26),
            ),
            const SizedBox(height: 14),
            Text(title,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text("O'chirish",
                      style:
                      TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(vertical: 13),
                    side: const BorderSide(
                        color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Bekor qilish',
                      style: TextStyle(
                          color: AppColors.textSecondary)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}