import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/owner_model.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/owner/dashboard/owner_stat_card.dart';
import '../../../widgets/owner/dashboard/owner_welcome_card.dart';
import '../../../widgets/owner/dashboard/owner_bar_chart.dart';
import '../../../widgets/owner/dashboard/owner_admin_tile.dart';
import '../../../widgets/owner/dashboard/owner_line_chart.dart';
import '../../../widgets/owner/dashboard/owner_davomat_chart.dart';

class OwnerDashboardPage extends StatelessWidget {
  const OwnerDashboardPage({super.key});

  static final _owner = OwnerModel.mock();

  @override
  Widget build(BuildContext context) {
    final owner = _owner;
    final r = context.r;

    final stats = [
      OwnerStat(
        label: "Jami o'quvchilar",
        value: '${owner.jami0quvchilar}',
        growth: '+12%',
        icon: Icons.person_outline_rounded,
        iconColor: const Color(0xFF3B82F6),
        iconBg: const Color(0xFFEFF6FF),
      ),
      OwnerStat(
        label: 'Jami ustozlar',
        value: '${owner.jamiUstozlar}',
        growth: '+5%',
        icon: Icons.school_outlined,
        iconColor: const Color(0xFF059669),
        iconBg: const Color(0xFFECFDF5),
      ),
      OwnerStat(
        label: 'Faol guruhlar',
        value: '${owner.faolGuruhlar}',
        growth: '+8%',
        icon: Icons.groups_2_outlined,
        iconColor: const Color(0xFFF97316),
        iconBg: const Color(0xFFFFF7ED),
      ),
      OwnerStat(
        label: 'Jami coinlar',
        value: ownerFmtCoins(owner.jamiCoinlar),
        growth: '+18%',
        icon: Icons.monetization_on_outlined,
        iconColor: const Color(0xFF8B5CF6),
        iconBg: const Color(0xFFF5F3FF),
      ),
      OwnerStat(
        label: 'Adminlar',
        value: '${owner.adminlar}',
        growth: '+2',
        icon: Icons.shield_outlined,
        iconColor: const Color(0xFFEF4444),
        iconBg: const Color(0xFFFEF2F2),
      ),
      OwnerStat(
        label: 'Kurslar',
        value: '${owner.kurslar}',
        growth: '+1',
        icon: Icons.menu_book_outlined,
        iconColor: const Color(0xFF6366F1),
        iconBg: const Color(0xFFEEF2FF),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(r.padH, r.padV, r.padH, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Title ──────────────────────────────────────────────
              Text(
                'Ega Dashboard',
                style: TextStyle(
                    fontSize: r.fontXxl + 2,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                "Platformaning to'liq statistikasi va nazorat paneli",
                style: TextStyle(
                    fontSize: r.fontSm,
                    color: AppColors.textSecondary),
              ),
              SizedBox(height: r.gapLg),

              // ── Stat cards ─────────────────────────────────────────
              // Phone: 2×3 grid | Tablet: 3×2 grid | Desktop: 6 horizontal
              r.isDesktop
                  ? Row(
                children: stats.map((s) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: s != stats.last ? r.gapMd : 0),
                    child: OwnerStatCard(stat: s),
                  ),
                )).toList(),
              )
                  : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: stats.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: r.statGridCols,
                  crossAxisSpacing: r.gapMd,
                  mainAxisSpacing: r.gapMd,
                  childAspectRatio:
                  r.isPhone ? 1.0 : 1.1,
                ),
                itemBuilder: (_, i) => OwnerStatCard(stat: stats[i]),
              ),
              SizedBox(height: r.gapLg),

