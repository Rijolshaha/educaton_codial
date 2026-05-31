import 'package:flutter/material.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum KursStatus { faol, nofaol }

// ─── Icon Option ──────────────────────────────────────────────────────────────

class KursIconOption {
  final IconData icon;
  final String label;
  final String code; // backend `icon` qiymati (masalan: 'web', 'mobile')
  const KursIconOption(this.icon, this.label, this.code);
}

// ─── Rang Option ──────────────────────────────────────────────────────────────

class KursRangOption {
  final Color color1;
  final Color color2;
  final String label;
  final String code; // backend `color` qiymati (masalan: 'blue', 'pink')
  const KursRangOption(this.color1, this.color2, this.label, this.code);
}

// ─── Available Options ────────────────────────────────────────────────────────

final List<KursIconOption> kursIconOptions = [
  KursIconOption(Icons.dns_rounded,             'Server',     'server'),
  KursIconOption(Icons.code_rounded,            'Kod',        'code'),
  KursIconOption(Icons.book_outlined,           'Kitob',      'book'),
  KursIconOption(Icons.phone_android_rounded,   'Mobil',      'mobile'),
  KursIconOption(Icons.palette_rounded,         'Palette',    'palette'),
  KursIconOption(Icons.trending_up_rounded,     'Trend',      'trend'),
  KursIconOption(Icons.security_rounded,        'Xavfsizlik', 'security'),
  KursIconOption(Icons.design_services_rounded, 'Dizayn',     'design'),
  KursIconOption(Icons.web_rounded,             'Web',        'web'),
  KursIconOption(Icons.camera_alt_rounded,      'Kamera',     'camera'),
];

final List<KursRangOption> kursRangOptions = [
  KursRangOption(const Color(0xFF22C55E), const Color(0xFF15803D), 'Green',  'green'),
  KursRangOption(const Color(0xFF3B82F6), const Color(0xFF1D4ED8), 'Blue',   'blue'),
  KursRangOption(const Color(0xFF6366F1), const Color(0xFF4338CA), 'Indigo', 'indigo'),
  KursRangOption(const Color(0xFFA855F7), const Color(0xFF7E22CE), 'Purple', 'purple'),
  KursRangOption(const Color(0xFFF97316), const Color(0xFFEA580C), 'Orange', 'orange'),
  KursRangOption(const Color(0xFFEC4899), const Color(0xFFBE185D), 'Pink',   'pink'),
  KursRangOption(const Color(0xFF14B8A6), const Color(0xFF0F766E), 'Teal',   'teal'),
  KursRangOption(const Color(0xFFEF4444), const Color(0xFFB91C1C), 'Red',    'red'),
];

/// Backend `icon` kodidan mos `KursIconOption` topadi (topilmasa — birinchisi).
KursIconOption kursIconFromCode(String? code) {
  final c = (code ?? '').toLowerCase().trim();
  if (c.isEmpty) return kursIconOptions[0];
  for (final o in kursIconOptions) {
    if (o.code == c) return o;
  }
  return kursIconOptions[0];
}

/// Backend `color` kodidan mos `KursRangOption` topadi (alias + fallback bilan).
KursRangOption kursRangFromCode(String? code) {
  var c = (code ?? '').toLowerCase().trim();
  if (c.isEmpty) return kursRangOptions[1]; // default: blue
  const aliases = {
    'amber': 'orange',
    'yellow': 'orange',
    'cyan': 'teal',
    'violet': 'purple',
    'rose': 'pink',
  };
  c = aliases[c] ?? c;
  for (final o in kursRangOptions) {
    if (o.code == c) return o;
  }
  return kursRangOptions[1];
}

// ─── Model ────────────────────────────────────────────────────────────────────

class KursModel {
  final String id;
  final String nomi;
  final String tavsif;
  final KursIconOption belgi;
  final KursRangOption rang;
  final KursStatus status;
  final int oqituvchilar;
  final int guruhlar;
  final int oquvchilar;

  KursModel({
    required this.id,
    required this.nomi,
    required this.tavsif,
    required this.belgi,
    required this.rang,
    required this.status,
    required this.oqituvchilar,
    required this.guruhlar,
    required this.oquvchilar,
  });

