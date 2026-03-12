import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/student_model.dart';

// ─── Group → Ustoz mapping ────────────────────────────────────────────────────

const Map<String, String> guruhUstozMap = {
  'Backend 36':        'Otabek Tursunov',
  'Backend 42':        'Otabek Tursunov',
  'Backend 45':        'Sardor Alimov',
  'Frontend 28':       'Asadbek Mahmudov',
  'Frontend 31':       'Asadbek Mahmudov',
  "Frontend 35":       "Nodira Ro'ziyeva",
  'Flutter 12':        'Shaxzodbek Baxtiyorov',
  'Flutter 15':        'Shaxzodbek Baxtiyorov',
  'Kiberxavfsizlik 05':'Shukululloh Zaylobiddinov',
  'Kiberxavfsizlik 08':'Shukululloh Zaylobiddinov',
};

// ─── All ustozlar & guruhlar (for filters) ────────────────────────────────────

final List<String> allOquvchiUstozlar = guruhUstozMap.values.toSet().toList()
  ..sort();

final List<String> allOquvchiGuruhlar = studentsHaftalik
    .map((s) => s.group)
    .toSet()
    .toList()
  ..sort();

// ─── Helpers ──────────────────────────────────────────────────────────────────

Color oquvchiGroupColor(String group) {
  if (group.startsWith('Backend'))         return const Color(0xFF3B82F6);
  if (group.startsWith('Frontend'))        return const Color(0xFF8B5CF6);
  if (group.startsWith('Flutter'))         return const Color(0xFF06B6D4);
  if (group.startsWith('Kiberxavfsizlik')) return const Color(0xFFEF4444);
  return AppColors.primary;
}

Color oquvchiAvatarColor(String hex) {
  try {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  } catch (_) {
    return AppColors.primary;
  }
}

String oquvchiFormatCoins(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

// Rank badge color
Color rankColor(int rank) {
  if (rank == 1) return const Color(0xFFFFB800); // gold
  if (rank == 2) return const Color(0xFFC0C0C0); // silver
  if (rank == 3) return const Color(0xFFCD7F32); // bronze
  return AppColors.textSecondary;
}

Color rankBgColor(int rank) {
  if (rank == 1) return const Color(0xFFFFFBEB);
  if (rank == 2) return const Color(0xFFF3F4F6);
  if (rank == 3) return const Color(0xFFFFF7ED);
  return const Color(0xFFF3F4F6);
}