              // ── Charts row ─────────────────────────────────────────
              // Phone: column | Tablet+: side by side
              r.isPhone
                  ? Column(children: [
                _ChartCard(
                  title: 'Haftalik Coinlar',
                  trailing: Text('Oxirgi hafta',
                      style: TextStyle(
                          fontSize: r.fontSm,
                          color: AppColors.textSecondary)),
                  child: OwnerLineChart(
                    data: owner.haftalikCoinlar,
                    labels: owner.haftalikLabels,
                    color: AppColors.primary,
                    height: r.chartHeightMd,
                  ),
                ),
                SizedBox(height: r.gapMd),
                _ChartCard(
                  title: "Guruh bo'yicha Coinlar",
                  trailing: Text(
                      'Jami: ${ownerFmtCoins(owner.jamiCoinlar)}',
                      style: TextStyle(
                          fontSize: r.fontSm,
                          color: AppColors.textSecondary)),
                  child: OwnerBarChart(
                    data: owner.guruhCoinlar,
                    labels: owner.guruhLabels,
                    height: r.chartHeightLg,
                    barColor: AppColors.orange,
                  ),
                ),
              ])
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _ChartCard(
                      title: 'Haftalik Coinlar',
                      trailing: Text('Oxirgi hafta',
                          style: TextStyle(
                              fontSize: r.fontSm,
                              color: AppColors.textSecondary)),
                      child: OwnerLineChart(
                        data: owner.haftalikCoinlar,
                        labels: owner.haftalikLabels,
                        color: AppColors.primary,
                        height: r.chartHeightMd,
                      ),
                    ),
                  ),
                  SizedBox(width: r.gapMd),
                  Expanded(
                    child: _ChartCard(
                      title: "Guruh bo'yicha Coinlar",
                      trailing: Text(
                          'Jami: ${ownerFmtCoins(owner.jamiCoinlar)}',
                          style: TextStyle(
                              fontSize: r.fontSm,
                              color: AppColors.textSecondary)),
                      child: OwnerBarChart(
                        data: owner.guruhCoinlar,
                        labels: owner.guruhLabels,
                        height: r.chartHeightMd,
                        barColor: AppColors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: r.gapMd),

              // ── Davomat ────────────────────────────────────────────
              // Desktop: statlar yuqori o'ngda (inline)
              // Phone/Tablet: OwnerDavomatChart widget (alohida)
              r.isDesktop
                  ? _DavomatCardDesktop(owner: owner)
                  : OwnerDavomatChart(owner: owner),
              SizedBox(height: r.gapMd),

              // ── Welcome card ───────────────────────────────────────
              _WelcomeCardResponsive(owner: owner),
              SizedBox(height: r.gapLg),

              // ── Oxirgi Adminlar ────────────────────────────────────
              _OxirgiAdminlarCard(owner: owner),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Chart Card ───────────────────────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;

  const _ChartCard({
    required this.title,
    this.trailing,
    required this.child,
  });

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
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontSize: r.fontLg,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: r.gapMd),
          child,
        ],
      ),
    );
  }
}

// ─── Davomat Card Desktop ─────────────────────────────────────────────────────
// Statlar yuqori o'ngda inline ko'rinadi

class _DavomatCardDesktop extends StatelessWidget {
  final OwnerModel owner;
  const _DavomatCardDesktop({required this.owner});

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
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: icon+title | stats
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.how_to_reg_outlined,
                  size: r.iconMd, color: const Color(0xFF059669)),
              SizedBox(width: r.gapSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kunlik Davomat (Oxirgi 14 kun)',
                      style: TextStyle(
                          fontSize: r.fontLg,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary),
                    ),
                    Text(
                      "O'quvchilarning darsga qatnashish dinamikasi",
                      style: TextStyle(
                          fontSize: r.fontSm,
                          color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              // Stats inline (desktop only)
              Row(children: [
                _InlineStat(
                  value: '${owner.ortachaDavomat}%',
                  label: "O'rtacha davomat",
                  color: const Color(0xFF059669),
                  fontSize: r.fontXl,
                  labelSize: r.fontSm,
                ),
                SizedBox(width: r.gapLg),
                _InlineStat(
                  value: '${owner.bugunQatnashdi}',
                  label: 'Bugun qatnashdi',
                  color: AppColors.primary,
                  fontSize: r.fontXl,
                  labelSize: r.fontSm,
                ),
              ]),
            ],
          ),
          SizedBox(height: r.gapMd),

          // Chart
          OwnerLineChart(
            data: owner.davomatData,
            labels: owner.davomatLabels,
            color: const Color(0xFF059669),
            filled: true,
            height: r.chartHeightLg,
          ),
          SizedBox(height: r.gapMd),

          // Legend
          Row(children: [
            _LegendDot(
                color: const Color(0xFF059669),
                label: 'Qatnashganlar'),
            SizedBox(width: r.gapLg),
            _LegendDot(
                color: Colors.grey.shade400,
                label: "Jami o'quvchilar",
                hollow: true),
          ]),
        ],
      ),
    );
  }
}