  KursModel copyWith({
    String? nomi,
    String? tavsif,
    KursIconOption? belgi,
    KursRangOption? rang,
    KursStatus? status,
    int? oqituvchilar,
    int? guruhlar,
    int? oquvchilar,
  }) =>
      KursModel(
        id: id,
        nomi: nomi ?? this.nomi,
        tavsif: tavsif ?? this.tavsif,
        belgi: belgi ?? this.belgi,
        rang: rang ?? this.rang,
        status: status ?? this.status,
        oqituvchilar: oqituvchilar ?? this.oqituvchilar,
        guruhlar: guruhlar ?? this.guruhlar,
        oquvchilar: oquvchilar ?? this.oquvchilar,
      );

  // ── JSON ──────────────────────────────────────────────────────────────────

  /// Backend `Course` shakli:
  /// `{id, name, icon, color, description, is_active,
  ///   group_count, student_count, teacher_count}`
  factory KursModel.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) =>
        v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? 0;

    return KursModel(
      id: (json['id'] ?? '').toString(),
      nomi: (json['name'] ?? json['nomi'] ?? '').toString(),
      tavsif: (json['description'] ?? json['tavsif'] ?? '').toString(),
      belgi: kursIconFromCode(json['icon']?.toString()),
      rang: kursRangFromCode(json['color']?.toString()),
      status: (json['is_active'] == false)
          ? KursStatus.nofaol
          : KursStatus.faol,
      oqituvchilar: asInt(json['teacher_count']),
      guruhlar: asInt(json['group_count']),
      oquvchilar: asInt(json['student_count']),
    );
  }

  /// Backendga yuborish uchun (POST /courses/, PATCH /courses/{id}/).
  /// `*_count` maydonlari read-only — yuborilmaydi.
  Map<String, dynamic> toJson() => {
    'name': nomi,
    'icon': belgi.code,
    'color': rang.code,
    'description': tavsif,
    'is_active': status == KursStatus.faol,
  };
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final List<KursModel> mockKurslar = [
  KursModel(
    id: 'k1', nomi: 'Backend', status: KursStatus.faol,
    tavsif: 'Node.js, Python, Django, REST API va database boshqaruvi',
    belgi: kursIconOptions[0], rang: kursRangOptions[0],
    oqituvchilar: 2, guruhlar: 4, oquvchilar: 10,
  ),
  KursModel(
    id: 'k2', nomi: 'Frontend', status: KursStatus.faol,
    tavsif: 'HTML, CSS, JavaScript, React va zamonaviy frontend texnologiyalari',
    belgi: kursIconOptions[1], rang: kursRangOptions[1],
    oqituvchilar: 2, guruhlar: 4, oquvchilar: 8,
  ),
  KursModel(
    id: 'k3', nomi: 'Kiberxavfsizlik', status: KursStatus.faol,
    tavsif: 'Axborot xavfsizligi, tarmoq xavfsizligi, pentesting va etik xakerlik',
    belgi: kursIconOptions[6], rang: kursRangOptions[2],
    oqituvchilar: 1, guruhlar: 2, oquvchilar: 8,
  ),
  KursModel(
    id: 'k4', nomi: 'Flutter', status: KursStatus.faol,
    tavsif: 'Cross-platform mobil ilovalar yaratish (iOS va Android)',
    belgi: kursIconOptions[3], rang: kursRangOptions[3],
    oqituvchilar: 1, guruhlar: 2, oquvchilar: 7,
  ),
  KursModel(
    id: 'k5', nomi: 'Grafik Dizayn', status: KursStatus.faol,
    tavsif: 'Figma, Adobe Photoshop, Illustrator va UI/UX dizayn',
    belgi: kursIconOptions[4], rang: kursRangOptions[3],
    oqituvchilar: 1, guruhlar: 0, oquvchilar: 0,
  ),
  KursModel(
    id: 'k6', nomi: 'SMM & Marketing', status: KursStatus.nofaol,
    tavsif: 'Ijtimoiy tarmoqlar marketingi, kontent yaratish va brendlash',
    belgi: kursIconOptions[5], rang: kursRangOptions[4],
    oqituvchilar: 0, guruhlar: 0, oquvchilar: 0,
  ),
];