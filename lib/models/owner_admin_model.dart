import 'package:flutter/material.dart';

// ─── Status ───────────────────────────────────────────────────────────────────

enum OwnerAdminStatus { faol, nofaol }

// ─── Model ────────────────────────────────────────────────────────────────────

class OwnerAdminModel {
  final String id;
  final String ism;
  final String email;
  final String avatarEmoji;
  final Color  avatarColor;
  final String lavozim;        // Bosh administrator, Kurslar bo'yicha...
  final String yaratilgan;     // 2025-08-15
  OwnerAdminStatus status;

  OwnerAdminModel({
    required this.id,
    required this.ism,
    required this.email,
    required this.avatarEmoji,
    required this.avatarColor,
    required this.lavozim,
    required this.yaratilgan,
    required this.status,
  });

  bool get isFaol => status == OwnerAdminStatus.faol;

  OwnerAdminModel copyWith({
    String? ism,
    String? email,
    String? lavozim,
    OwnerAdminStatus? status,
  }) => OwnerAdminModel(
    id:           id,
    ism:          ism ?? this.ism,
    email:        email ?? this.email,
    avatarEmoji:  avatarEmoji,
    avatarColor:  avatarColor,
    lavozim:      lavozim ?? this.lavozim,
    yaratilgan:   yaratilgan,
    status:       status ?? this.status,
  );
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