// ============================================================
//  API CONFIGURATION — Codial backend (Django REST + SimpleJWT)
// ============================================================

class ApiConfig {
  // 🔧 Real backend manzili:
  static const String BASE_URL = 'https://api.codialinfo.uz';

  // 🧪 `true` bo'lsa — backendsiz mock ma'lumot ishlatiladi.
  //    Owner roli real API'ga ulandi → `false`.
  static const bool useMockApi = false;

  // ── Auth (JWT) ──────────────────────────────────────────────
  static String get token => '$BASE_URL/token/';
  static String get tokenRefresh => '$BASE_URL/token/refresh/';
  static String get me => '$BASE_URL/get/me/';

  // ── Owner / Admin boshqaruvi ────────────────────────────────
  static String get admins => '$BASE_URL/admins/';
  static String get adminsAdd => '$BASE_URL/admins/add/';
  static String adminDetail(String id) => '$BASE_URL/admins/$id/';

  // ── Yangiliklar (News) ──────────────────────────────────────
  static String get news => '$BASE_URL/news/';
  static String get newsAdd => '$BASE_URL/news/add/';
  static String newsDetail(int id) => '$BASE_URL/news/$id/';

  /// Backend rasm uchun nisbiy yo'l qaytarishi mumkin — to'liq URL'ga aylantiradi.
  static String absoluteUrl(String path) {
    if (path.isEmpty) return path;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return '$BASE_URL${path.startsWith('/') ? '' : '/'}$path';
  }

  // ── Dashboard manbalari (agregatsiya uchun) ─────────────────
  static String get students => '$BASE_URL/students/';
  static String get studentsAdd => '$BASE_URL/students/add/';
  static String studentDetail(String id) => '$BASE_URL/students/$id/';
  static String get mentors => '$BASE_URL/mentors/';
  static String get mentorsAdd => '$BASE_URL/mentors/add/';
  static String mentorDetail(String id) => '$BASE_URL/mentors/$id/';
  static String get courses => '$BASE_URL/courses/';
  static String courseDetail(String id) => '$BASE_URL/courses/$id/';
  static String get groups => '$BASE_URL/groups/';
  static String get groupsAdd => '$BASE_URL/groups/add/';
  static String groupDetail(String id) => '$BASE_URL/groups/$id/';
  static String get auctions => '$BASE_URL/auctions/';
  static String auctionDetail(String id) => '$BASE_URL/auctions/$id/';
  static String get products => '$BASE_URL/products/';
  static String productDetail(String id) => '$BASE_URL/products/$id/';
  static String get activeGroups => '$BASE_URL/active-groups/';
  static String get leaderboard => '$BASE_URL/leaderboard/';
  static String get pointTypes => '$BASE_URL/pointtypes/';
  static String teacherAssessment(String groupId) =>
      '$BASE_URL/api/teacher/assessment/$groupId/';
  static String get teacherAssessmentSave =>
      '$BASE_URL/api/teacher/assessment/save/';
  static String get teacherAssessmentUpdate =>
      '$BASE_URL/api/teacher/assessment/update/';
  static String coinHistory({String? dateFrom, String? dateTo}) {
    final q = <String>[];
    if (dateFrom != null) q.add('date_from=$dateFrom');
    if (dateTo != null) q.add('date_to=$dateTo');
    final qs = q.isEmpty ? '' : '?${q.join('&')}';
    return '$BASE_URL/coin-history/$qs';
  }

  // ── Kitoblar (Books) — student ────────────────────────────────
  static String get books => '$BASE_URL/books/';
  static String bookDetail(String id) => '$BASE_URL/books/$id/';

  // ── Headers ─────────────────────────────────────────────────
  static Map<String, String> headers({String? token}) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  /// Form-data (x-www-form-urlencoded) so'rovlar uchun — JSON'siz.
  static Map<String, String> formHeaders({String? token}) => {
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}
