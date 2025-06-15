import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://127.0.0.1:8080/auth';
  static String? _token; // Armazenará o token JWT

  //Rregistrar
  static Future<void> register(
    String nome,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Falha no registro: ${response.statusCode}');
    }
  }

  // Método de login
  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      _token = jsonDecode(response.body)['token'];
      return _token!;
    } else {
      throw Exception('Falha no login: ${response.statusCode}');
    }
  }

  // Método para obter o token (usado em outras requisições)
  static String? get token => _token;

  //  método para logout
  static Future<void> logout() async {
    try {
      // 1. Tenta chamar o endpoint de logout (opcional)
      await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      // Ignora erros, pois o logout local é o mais importante
      debugPrint('Erro ao chamar logout no backend: $e');
    } finally {
      // 2. Limpeza local garantida
      _token = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  // Método auxiliar para limpar completamente a sessão
  static void clearSession() {
    _token = null;
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('auth_token');
      prefs.remove('email');
      prefs.remove('password');
    });
  }

  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // Interceptador de erros 401
  // if (response.statusCode == 401) {
  // await AuthService.logout();
  // NavigationService.redirectToLogin();
  // }
}
