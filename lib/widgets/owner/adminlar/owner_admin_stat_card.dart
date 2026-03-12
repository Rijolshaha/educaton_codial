import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../utils/responsive.dart';

class OwnerAdminStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final int count;
  final String label;

  const OwnerAdminStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      margin: EdgeInsets.only(bottom: r.isPhone ? 10 : 0),
      padding: EdgeInsets.symmetric(
          horizontal: r.padH, vertical: r.padV - 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(children: [
        Container(
          width: r.avatarMd,
          height: r.avatarMd,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(r.radiusMd),
          ),
          child: Icon(icon, color: iconColor, size: r.iconMd),
        ),
        SizedBox(width: r.gapMd),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$count',
                style: TextStyle(
                    fontSize: r.fontXxl,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary)),
            Text(label,
                style: TextStyle(
                    fontSize: r.fontSm,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ]),
    );
  }
}