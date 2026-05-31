import 'package:flutter/material.dart';

// ─── Owner Stat ───────────────────────────────────────────────────────────────

class OwnerStat {
  final String label;
  final String value;
  final String growth;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const OwnerStat({
    required this.label,
    required this.value,
    required this.growth,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });
}

// ─── Owner Admin ──────────────────────────────────────────────────────────────

class OwnerAdmin {
  final String id;
  final String ism;
  final String email;
  final String avatarEmoji;
  final bool isFaol;

  const OwnerAdmin({
    required this.id,
    required this.ism,
    required this.email,
    required this.avatarEmoji,
    required this.isFaol,
  });

  factory OwnerAdmin.fromJson(Map<String, dynamic> json) {
    final raw = json['isFaol'] ?? json['status'] ?? json['isActive'];
    bool faol = true;
    if (raw is bool) faol = raw;
    if (raw is String) {
      final s = raw.toLowerCase();
      faol = !(s == 'nofaol' || s == 'inactive' || s == 'false');
    }
    return OwnerAdmin(
      id: (json['id'] ?? '').toString(),
      ism: (json['ism'] ?? json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      avatarEmoji: (json['avatarEmoji'] ?? '🧑‍💼').toString(),
      isFaol: faol,
    );
  }
}

// ─── Owner Model ──────────────────────────────────────────────────────────────

class OwnerModel {
  final String name;
  final String avatarEmoji;

  // top stats
  final int jami0quvchilar;
  final int jamiUstozlar;
  final int faolGuruhlar;
  final int jamiCoinlar;
  final int adminlar;
  final int kurslar;

  // jami coinlarning haftalik o'sishi (% — manfiy ham bo'lishi mumkin)
  final int coinGrowthPct;

  // charts
  final List<int> haftalikCoinlar;   // 7 ta (Dush→Shan)
  final List<String> haftalikLabels;
  final List<int> guruhCoinlar;      // har guruh uchun
  final List<String> guruhLabels;
  final List<int> davomatData;       // 14 kun
  final List<String> davomatLabels;
  final int ortachaDavomat;          // %
  final int bugunQatnashdi;

  // welcome card mini stats
  final int welcomeAdminlar;
  final int welcomeKurslar;
  final int welcomeOqituvchilar;
  final int welcomeOquvchilar;

  // recent admins
  final List<OwnerAdmin> oxirgiAdminlar;

  const OwnerModel({
    required this.name,
    required this.avatarEmoji,
    required this.jami0quvchilar,
    required this.jamiUstozlar,
    required this.faolGuruhlar,
    required this.jamiCoinlar,
    required this.adminlar,
    required this.kurslar,
    this.coinGrowthPct = 0,
    required this.haftalikCoinlar,
    required this.haftalikLabels,
    required this.guruhCoinlar,
    required this.guruhLabels,
    required this.davomatData,
    required this.davomatLabels,
    required this.ortachaDavomat,
    required this.bugunQatnashdi,
    required this.welcomeAdminlar,
    required this.welcomeKurslar,
    required this.welcomeOqituvchilar,
    required this.welcomeOquvchilar,
    required this.oxirgiAdminlar,
  });

  // ── JSON ──────────────────────────────────────────────────────────────────
  // Kutilayotgan JSON shakli api_config.dart yonidagi izohda / README'da.

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    List<int> intList(dynamic v) =>
        (v as List?)?.map((e) => (e as num).toInt()).toList() ?? const [];
    List<String> strList(dynamic v) =>
        (v as List?)?.map((e) => e.toString()).toList() ?? const [];
    int asInt(dynamic v) => (v is num) ? v.toInt() : int.tryParse('$v') ?? 0;

    final stats = (json['stats'] as Map<String, dynamic>?) ?? json;
    final hafta = (json['haftalikCoinlar'] as Map<String, dynamic>?) ?? const {};
    final guruh = (json['guruhCoinlar'] as Map<String, dynamic>?) ?? const {};
    final davomat = (json['davomat'] as Map<String, dynamic>?) ?? const {};
    final welcome = (json['welcome'] as Map<String, dynamic>?) ?? const {};

