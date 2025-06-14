import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://127.0.0.1:8080/auth';
  static String? _token; // Armazenará o token JWT

  static Future<void> register(String nome, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'password': password,
      }),
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
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      _token = jsonDecode(response.body)['token']; // Supondo que o backend retorne um token
      return _token!;
    } else {
      throw Exception('Falha no login: ${response.statusCode}');
    }
  }

  // Método para obter o token (usado em outras requisições)
  static String? get token => _token;

}

// class AuthService {
//   static Future<void> register(String nome, String email, String password) async {
//
//     try {
//       final response = await http.post(
//         Uri.parse('http://127.0.0.1:8080/auth/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'nome': 'TesteFlutter',
//           'email': 'flutter@teste3.com',
//           'password': '123456'
//         }),
//       );
//       print(nome + email + password);
//       print('Status: ${response.statusCode}');
//       print('Corpo: ${response.body}');
//     } catch (e) {
//       print('Erro: $e');
//     }
//   }
  /*
  ElevatedButton(
                  onPressed: () async {
                    try {
                      final response = await http.post(
                        Uri.parse('http://127.0.0.1:8080/auth/register'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          'nome': 'TesteFlutter',
                          'email': 'flutter@teste.com',
                          'password': '123456'
                        }),
                      );
                      print('Status: ${response.statusCode}');
                      print('Corpo: ${response.body}');
                    } catch (e) {
                      print('Erro: $e');
                    }
                  },
                  child: Text('Testar Conexão'),
                )
   */

  // static Future<String> login(String email, String password) async {
  //   // Implementação do login (retorna token JWT)
  // }

  // static Future<void> logout() async {
  //   // Limpa token e dados de sessão
  // }
