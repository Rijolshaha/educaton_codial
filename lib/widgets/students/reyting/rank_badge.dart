import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class RankBadge extends StatelessWidget {
  final int rank;

  const RankBadge({super.key, required this.rank});

  @override
  Widget build(BuildContext context) {
    if (rank <= 3) {
      const medals = ['🥇', '🥈', '🥉'];
      return SizedBox(
        width: 36,
        child: Center(
          child: Text(medals[rank - 1], style: const TextStyle(fontSize: 22)),
        ),
      );
    }
    return SizedBox(
      width: 36,
      child: Center(
        child: Text(
          '#$rank',
          style: TextStyle(
            color: AppColors.textHint,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}