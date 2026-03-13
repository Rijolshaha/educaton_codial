import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

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