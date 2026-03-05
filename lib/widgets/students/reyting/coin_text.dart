import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class CoinText extends StatelessWidget {
  final int coins;
  final double fontSize;
  final Color color;

  const CoinText({
    super.key,
    required this.coins,
    this.fontSize = 15,
    this.color = AppColors.text,
  });

  String _format(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🪙', style: TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text(
          _format(coins),
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: fontSize,
            color: color,
          ),
        ),
      ],
    );
  }
}