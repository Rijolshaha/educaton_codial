import 'package:flutter/material.dart';

class GuruhCardBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;
  final bool compact;

  const GuruhCardBtn({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 8, horizontal: compact ? 12 : 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            if (!compact && label.isNotEmpty) ...[
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}