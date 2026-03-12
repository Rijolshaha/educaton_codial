import 'package:flutter/material.dart';

/// Barcha widgetlar shu fayldan import qiladi.
/// app_theme.dart dagi AppColors bilan to'liq mos.
class AppColors {
  AppColors._();

  // ── Background ─────────────────────────────────────────────────────────────
  static const Color bg          = Color(0xFFF7F8FA);
  static const Color scaffold    = Color(0xFFF7F8FA);
  static const Color bgCard      = Color(0xFFF3F4F6);

  // ── Card ───────────────────────────────────────────────────────────────────
  static const Color cardWhite   = Colors.white;
  static const Color cardBg      = Colors.white;
  static const Color white       = Colors.white;

  // ── Dark cards (Level card gradient) ──────────────────────────────────────
  static const Color darkCard1   = Color(0xFF5B5F6A);
  static const Color darkCard2   = Color(0xFF3F434C);

  // ── Blue ───────────────────────────────────────────────────────────────────
  static const Color blue        = Color(0xFF3B82F6);
  static const Color blue1       = Color(0xFF2D7BFF); // coins card, news banner
  static const Color blue2       = Color(0xFF1F62D6); // coins card gradient
  static const Color primary     = Color(0xFF4F6EF7);
  static const Color primaryDark = Color(0xFF2563EB);
  static const Color primaryDeep = Color(0xFF1D4ED8);

  // ── Orange ─────────────────────────────────────────────────────────────────
  static const Color orange      = Color(0xFFFF6B35); // rank card
  static const Color orangeDark  = Color(0xFFEA580C);
  static const Color orangeTile  = Color(0xFFF59E0B); // quick actions tile

  // ── Green ──────────────────────────────────────────────────────────────────
  static const Color green       = Color(0xFF4CAF50); // latest rewards coins
  static const Color greenDark   = Color(0xFF059669);
  static const Color greenLight  = Color(0xFFDCFCE7);
  static const Color greenText   = Color(0xFF16A34A);
  static const Color greenTile   = Color(0xFF2ECC40); // quick actions tile

  // ── Purple ─────────────────────────────────────────────────────────────────
  static const Color purple      = Color(0xFF8B5CF6);
  static const Color purpleDark  = Color(0xFF7C3AED);
  static const Color purpleDeep  = Color(0xFF6D28D9);
  static const Color purpleTile  = Color(0xFF8B5CF6); // quick actions tile

  // ── Red ────────────────────────────────────────────────────────────────────
  static const Color red         = Color(0xFFEF4444);

  // ── Coin / Gold ────────────────────────────────────────────────────────────
  static const Color coinGold    = Color(0xFFFFB800); // coins card number
  static const Color gold        = Color(0xFFFFD700);
  static const Color silver      = Color(0xFFC0C0C0);
  static const Color bronze      = Color(0xFFCD7F32);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A1A2E); // sectionTitle, grids
  static const Color text          = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280); // subtitles
  static const Color textSecond    = Color(0xFF6B7280);
  static const Color textHint      = Color(0xFF9CA3AF);

  // ── Divider ────────────────────────────────────────────────────────────────
  static const Color divider     = Color(0xFFF3F4F6);
}