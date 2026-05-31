import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../services/config/api_config.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum UstozStatus { faol, nofaol }

// ─── Model ────────────────────────────────────────────────────────────────────

class UstozModel {
  final String id;
  final String ism;
  final String email;
  final String kurs;
  final String bio;
  final int guruhlarSoni;
  final int oquvchilarSoni;
  final int pointLimit;
  final UstozStatus status;
  final String avatarEmoji;
  final String avatarColor;
  final String? avatarUrl; // backend `avatar` (rasm URL)

  UstozModel({
    required this.id,
    required this.ism,
    required this.email,
    required this.kurs,
    this.bio = '',
    required this.guruhlarSoni,
    required this.oquvchilarSoni,
    this.pointLimit = 0,
    required this.status,
    required this.avatarEmoji,
    required this.avatarColor,
    this.avatarUrl,
  });

  UstozModel copyWith({
    String? ism,
    String? email,
    String? kurs,
    String? bio,
    int? guruhlarSoni,
    int? oquvchilarSoni,
    int? pointLimit,
    UstozStatus? status,
    String? avatarEmoji,
    String? avatarColor,
    String? avatarUrl,
  }) =>
      UstozModel(
        id: id,
        ism: ism ?? this.ism,
        email: email ?? this.email,
        kurs: kurs ?? this.kurs,
        bio: bio ?? this.bio,
        guruhlarSoni: guruhlarSoni ?? this.guruhlarSoni,
        oquvchilarSoni: oquvchilarSoni ?? this.oquvchilarSoni,
        pointLimit: pointLimit ?? this.pointLimit,
        status: status ?? this.status,
        avatarEmoji: avatarEmoji ?? this.avatarEmoji,
        avatarColor: avatarColor ?? this.avatarColor,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );

  String get statusLabel => status == UstozStatus.faol ? 'Faol' : 'Nofaol';

  // ── JSON ──────────────────────────────────────────────────────────────────

  /// Backend `Mentor` shakli:
  /// `{id, user:{username,email,role}, bio, avatar, direction,
  ///   point_limit, groups:[{active, course:{name}}], total_students}`
  factory UstozModel.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) =>
        v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? 0;

    final id = (json['id'] ?? '').toString();
    final user = json['user'] as Map<String, dynamic>?;
    final username = (user?['username'] ?? '').toString();
    final email = (json['email'] ?? user?['email'] ?? '').toString();

    final groups = (json['groups'] as List?) ?? const [];
    final hasActive =
        groups.any((g) => g is Map && g['active'] == true);

    // Kurs (direction) — bo'sh bo'lsa guruhlardagi eng ko'p uchragan kursdan.
    var kurs = (json['direction'] ?? '').toString().trim();
    if (kurs.isEmpty) kurs = _topCourse(groups);

    final avatar = (json['avatar'] ?? '').toString();

    return UstozModel(
      id: id,
      ism: username.isEmpty ? 'Ustoz' : username,
      email: email,
      kurs: kurs,
      bio: (json['bio'] ?? '').toString(),
      guruhlarSoni: groups.length,
      oquvchilarSoni: asInt(json['total_students']),
      pointLimit: asInt(json['point_limit']),
      status: hasActive ? UstozStatus.faol : UstozStatus.nofaol,
      avatarEmoji: '🧑‍🏫',
      avatarColor: _colorForSeed(id.isNotEmpty ? id : username),
      avatarUrl: avatar.isEmpty ? null : ApiConfig.absoluteUrl(avatar),
    );
  }

  static String _topCourse(List groups) {
    final counts = <String, int>{};
    for (final g in groups) {
      if (g is Map && g['course'] is Map) {
        final name = (g['course']['name'] ?? '').toString();
        if (name.isNotEmpty) counts[name] = (counts[name] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return '';
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  static const List<String> _palette = [
    '#3B82F6', '#8B5CF6', '#EF4444', '#06B6D4',
    '#A855F7', '#F97316', '#059669', '#F59E0B',
  ];

  static String _colorForSeed(String seed) {
    if (seed.isEmpty) return _palette.first;
    final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b);
    return _palette[hash % _palette.length];
  }
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