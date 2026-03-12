import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class GuruhInlineDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final void Function(T?) onChanged;

  const GuruhInlineDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 56,
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                hint: Text(hint,
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 12)),
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 12),
                items: [
                  DropdownMenuItem<T>(
                    value: null,
                    child: Text(hint,
                        style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 12)),
                  ),
                  ...items.map((v) => DropdownMenuItem<T>(
                    value: v,
                    child: Text(labelBuilder(v)),
                  )),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}