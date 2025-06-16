import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // static const String _baseUrl = 'http://10.0.2.2:8080/auth'; // Para emulador Android
  static const String _baseUrl =
      'http://localhost:8080/auth'; // Para web chrome
  static String? _token;
  static int? _userId;

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

      print('Resposta do login: ${response.body}'); // Adicione para debug

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _userId = data['userId']; // Verifique se a chave está correta

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_id', _userId.toString());

        print('Login realizado - Token: $_token, UserId: $_userId'); // Debug
        return _token!;
      } else {
        throw Exception('Falha no login: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro no login: $e');
      rethrow;
    }
  }

  // Getter para userId
  static Future<int?> getUserId() async {
    if (_userId != null) return _userId;

    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('user_id');

    if (userIdString != null && userIdString.isNotEmpty) {
      _userId = int.tryParse(userIdString);
      return _userId;
    }
    return null;
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
      _userId = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
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
