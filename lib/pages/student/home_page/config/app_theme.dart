import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFFF7F8FA);
  static const cardWhite = Colors.white;
  static const darkCard1 = Color(0xFF5B5F6A);
  static const darkCard2 = Color(0xFF3F434C);
  static const blue1 = Color(0xFF2D7BFF);
  static const blue2 = Color(0xFF1F62D6);
  static const orange = Color(0xFFFF6B35);
  static const green = Color(0xFF4CAF50);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const coinGold = Color(0xFFFFB800);
  static const greenTile = Color(0xFF2ECC40);
  static const purpleTile = Color(0xFF8B5CF6);
  static const orangeTile = Color(0xFFF59E0B);
}

class AppTextStyles {
  static const greeting = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  static const subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );
  static const cardTitle = TextStyle(
    fontSize: 13,
    color: Colors.white70,
    fontWeight: FontWeight.w500,
  );
  static const bigNumber = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.coinGold,
  );
  static const sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
}
