import 'dart:convert';

import 'package:http/http.dart' as http;



import '../models/dashboard_model.dart';

import 'auth_storage.dart';

import 'config/api_config.dart';



/// Login natijasi: muvaffaqiyat + foydalanuvchi roli.

/// `role` bo'sh ('') bo'lsa — superuser/ega (owner).

class AuthResult {

  final bool ok;

  final String role;

  final String? message;

  const AuthResult({required this.ok, this.role = '', this.message});

}



class ApiService {

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();



  static const _timeout = Duration(seconds: 12);

  final _storage = AuthStorage();



  String? _token;

  String? _refresh;

  String? _role;

  String? _username;



  void setToken(String token) => _token = token;

  String? get token => _token;

  String? get refreshToken => _refresh;

  String? get role => _role;

  String? get userName => _username;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;



  Future<void> logout() async {

    _token = null;

    _refresh = null;

    _role = null;

    _username = null;

    await _storage.clear();

  }



  /// Ilova ochilganda — saqlangan token yoki login/parol bilan kirish.

  Future<AuthResult> tryRestoreSession() async {

    final stored = await _storage.read();

    if (stored == null) {

      return const AuthResult(ok: false);

    }



    _token = stored.token;

    _refresh = stored.refresh;

    _role = stored.role;

    _username = stored.username;



    if (await _validateToken()) {

      return AuthResult(ok: true, role: _role ?? stored.role);

    }



    return login(stored.username, stored.password);

  }



  Future<bool> _validateToken() async {

    if (_token == null || _token!.isEmpty) return false;

    try {

      final me = await http

          .get(Uri.parse(ApiConfig.me),

              headers: ApiConfig.headers(token: _token))

          .timeout(_timeout);

      if (me.statusCode != 200) return false;



      final m = jsonDecode(me.body) as Map<String, dynamic>;

      final user = m['user'] as Map<String, dynamic>?;

      _role = (user?['role'] ?? _role ?? '').toString();

      _username = user?['username']?.toString() ?? _username;

      return true;

    } catch (_) {

      return false;

    }

  }



  Future<AuthResult> login(String username, String password) async {

    try {

      final res = await http

          .post(

            Uri.parse(ApiConfig.token),

            headers: ApiConfig.headers(),

            body: jsonEncode({'username': username, 'password': password}),

          )

          .timeout(_timeout);



      if (res.statusCode == 200 || res.statusCode == 201) {

        final data = jsonDecode(res.body) as Map<String, dynamic>;

        _token = (data['access'] ?? data['token'])?.toString();

        _refresh = data['refresh']?.toString();

        if (_token == null || _token!.isEmpty) {

          return const AuthResult(ok: false, message: 'Token kelmadi');

        }



        String role = (data['role'] ?? '').toString();

        try {

          final me = await http

              .get(Uri.parse(ApiConfig.me),

                  headers: ApiConfig.headers(token: _token))

              .timeout(_timeout);

          if (me.statusCode == 200) {

            final m = jsonDecode(me.body) as Map<String, dynamic>;

            final user = m['user'] as Map<String, dynamic>?;

            role = (user?['role'] ?? role).toString();

            _username = user?['username']?.toString() ?? username;

          }

        } catch (_) {

          _username ??= username;

        }

        _role = role;



        await _storage.save(

          username: username,

          password: password,

          token: _token!,

          refresh: _refresh,

          role: role,

        );



        return AuthResult(ok: true, role: role);

      }



      String msg = "Login yoki parol noto'g'ri";

      try {

        final body = jsonDecode(res.body);

        if (body is Map && body['detail'] != null) {

          msg = body['detail'].toString();

        }

      } catch (_) {}

      return AuthResult(ok: false, message: msg);

    } catch (_) {

      return const AuthResult(

          ok: false, message: 'Serverga ulanib bo\'lmadi');

    }

  }



  Future<DashboardModel> fetchDashboard({bool useMock = true}) async {

    return DashboardModel.mock();

  }

}


