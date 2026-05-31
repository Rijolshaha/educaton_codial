import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum JadvalTuri { jadvalA, jadvalB }
enum GuruhStatus { faol, faolEmas }

// ─── Model ────────────────────────────────────────────────────────────────────

class AdminGuruh {
  final String id;
  final String nomi;
  final String yaratilganSana;
  final String ustoz;      // mentor.user.username (ko'rsatish)
  final String? mentorId;  // backend mentor_id
  final String kurs;       // course.name (ko'rsatish)
  final String courseId;   // backend course_id
  final JadvalTuri jadval;
  final GuruhStatus status;
  final int oquvchilar;

  AdminGuruh({
    required this.id,
    required this.nomi,
    required this.yaratilganSana,
    required this.ustoz,
    this.mentorId,
    required this.kurs,
    this.courseId = '',
    required this.jadval,
    required this.status,
    required this.oquvchilar,
  });

  AdminGuruh copyWith({
    String? nomi,
    String? yaratilganSana,
    String? ustoz,
    String? mentorId,
    String? kurs,
    String? courseId,
    JadvalTuri? jadval,
    GuruhStatus? status,
    int? oquvchilar,
  }) =>
      AdminGuruh(
        id: id,
        nomi: nomi ?? this.nomi,
        yaratilganSana: yaratilganSana ?? this.yaratilganSana,
        ustoz: ustoz ?? this.ustoz,
        mentorId: mentorId ?? this.mentorId,
        kurs: kurs ?? this.kurs,
        courseId: courseId ?? this.courseId,
        jadval: jadval ?? this.jadval,
        status: status ?? this.status,
        oquvchilar: oquvchilar ?? this.oquvchilar,
      );

  String get jadvalLabel  => jadval == JadvalTuri.jadvalA ? 'Jadval A' : 'Jadval B';
  String get jadvalKunlar => jadval == JadvalTuri.jadvalA ? 'Du-Ch-Ju' : 'Se-Pa-Sh';
  String get statusLabel  => status == GuruhStatus.faol ? 'Faol' : 'Faol emas';

  // ── JSON ──────────────────────────────────────────────────────────────────

  /// Backend `Group` shakli:
  /// `{id, name, active, created_at, lesson_days:[...],
  ///   course:{id,name}, mentor:{id,user:{username}}, student_count}`
  factory AdminGuruh.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) =>
        v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? 0;

    final course = json['course'] as Map<String, dynamic>?;
    final mentor = json['mentor'] as Map<String, dynamic>?;
    final mentorUser = mentor?['user'] as Map<String, dynamic>?;

    var created = (json['created_at'] ?? '').toString();
    if (created.length >= 10) created = created.substring(0, 10);

    final days = ((json['lesson_days'] as List?) ?? const [])
        .map((e) => e.toString().toLowerCase())
        .toList();

    return AdminGuruh(
      id: (json['id'] ?? '').toString(),
      nomi: (json['name'] ?? '').toString(),
      yaratilganSana: created,
      ustoz: (mentorUser?['username'] ?? '').toString(),
      mentorId: mentor?['id']?.toString(),
      kurs: (course?['name'] ?? '').toString(),
      courseId: course?['id']?.toString() ?? '',
      jadval: jadvalFromDays(days),
      status:
          (json['active'] == false) ? GuruhStatus.faolEmas : GuruhStatus.faol,
      oquvchilar: asInt(json['student_count']),
    );
  }
}

// ─── Jadval ↔ lesson_days ──────────────────────────────────────────────────────

/// Jadval A → Du-Ch-Ju, Jadval B → Se-Pa-Sh.
const List<String> _jadvalADays = ['monday', 'wednesday', 'friday'];
const List<String> _jadvalBDays = ['tuesday', 'thursday', 'saturday'];

JadvalTuri jadvalFromDays(List<String> days) {
  if (days.contains('tuesday') ||
      days.contains('thursday') ||
      days.contains('saturday')) {
    return JadvalTuri.jadvalB;
  }
  return JadvalTuri.jadvalA;
}

List<String> daysFromJadval(JadvalTuri jadval) =>
    jadval == JadvalTuri.jadvalA ? _jadvalADays : _jadvalBDays;

// ─── Constants ────────────────────────────────────────────────────────────────

const List<String> allUstozlar = [
  'Otabek Tursunov',
  'Asadbek Mahmudov',
  'Shukululloh Zaylobiddinov',
  'Shaxzodbek Baxtiyorov',
  "Nodira Ro'ziyeva",
  'Sardor Alimov',
];

