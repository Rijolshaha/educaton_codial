import 'dart:convert';
import 'package:http/http.dart' as http ;
import '../models/dashboard_model.dart';
import 'config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  void setToken(String token) => _token = token;
  String? get token => _token;

  // -------------------------------------------------------
  //  DASHBOARD — returns mock if API not reachable
  // -------------------------------------------------------
  Future<DashboardModel> fetchDashboard({bool useMock = false}) async {
    if (useMock) return DashboardModel.mock();

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.dashboard),
        headers: ApiConfig.headers(token: _token),
      )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        return DashboardModel.fromJson(jsonDecode(response.body));
      } else {
        // Fall back to mock on error
        return DashboardModel.mock();
      }
    } catch (_) {
      // Network unavailable → use mock
      return DashboardModel.mock();
    }
  }

  // -------------------------------------------------------
  //  AUTH — login and store token
  // -------------------------------------------------------
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: ApiConfig.headers(),
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'] ?? data['access_token'];
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}