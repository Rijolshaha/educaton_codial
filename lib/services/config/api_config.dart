// ============================================================
//  API CONFIGURATION — Change BASE_URL to connect your backend
// ============================================================

class ApiConfig {
  // 🔧 SET YOUR API BASE URL HERE:
  static const String BASE_URL = 'https://your-api-url.com';

  // Auth
  static String get login => '$BASE_URL/api/auth/login';
  static String get profile => '$BASE_URL/api/user/profile';
  static String get dashboard => '$BASE_URL/api/dashboard';
  static String get rewards => '$BASE_URL/api/rewards';
  static String get groups => '$BASE_URL/api/groups';
  static String get stats => '$BASE_URL/api/stats';
  static String get news => '$BASE_URL/api/news';
  static String get coinOpportunities => '$BASE_URL/api/coins/opportunities';
  static String get ranking => '$BASE_URL/api/ranking';

  // Headers (add token after login)
  static Map<String, String> headers({String? token}) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}
