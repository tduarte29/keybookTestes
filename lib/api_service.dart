class ApiService {
  static const String baseUrl = "http://127.0.0.1:8080";
  static String? authToken; // Para armazenar JWT após login

  // Headers reutilizáveis
  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };
  }

// Métodos CRUD...
}




// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// class ApiService {
//
// // Altere para a URL do seu backend. Se estiver usando um emulador, pode ser localhost.
//
// // Para Android emulador, use 10.0.2.2 em vez de localhost.
//
// // Se estiver testando em um dispositivo físico, use o IP da sua máquina na rede.
//
// static const String baseUrl = 'http://10.0.2.2:8080'; // para emulador Android
//
// Future<dynamic> registerUser(String nome, String email, String password) async {
//
// final response = await http.post(
//
// Uri.parse('$baseUrl/auth/register'),
//
// headers: <String, String>{
//
// 'Content-Type': 'application/json; charset=UTF-8',
//
// },
//
// body: jsonEncode(<String, String>{
//
// 'nome': nome,
//
// 'email': email,
//
// 'password': password,
//
// }),
//
// );
//
// if (response.statusCode == 201) {
//
// // Se o servidor retornar um CREATED, parseie o JSON
//
// return jsonDecode(response.body);
//
// } else {
//
// // Se a resposta não for bem-sucedida, lance uma exceção.
//
// throw Exception('Falha ao registrar usuário: ${response.statusCode}');
//
// }
//
// }
//
// // Adicione outros métodos conforme necessário (login, buscar dados, etc.)
//
// }
