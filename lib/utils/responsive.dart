import 'package:flutter/material.dart';

/// Breakpoints
/// phone:   < 600px
/// tablet:  600 – 900px
/// desktop: > 900px

class Responsive {
  final double width;
  final double height;

  const Responsive._({required this.width, required this.height});

  factory Responsive.of(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Responsive._(width: size.width, height: size.height);
  }

  // ── Breakpoints ───────────────────────────────────────────────
  bool get isPhone   => width < 600;
  bool get isTablet  => width >= 600 && width < 900;
  bool get isDesktop => width >= 900;

  // ── Spacing ───────────────────────────────────────────────────
  double get padH   => isPhone ? 16 : isTablet ? 24 : 32;
  double get padV   => isPhone ? 16 : isTablet ? 20 : 24;
  double get gapSm  => isPhone ? 8  : 12;
  double get gapMd  => isPhone ? 12 : isTablet ? 16 : 20;
  double get gapLg  => isPhone ? 16 : isTablet ? 24 : 32;

  // ── Font sizes ────────────────────────────────────────────────
  double get fontXs  => isPhone ? 10 : 11;
  double get fontSm  => isPhone ? 12 : isTablet ? 13 : 14;
  double get fontMd  => isPhone ? 14 : isTablet ? 15 : 16;
  double get fontLg  => isPhone ? 16 : isTablet ? 18 : 20;
  double get fontXl  => isPhone ? 18 : isTablet ? 22 : 26;
  double get fontXxl => isPhone ? 22 : isTablet ? 26 : 30;

  // ── Icon / Avatar sizes ───────────────────────────────────────
  double get iconSm   => isPhone ? 18 : 20;
  double get iconMd   => isPhone ? 22 : 24;
  double get iconLg   => isPhone ? 26 : 30;
  double get avatarSm => isPhone ? 36 : isTablet ? 42 : 48;
  double get avatarMd => isPhone ? 44 : isTablet ? 52 : 60;
  double get avatarLg => isPhone ? 52 : isTablet ? 64 : 72;

  // ── Radius ────────────────────────────────────────────────────
  double get radiusSm => isPhone ? 8  : 10;
  double get radiusMd => isPhone ? 12 : isTablet ? 14 : 16;
  double get radiusLg => isPhone ? 16 : isTablet ? 20 : 24;

  // ── Grid ──────────────────────────────────────────────────────
  int get statGridCols    => isPhone ? 2 : isTablet ? 3 : 4;
  int get cardGridCols    => isPhone ? 1 : isTablet ? 2 : 3;

  // ── Chart heights ─────────────────────────────────────────────
  double get chartHeightSm => isPhone ? 180 : isTablet ? 220 : 260;
  double get chartHeightMd => isPhone ? 200 : isTablet ? 250 : 300;
  double get chartHeightLg => isPhone ? 220 : isTablet ? 280 : 340;

  // ── Convenience: scale a value ────────────────────────────────
  double scale(double phone, {double? tablet, double? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? phone * 1.3;
    if (isTablet)  return tablet  ?? phone * 1.15;
    return phone;
  }
}

/// Extension for quick access
extension ResponsiveContext on BuildContext {
  Responsive get r => Responsive.of(this);
}