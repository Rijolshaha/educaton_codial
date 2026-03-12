import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum UstozStatus { faol, nofaol }

// ─── Model ────────────────────────────────────────────────────────────────────

class UstozModel {
  final String id;
  final String ism;
  final String email;
  final String kurs;
  final int guruhlarSoni;
  final int oquvchilarSoni;
  final UstozStatus status;
  final String avatarEmoji;
  final String avatarColor;

  UstozModel({
    required this.id,
    required this.ism,
    required this.email,
    required this.kurs,
    required this.guruhlarSoni,
    required this.oquvchilarSoni,
    required this.status,
    required this.avatarEmoji,
    required this.avatarColor,
  });

  UstozModel copyWith({
    String? ism,
    String? email,
    String? kurs,
    int? guruhlarSoni,
    int? oquvchilarSoni,
    UstozStatus? status,
    String? avatarEmoji,
    String? avatarColor,
  }) =>
      UstozModel(
        id: id,
        ism: ism ?? this.ism,
        email: email ?? this.email,
        kurs: kurs ?? this.kurs,
        guruhlarSoni: guruhlarSoni ?? this.guruhlarSoni,
        oquvchilarSoni: oquvchilarSoni ?? this.oquvchilarSoni,
        status: status ?? this.status,
        avatarEmoji: avatarEmoji ?? this.avatarEmoji,
        avatarColor: avatarColor ?? this.avatarColor,
      );

  String get statusLabel => status == UstozStatus.faol ? 'Faol' : 'Nofaol';
}

// ─── Constants ────────────────────────────────────────────────────────────────

const List<String> ustozKurslar = [
  'Backend',
  'Frontend',
  'Flutter',
  'Kiberxavfsizlik',
  'Grafik Dizayn',
  'SMM & Marketing',
];

// ─── Helpers ──────────────────────────────────────────────────────────────────

Color ustozKursColor(String kurs) {
  switch (kurs) {
    case 'Backend':         return const Color(0xFF3B82F6);
    case 'Frontend':        return const Color(0xFF8B5CF6);
    case 'Flutter':         return const Color(0xFF06B6D4);
    case 'Kiberxavfsizlik': return const Color(0xFFEF4444);
    case 'Grafik Dizayn':   return const Color(0xFFA855F7);
    case 'SMM & Marketing': return const Color(0xFFF97316);
    default:                return AppColors.primary;
  }
}

IconData ustozKursIcon(String kurs) {
  switch (kurs) {
    case 'Backend':         return Icons.dns_outlined;
    case 'Frontend':        return Icons.web_outlined;
    case 'Flutter':         return Icons.flutter_dash;
    case 'Kiberxavfsizlik': return Icons.security_outlined;
    case 'Grafik Dizayn':   return Icons.palette_outlined;
    case 'SMM & Marketing': return Icons.trending_up_rounded;
    default:                return Icons.school_outlined;
  }
}

Color ustozAvatarColor(String hex) {
  try {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  } catch (_) {
    return AppColors.primary;
  }
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final List<UstozModel> mockUstozlar = [
  UstozModel(
    id: 'u1',
    ism: 'Otabek Tursunov',
    email: 'otabek@codial.uz',
    kurs: 'Backend',
    guruhlarSoni: 2,
    oquvchilarSoni: 10,
    status: UstozStatus.faol,
    avatarEmoji: '👨‍💻',
    avatarColor: '#3B82F6',
  ),
  UstozModel(
    id: 'u2',
    ism: 'Asadbek Mahmudov',
    email: 'asadbek@codial.uz',
    kurs: 'Frontend',
    guruhlarSoni: 2,
    oquvchilarSoni: 8,
    status: UstozStatus.faol,
    avatarEmoji: '🧑‍🏫',
    avatarColor: '#8B5CF6',
  ),
  UstozModel(
    id: 'u3',
    ism: 'Shukululloh Zaylobiddinov',
    email: 'shukurulloh@codial.uz',
    kurs: 'Kiberxavfsizlik',
    guruhlarSoni: 2,
    oquvchilarSoni: 7,
    status: UstozStatus.faol,
    avatarEmoji: '👨‍🔬',
    avatarColor: '#EF4444',
  ),
  UstozModel(
    id: 'u4',
    ism: 'Shaxzodbek Baxtiyorov',
    email: 'shaxzodbek@codial.uz',
    kurs: 'Flutter',
    guruhlarSoni: 2,
    oquvchilarSoni: 7,
    status: UstozStatus.faol,
    avatarEmoji: '👨‍💼',
    avatarColor: '#06B6D4',
  ),
  UstozModel(
    id: 'u5',
    ism: "Nodira Ro'ziyeva",
    email: 'nodira@codial.uz',
    kurs: 'Frontend',
    guruhlarSoni: 1,
    oquvchilarSoni: 0,
    status: UstozStatus.faol,
    avatarEmoji: '👩‍💻',
    avatarColor: '#8B5CF6',
  ),
  UstozModel(
    id: 'u6',
    ism: 'Sardor Alimov',
    email: 'sardor@codial.uz',
    kurs: 'Backend',
    guruhlarSoni: 1,
    oquvchilarSoni: 0,
    status: UstozStatus.faol,
    avatarEmoji: '🧑‍💻',
    avatarColor: '#3B82F6',
  ),
  UstozModel(
    id: 'u7',
    ism: 'Malika Rahimova',
    email: 'malika.r@codial.uz',
    kurs: 'Grafik Dizayn',
    guruhlarSoni: 0,
    oquvchilarSoni: 0,
    status: UstozStatus.faol,
    avatarEmoji: '👩‍🎨',
    avatarColor: '#A855F7',
  ),
];