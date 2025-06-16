import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // static const String _baseUrl = 'http://10.0.2.2:8080/auth'; // Para emulador Android
  static const String _baseUrl = 'http://localhost:8080/auth'; // Para iOS/web
  static String? _token;

  // Método para inicializar o token ao iniciar o app
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  // Registrar novo usuário
  static Future<void> register({
    required String nome,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nome': nome, 'email': email, 'password': password}),
      );

      if (response.statusCode != 201) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Falha no registro');
      }
    } catch (e) {
      debugPrint('Erro no registro: $e');
      rethrow;
    }
  }

  // Login
  static Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];

        // Salva o token localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        return _token!;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Falha no login');
      }
    } catch (e) {
      debugPrint('Erro no login: $e');
      rethrow;
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      // 1. Tenta chamar o endpoint de logout
      await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
      );
    } catch (e) {
      debugPrint('Erro ao chamar logout no backend: $e');
    } finally {
      // 2. Limpeza local garantida
      _token = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    }
  }

  // Verifica se o usuário está autenticado
  static Future<bool> isAuthenticated() async {
    if (_token != null) return true;

    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }

  // Obtém os headers com o token para requisições autenticadas
  static Future<Map<String, String>> get headers async {
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
    }

    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // Método para obter o token (se necessário)
  static Future<String?> getToken() async {
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
    }
    return _token;
  }
}

// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthService {
//   static const String _baseUrl = 'http://127.0.0.1:8080/auth';
//   static String? _token; // Armazenará o token JWT
//
//   //Rregistrar
//   static Future<void> register(
//     String nome,
//     String email,
//     String password,
//   ) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/register'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'nome': nome, 'email': email, 'password': password}),
//     );
//
//     if (response.statusCode != 201) {
//       throw Exception('Falha no registro: ${response.statusCode}');
//     }
//   }
//
//   // Método de login
//   static Future<String> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email, 'password': password}),
//     );
//
//     if (response.statusCode == 200) {
//       _token = jsonDecode(response.body)['token'];
//       return _token!;
//     } else {
//       throw Exception('Falha no login: ${response.statusCode}');
//     }
//   }
//
//   // Método para obter o token (usado em outras requisições)
//   static String? get token => _token;
//
//   //  método para logout
//   static Future<void> logout() async {
//     try {
//       // 1. Tenta chamar o endpoint de logout (opcional)
//       await http.post(
//         Uri.parse('$_baseUrl/logout'),
//         headers: {
//           'Authorization': 'Bearer $_token',
//           'Content-Type': 'application/json',
//         },
//       );
//     } catch (e) {
//       // Ignora erros, pois o logout local é o mais importante
//       debugPrint('Erro ao chamar logout no backend: $e');
//     } finally {
//       // 2. Limpeza local garantida
//       _token = null;
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('auth_token');
//       await prefs.remove('email');
//       await prefs.remove('password');
//     }
//   }
//
//   // Método auxiliar para limpar completamente a sessão
//   static void clearSession() {
//     _token = null;
//     SharedPreferences.getInstance().then((prefs) {
//       prefs.remove('auth_token');
//       prefs.remove('email');
//       prefs.remove('password');
//     });
//   }
//
//   static Map<String, String> get headers {
//     return {
//       'Content-Type': 'application/json',
//       if (_token != null) 'Authorization': 'Bearer $_token',
//     };
//   }
// }
