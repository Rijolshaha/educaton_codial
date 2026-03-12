import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../utils/responsive.dart';
import '../../../models/owner_admin_model.dart';

class OwnerAdminCard extends StatelessWidget {
  final OwnerAdminModel admin;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OwnerAdminCard({
    super.key,
    required this.admin,
    required this.onToggleStatus,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      margin: EdgeInsets.only(bottom: r.gapMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.radiusLg),
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
          // ── Blue gradient header ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(r.padV),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.78)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(r.radiusLg)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: r.avatarMd,
                    height: r.avatarMd,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withOpacity(0.4), width: 2),
                    ),
                    child: Center(
                      child: Text(admin.avatarEmoji,
                          style: TextStyle(fontSize: r.iconLg)),
                    ),
                  ),
                  SizedBox(width: r.gapMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(admin.ism,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: r.fontLg,
                                fontWeight: FontWeight.w800)),
                        SizedBox(height: r.gapSm / 2),
                        Row(children: [
                          const Icon(Icons.email_outlined,
                              size: 12, color: Colors.white70),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(admin.email,
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: r.fontSm),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ]),
                SizedBox(height: r.gapMd),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: r.gapMd, vertical: r.gapSm / 2 + 2),
                  decoration: BoxDecoration(
                    color: admin.isFaol
                        ? const Color(0xFF059669)
                        : AppColors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      admin.isFaol
                          ? Icons.check_circle_outline_rounded
                          : Icons.cancel_outlined,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      admin.isFaol ? 'Faol' : 'Nofaol',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: r.fontSm,
                          fontWeight: FontWeight.w700),
                    ),
                  ]),
                ),
              ],
            ),
          ),

          // ── White body ──
          Padding(
            padding: EdgeInsets.all(r.padV),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(admin.lavozim,
                    style: TextStyle(
                        fontSize: r.fontMd,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: r.gapMd),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                SizedBox(height: r.gapMd),
                Text('Yaratilgan: ${admin.yaratilgan}',
                    style: TextStyle(
                        fontSize: r.fontSm,
                        color: AppColors.textSecondary)),
                SizedBox(height: r.gapMd),
                Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onToggleStatus,
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(vertical: r.gapMd - 1),
                        decoration: BoxDecoration(
                          color: admin.isFaol
                              ? const Color(0xFFF3F4F6)
                              : const Color(0xFFECFDF5),
                          borderRadius:
                          BorderRadius.circular(r.radiusMd),
                        ),
                        child: Center(
                          child: Text(
                            admin.isFaol
                                ? 'Nofaol qilish'
                                : 'Faollashtirish',
                            style: TextStyle(
                              fontSize: r.fontSm,
                              fontWeight: FontWeight.w700,
                              color: admin.isFaol
                                  ? AppColors.textPrimary
                                  : const Color(0xFF059669),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: r.gapSm),
                  _ActionBtn(
                    icon: Icons.edit_outlined,
                    color: AppColors.primary,
                    bg: AppColors.primary.withOpacity(0.08),
                    size: r.avatarSm,
                    iconSize: r.iconSm,
                    radius: r.radiusMd,
                    onTap: onEdit,
                  ),
                  SizedBox(width: r.gapSm),
                  _ActionBtn(
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.red,
                    bg: AppColors.red.withOpacity(0.08),
                    size: r.avatarSm,
                    iconSize: r.iconSm,
                    radius: r.radiusMd,
                    onTap: onDelete,
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final double size;
  final double iconSize;
  final double radius;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.bg,
    required this.size,
    required this.iconSize,
    required this.radius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(radius)),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}