class _InlineStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final double fontSize;
  final double labelSize;

  const _InlineStat({
    required this.value,
    required this.label,
    required this.color,
    required this.fontSize,
    required this.labelSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                color: color)),
        Text(label,
            style: TextStyle(
                fontSize: labelSize,
                color: AppColors.textSecondary)),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool hollow;

  const _LegendDot(
      {required this.color, required this.label, this.hollow = false});

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 10, height: 10,
        decoration: BoxDecoration(
          color: hollow ? Colors.transparent : color,
          shape: BoxShape.circle,
          border:
          hollow ? Border.all(color: color, width: 1.5) : null,
        ),
      ),
      const SizedBox(width: 6),
      Text(label,
          style: TextStyle(
              fontSize: r.fontSm, color: AppColors.textSecondary)),
    ]);
  }
}

// ─── Welcome Card Responsive ──────────────────────────────────────────────────
// Desktop: 4 mini stat yonma-yon bir qatorda
// Phone/Tablet: 2×2 grid

class _WelcomeCardResponsive extends StatelessWidget {
  final OwnerModel owner;
  const _WelcomeCardResponsive({required this.owner});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final miniStats = [
      _MiniData('${owner.welcomeAdminlar}', 'Adminlar'),
      _MiniData('${owner.welcomeKurslar}', 'Kurslar'),
      _MiniData('${owner.welcomeOqituvchilar}', "O'qituvchilar"),
      _MiniData('${owner.welcomeOquvchilar}', "O'quvchilar"),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.padV + 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(r.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Xush kelibsiz, Ega!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: r.fontXl,
                  fontWeight: FontWeight.w900)),
          SizedBox(height: r.gapSm),
          Text(
            "Platforma to'liq nazorat ostida. Barcha tizim funktsiyalari bilan ishlashingiz mumkin.",
            style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: r.fontSm,
                height: 1.4),
          ),
          SizedBox(height: r.gapLg),

          // Desktop & Tablet → 4 ta yonma-yon | Phone → 2×2
          r.isPhone
              ? Column(children: [
            Row(children: [
              Expanded(child: _MiniStatBox(data: miniStats[0])),
              SizedBox(width: r.gapMd),
              Expanded(child: _MiniStatBox(data: miniStats[1])),
            ]),
            SizedBox(height: r.gapMd),
            Row(children: [
              Expanded(child: _MiniStatBox(data: miniStats[2])),
              SizedBox(width: r.gapMd),
              Expanded(child: _MiniStatBox(data: miniStats[3])),
            ]),
          ])
              : Row(
            children: miniStats.map((d) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: d != miniStats.last ? r.gapMd : 0),
                child: _MiniStatBox(data: d),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _MiniData {
  final String value;
  final String label;
  const _MiniData(this.value, this.label);
}

class _MiniStatBox extends StatelessWidget {
  final _MiniData data;
  const _MiniStatBox({required this.data});

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: r.padH, vertical: r.padV - 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(r.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: r.fontXxl,
                  fontWeight: FontWeight.w900)),
          SizedBox(height: r.gapSm / 2),
          Text(data.label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: r.fontSm,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─── Oxirgi Adminlar Card ─────────────────────────────────────────────────────

class _OxirgiAdminlarCard extends StatelessWidget {
  final OwnerModel owner;
  const _OxirgiAdminlarCard({required this.owner});

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
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Oxirgi Adminlar',
              style: TextStyle(
                  fontSize: r.fontLg,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          SizedBox(height: r.gapMd),

          // Phone → list | Tablet/Desktop → grid 2 ustun
          r.isPhone
              ? Column(
            children: owner.oxirgiAdminlar
                .map((a) => Padding(
              padding:
              EdgeInsets.only(bottom: r.gapSm),
              child: OwnerAdminTile(admin: a),
            ))
                .toList(),
          )
              : LayoutBuilder(builder: (ctx, constraints) {
            final itemW =
                (constraints.maxWidth - r.gapMd) / 2;
            return Wrap(
              spacing: r.gapMd,
              runSpacing: r.gapSm,
              children: owner.oxirgiAdminlar
                  .map((a) => SizedBox(
                width: itemW,
                child: OwnerAdminTile(admin: a),
              ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}