    return OwnerModel(
      name: (json['name'] ?? '').toString(),
      avatarEmoji: (json['avatarEmoji'] ?? '👑').toString(),
      jami0quvchilar: asInt(stats['jamiOquvchilar'] ?? stats['jami0quvchilar']),
      jamiUstozlar: asInt(stats['jamiUstozlar']),
      faolGuruhlar: asInt(stats['faolGuruhlar']),
      jamiCoinlar: asInt(stats['jamiCoinlar']),
      adminlar: asInt(stats['adminlar']),
      kurslar: asInt(stats['kurslar']),
      haftalikCoinlar: intList(hafta['data']),
      haftalikLabels: strList(hafta['labels']),
      guruhCoinlar: intList(guruh['data']),
      guruhLabels: strList(guruh['labels']),
      davomatData: intList(davomat['data']),
      davomatLabels: strList(davomat['labels']),
      ortachaDavomat: asInt(davomat['ortacha'] ?? davomat['ortachaDavomat']),
      bugunQatnashdi: asInt(davomat['bugunQatnashdi']),
      welcomeAdminlar: asInt(welcome['adminlar']),
      welcomeKurslar: asInt(welcome['kurslar']),
      welcomeOqituvchilar: asInt(welcome['oqituvchilar']),
      welcomeOquvchilar: asInt(welcome['oquvchilar']),
      oxirgiAdminlar: ((json['oxirgiAdminlar'] as List?) ?? const [])
          .map((e) => OwnerAdmin.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static OwnerModel mock({String? name}) => OwnerModel(
    name: (name != null && name.isNotEmpty) ? name : 'Ega',
    avatarEmoji: '👑',

    jami0quvchilar: 32,
    jamiUstozlar: 7,
    faolGuruhlar: 10,
    jamiCoinlar: 93380,
    adminlar: 4,
    kurslar: 5,
    coinGrowthPct: 18,

    haftalikCoinlar: [1250, 1380, 1320, 1300, 1600, 1280, 1520],
    haftalikLabels: ['Dush', 'Sesh', 'Chor', 'Pay', 'Juma', 'Shan', 'Yak'],

    guruhCoinlar: [
      16330, 11060, 14740, 8280, 12670, 8700, 12290, 9150, 0, 0
    ],
    guruhLabels: [
      'Backend 36', 'Backend 42', 'Frontend 28', 'Frontend 31',
      'Kibxavfs 05', 'Kibxavfs 08', 'Flutter 12', 'Flutter 15',
      'Frontend 35', 'Backend 45',
    ],

    davomatData: [
      44, 47, 39, 46, 48, 42, 45, 43, 49, 41, 47, 44, 48, 47,
    ],
    davomatLabels: [
      '28 Yan', '30 Yan', '1 Fev', '3 Fev',
      '5 Fev', '7 Fev', '10 Fev', '12 Fev',
      '14 Fev', '16 Fev', '18 Fev', '20 Fev',
      '22 Fev', '25 Fev',
    ],
    ortachaDavomat: 89,
    bugunQatnashdi: 47,

    welcomeAdminlar: 5,
    welcomeKurslar: 6,
    welcomeOqituvchilar: 7,
    welcomeOquvchilar: 32,

    oxirgiAdminlar: const [
      OwnerAdmin(
        id: 'a1',
        ism: 'Robiya Anvarova',
        email: 'robiya@codial.uz',
        avatarEmoji: '🧑‍💼',
        isFaol: true,
      ),
      OwnerAdmin(
        id: 'a2',
        ism: 'Ilhomjon Ibragimov',
        email: 'ilhomjon@codial.uz',
        avatarEmoji: '🧑‍💼',
        isFaol: true,
      ),
      OwnerAdmin(
        id: 'a3',
        ism: 'Dilyora Tursunova',
        email: 'dilyora@codial.uz',
        avatarEmoji: '👩‍💼',
        isFaol: true,
      ),
    ],
  );
}

// ─── Helper ───────────────────────────────────────────────────────────────────

String ownerFmtCoins(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}