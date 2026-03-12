import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../utils/responsive.dart';
import '../../../models/owner_model.dart';

class OwnerStatCard extends StatelessWidget {
  final OwnerStat stat;

  const OwnerStatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      padding: EdgeInsets.all(r.padV),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: r.avatarMd,
            height: r.avatarMd,
            decoration: BoxDecoration(
              color: stat.iconBg,
              borderRadius: BorderRadius.circular(r.radiusMd),
            ),
            child: Icon(stat.icon, color: stat.iconColor, size: r.iconMd),
          ),
          SizedBox(height: r.gapMd),
          Text(
            stat.value,
            style: TextStyle(
                fontSize: r.fontXxl,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            style: TextStyle(
                fontSize: r.fontSm,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: r.gapSm),
          Row(children: [
            const Icon(Icons.trending_up_rounded,
                size: 14, color: Color(0xFF059669)),
            const SizedBox(width: 3),
            Text(
              stat.growth,
              style: TextStyle(
                  fontSize: r.fontSm,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF059669)),
            ),
          ]),
        ],
      ),
    );
  }
}