import 'package:flutter/material.dart';
import '../services/config/api_config.dart';

// ─── Status ───────────────────────────────────────────────────────────────────

enum OwnerAdminStatus { faol, nofaol }

// ─── Model ────────────────────────────────────────────────────────────────────

class OwnerAdminModel {
  final String id;
  final String ism;
  final String email;
  final String avatarEmoji;
  final Color  avatarColor;
  final String? avatarUrl;     // backend `avatar` (rasm URL)
  final String lavozim;        // Bosh administrator, Kurslar bo'yicha...
  final String yaratilgan;     // 2025-08-15
  OwnerAdminStatus status;

  OwnerAdminModel({
    required this.id,
    required this.ism,
    required this.email,
    required this.avatarEmoji,
    required this.avatarColor,
    this.avatarUrl,
    required this.lavozim,
    required this.yaratilgan,
    required this.status,
  });

  bool get isFaol => status == OwnerAdminStatus.faol;

  OwnerAdminModel copyWith({
    String? ism,
    String? email,
    String? lavozim,
    String? avatarUrl,
    OwnerAdminStatus? status,
  }) => OwnerAdminModel(
    id:           id,
    ism:          ism ?? this.ism,
    email:        email ?? this.email,
    avatarEmoji:  avatarEmoji,
    avatarColor:  avatarColor,
    avatarUrl:    avatarUrl ?? this.avatarUrl,
    lavozim:      lavozim ?? this.lavozim,
    yaratilgan:   yaratilgan,
    status:       status ?? this.status,
  );

  // ── JSON ──────────────────────────────────────────────────────────────────

  /// Backend `Admin` shakli:
  /// `{id, user:{username,email,role}, name, email, description,
  ///   avatar, is_active, created_at}`
  factory OwnerAdminModel.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? '').toString();
    final user = json['user'] as Map<String, dynamic>?;

    String pickStr(List<dynamic> candidates) {
      for (final c in candidates) {
        if (c != null && c.toString().trim().isNotEmpty) return c.toString();
      }
      return '';
    }

    final ism = pickStr([
      json['name'],
      json['ism'],
      json['fullName'],
      user?['username'],
    ]);
    final email = pickStr([json['email'], user?['email']]);

    String yaratilgan = pickStr([
      json['yaratilgan'],
      json['createdAt'],
      json['created_at'],
    ]);
    if (yaratilgan.length >= 10) yaratilgan = yaratilgan.substring(0, 10);

    final avatar = pickStr([json['avatar'], json['avatarUrl']]);

    return OwnerAdminModel(
      id: id,
      ism: ism,
      email: email,
      avatarEmoji: (json['avatarEmoji'] ?? '🧑‍💼').toString(),
      avatarColor: OwnerAdminPalette.pick(id.isNotEmpty ? id : email),
      avatarUrl: avatar.isEmpty ? null : ApiConfig.absoluteUrl(avatar),
      lavozim: pickStr([
        json['description'],
        json['lavozim'],
        json['role'],
        json['position'],
      ]),
      yaratilgan: yaratilgan,
      status: _statusFromJson(json),
    );
  }

  /// Backendga yuborish uchun (PATCH /admins/{id}/).
  Map<String, dynamic> toJson() => {
    'name': ism,
    'email': email,
    'description': lavozim,
    'is_active': isFaol,
  };

  static OwnerAdminStatus _statusFromJson(Map<String, dynamic> json) {
    final raw = json['is_active'] ??
        json['isActive'] ??
        json['status'] ??
        json['isFaol'];
    if (raw is bool) return raw ? OwnerAdminStatus.faol : OwnerAdminStatus.nofaol;
    if (raw is String) {
      final s = raw.toLowerCase();
      if (s == 'nofaol' || s == 'inactive' || s == 'false') {
        return OwnerAdminStatus.nofaol;
      }
    }
    return OwnerAdminStatus.faol;
  }
}

// ─── Avatar rang palitrasi ────────────────────────────────────────────────────
// Backend Flutter rangini yubormaydi — shuning uchun id/email asosida barqaror
// rang tanlanadi.

class OwnerAdminPalette {
  OwnerAdminPalette._();

  static const List<Color> _colors = [
    Color(0xFF3B82F6),
    Color(0xFF059669),
    Color(0xFF8B5CF6),
    Color(0xFFF97316),
    Color(0xFFEF4444),
    Color(0xFF0EA5E9),
  ];

  static Color pick(String seed) {
    if (seed.isEmpty) return _colors.first;
    final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b);
    return _colors[hash % _colors.length];
  }
}

// ─── Mock ─────────────────────────────────────────────────────────────────────

List<OwnerAdminModel> mockOwnerAdminlar() => [
  OwnerAdminModel(
    id: 'a1',
    ism: 'Robiya Anvarova',
    email: 'robiya@codial.uz',
    avatarEmoji: '🧑‍💼',
    avatarColor: const Color(0xFF3B82F6),
    lavozim: 'Bosh administrator',
    yaratilgan: '2025-08-15',
    status: OwnerAdminStatus.faol,
  ),
  OwnerAdminModel(
    id: 'a2',
    ism: 'Ilhomjon Ibragimov',
    email: 'ilhomjon@codial.uz',
    avatarEmoji: '🧑‍💻',
    avatarColor: const Color(0xFF059669),
    lavozim: "Kurslar bo'yicha administrator",
    yaratilgan: '2025-09-01',
    status: OwnerAdminStatus.faol,
  ),
  OwnerAdminModel(
    id: 'a3',
    ism: 'Dilyora Tursunova',
    email: 'dilyora@codial.uz',
    avatarEmoji: '👩‍💼',
    avatarColor: const Color(0xFF8B5CF6),
    lavozim: "O'quvchilar bo'limi administratori",
    yaratilgan: '2025-09-10',
    status: OwnerAdminStatus.faol,
  ),
  OwnerAdminModel(
    id: 'a4',
    ism: 'Jamshid Rahimov',
    email: 'jamshid@codial.uz',
    avatarEmoji: '👨‍💼',
    avatarColor: const Color(0xFFF97316),
    lavozim: "Auksionlar bo'limi administratori",
    yaratilgan: '2025-10-20',
    status: OwnerAdminStatus.faol,
  ),
  OwnerAdminModel(
    id: 'a5',
    ism: 'Feruza Alimova',
    email: 'feruza@codial.uz',
    avatarEmoji: '👩‍🔧',
    avatarColor: const Color(0xFFEF4444),
    lavozim: 'Texnik administrator (faol emas)',
    yaratilgan: '2025-11-05',
    status: OwnerAdminStatus.nofaol,
  ),
];