import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../services/config/app_theme.dart';
import '../../../models/dashboard_model.dart';
import '../../../utils/responsive.dart';

class CoinsCard extends StatelessWidget {
  final CoinInfo coins;
  const CoinsCard({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.padV + 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue1, AppColors.blue2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(r.radiusLg),
        boxShadow: [BoxShadow(color: AppColors.blue1.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Jami Coinlaringiz', style: AppTextStyles.cardTitle.copyWith(fontSize: r.fontMd)),
            SizedBox(height: r.gapSm),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text('🪙', style: TextStyle(fontSize: r.scale(28, tablet: 32))),
              SizedBox(width: r.gapSm),
              Text(_fmt(coins.total), style: TextStyle(fontSize: r.scale(34, tablet: 40, desktop: 46), fontWeight: FontWeight.w800, color: AppColors.coinGold)),
            ]),
            SizedBox(height: r.gapSm / 2),
            Text('Keyingi level uchun ${coins.coinsForNextLevel} coin kerak',
                style: TextStyle(fontSize: r.fontSm, color: Colors.white70)),
          ]),
        ),
        Container(
          width: r.avatarMd, height: r.avatarMd,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(r.radiusMd)),
          child: Center(child: Text('🪙', style: TextStyle(fontSize: r.scale(24, tablet: 28)))),
        ),
      ]),
    );
  }

  String _fmt(int n) {
    if (n >= 1000) { final s = n.toString(); return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}'; }
    return n.toString();
  }
}