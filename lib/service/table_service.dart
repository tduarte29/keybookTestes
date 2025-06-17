import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class TableService {
  static const String _baseUrl = 'http://localhost:8080/tables';

  // Listar todas as tabelas do usuário
  static Future<List<dynamic>> getUserTables(String userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/users/$userId/tables'),
      headers: await AuthService.headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar tabelas');
    }
  }

  // Criar nova tabela
  static Future<Map<String, dynamic>> createTable(
    String userId,
    String tableName,
  ) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/users/$userId/tables'),
      headers: await AuthService.headers,
      body: jsonEncode({'nome': tableName}),
    );
    print('Status ao criar tabela: ${response.statusCode}');
    print('Body ao criar tabela: ${response.body}');
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao criar tabela');
    }
  }

  static Future<List<dynamic>> getTableItems(String tableId) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/tables/$tableId/items'),
      headers: await AuthService.headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar itens da tabela');
    }
  }

  // Renomear tabela
  static Future<void> renameTable(String tableId, String newName) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$tableId'),
      headers: await AuthService.headers,
      body: jsonEncode({'name': newName}),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao renomear tabela');
    }
  }

  // Excluir tabela
  static Future<void> deleteTable(String tableId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$tableId'),
      headers: await AuthService.headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir tabela: ${response.statusCode}');
    }
  }
}