const List<String> allKurslar = [
  'Backend',
  'Frontend',
  'Kiberxavfsizlik',
  'Flutter',
];

// ─── Helpers ──────────────────────────────────────────────────────────────────

Color guruhKursColor(String kurs) {
  switch (kurs) {
    case 'Backend':         return const Color(0xFF3B82F6);
    case 'Frontend':        return const Color(0xFF8B5CF6);
    case 'Flutter':         return const Color(0xFF06B6D4);
    case 'Kiberxavfsizlik': return const Color(0xFFEF4444);
    default:                return AppColors.primary;
  }
}

IconData guruhKursIcon(String kurs) {
  switch (kurs) {
    case 'Backend':         return Icons.dns_outlined;
    case 'Frontend':        return Icons.web_outlined;
    case 'Flutter':         return Icons.flutter_dash;
    case 'Kiberxavfsizlik': return Icons.security_outlined;
    default:                return Icons.school_outlined;
  }
}

Color guruhHexColor(String hex) {
  try {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  } catch (_) {
    return AppColors.primary;
  }
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final List<AdminGuruh> mockGuruhlar = [
  AdminGuruh(id: 'g1',  nomi: 'Backend 36',        yaratilganSana: '2025-09-01', ustoz: 'Otabek Tursunov',           kurs: 'Backend',         jadval: JadvalTuri.jadvalA, status: GuruhStatus.faol,     oquvchilar: 6),
  AdminGuruh(id: 'g2',  nomi: 'Backend 42',         yaratilganSana: '2025-09-01', ustoz: 'Otabek Tursunov',           kurs: 'Backend',         jadval: JadvalTuri.jadvalB, status: GuruhStatus.faol,     oquvchilar: 4),
  AdminGuruh(id: 'g3',  nomi: 'Frontend 28',        yaratilganSana: '2025-09-10', ustoz: 'Asadbek Mahmudov',          kurs: 'Frontend',        jadval: JadvalTuri.jadvalA, status: GuruhStatus.faol,     oquvchilar: 5),
  AdminGuruh(id: 'g4',  nomi: 'Frontend 31',        yaratilganSana: '2025-10-01', ustoz: 'Asadbek Mahmudov',          kurs: 'Frontend',        jadval: JadvalTuri.jadvalB, status: GuruhStatus.faol,     oquvchilar: 3),
  AdminGuruh(id: 'g5',  nomi: 'Kiberxavfsizlik 05', yaratilganSana: '2025-11-01', ustoz: 'Shukululloh Zaylobiddinov', kurs: 'Kiberxavfsizlik', jadval: JadvalTuri.jadvalA, status: GuruhStatus.faol,     oquvchilar: 4),
  AdminGuruh(id: 'g6',  nomi: 'Kiberxavfsizlik 08', yaratilganSana: '2025-10-25', ustoz: 'Shukululloh Zaylobiddinov', kurs: 'Kiberxavfsizlik', jadval: JadvalTuri.jadvalB, status: GuruhStatus.faolEmas, oquvchilar: 4),
  AdminGuruh(id: 'g7',  nomi: 'Flutter 12',         yaratilganSana: '2025-09-29', ustoz: 'Shaxzodbek Baxtiyorov',    kurs: 'Flutter',         jadval: JadvalTuri.jadvalA, status: GuruhStatus.faol,     oquvchilar: 4),
  AdminGuruh(id: 'g8',  nomi: 'Flutter 15',         yaratilganSana: '2025-10-10', ustoz: 'Shaxzodbek Baxtiyorov',    kurs: 'Flutter',         jadval: JadvalTuri.jadvalB, status: GuruhStatus.faol,     oquvchilar: 3),
  AdminGuruh(id: 'g9',  nomi: 'Frontend 35',        yaratilganSana: '2026-01-15', ustoz: "Nodira Ro'ziyeva",          kurs: 'Frontend',        jadval: JadvalTuri.jadvalA, status: GuruhStatus.faol,     oquvchilar: 0),
  AdminGuruh(id: 'g10', nomi: 'Backend 45',         yaratilganSana: '2026-01-20', ustoz: 'Sardor Alimov',             kurs: 'Backend',         jadval: JadvalTuri.jadvalB, status: GuruhStatus.faolEmas, oquvchilar: 0),
];