import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/table_data.dart';
import '../widgets/key_table_expansion.dart';
import '../widgets/table_name_input.dart';
import '../widgets/search_filter_bar.dart';
import 'key_detail_screen.dart';
import '../service/table_service.dart';
import '../service/auth_service.dart';

class KeyListScreen extends StatefulWidget {
  const KeyListScreen({super.key});

  @override
  State<KeyListScreen> createState() => _KeyListScreenState();
}

class _KeyListScreenState extends State<KeyListScreen> {
  List<TableData> tables = [];
  final TextEditingController tableNameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  int _filterOption = 0;
  int? userId;
  bool _isLoading = true;

  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      50 + random.nextInt(156),
      50 + random.nextInt(156),
      50 + random.nextInt(156),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserAndTables();
  }

  Future<void> _loadUserAndTables() async {
    try {
      // 1. Obter o userId
      userId = await AuthService.getUserId();
      print('UserId obtido: $userId');

      if (userId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário não autenticado')),
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      // 2. Carregar tabelas
      await _loadTables();
    } catch (e) {
      print('Erro ao carregar dados: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadTables() async {
    if (userId == null) return;

    try {
      final list = await TableService.getUserTables(userId!.toString());
      setState(() {
        tables =
            list
                .map<TableData>((t) => TableData(t['nome'], getRandomColor()))
                .toList();
      });
    } catch (e) {
      print('Erro ao carregar tabelas: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar tabelas: ${e.toString()}')),
        );
      }
    }
  }

  void addTable() async {
    final name = tableNameController.text.trim();
    if (name.isEmpty || userId == null) return;

    try {
      final newTable = await TableService.createTable(userId!.toString(), name);
      setState(() {
        tables.add(TableData(newTable['nome'], getRandomColor()));
        tableNameController.clear();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar tabela: ${e.toString()}')),
        );
      }
    }
  }

  // Future<void> _initUserIdAndLoadTables() async {
  //   userId = await AuthService.getUserId();
  //   print('UserId carregado: $userId'); // DEPURAÇÃO
  //   if (userId != null) {
  //     _loadTables();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Erro: usuário não autenticado')),
  //     );
  //   }
  // }
  //
  // void addTable() async {
  //   final name = tableNameController.text.trim();
  //   print('Tentando adicionar tabela: $name para userId: $userId'); // DEPURAÇÃO
  //   if (name.isNotEmpty && userId != null) {
  //     try {
  //       final newTable = await TableService.createTable(
  //         userId!.toString(),
  //         name,
  //       );
  //       print('Resposta do backend ao criar tabela: $newTable'); // DEPURAÇÃO
  //       setState(() {
  //         tables.add(
  //           TableData(
  //             newTable['nome'],
  //             getRandomColor(),
  //           ), // <-- Corrigido aqui!
  //         );
  //         tableNameController.clear();
  //       });
  //     } catch (e) {
  //       print('Erro ao criar tabela: $e'); // DEPURAÇÃO
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('Erro ao criar tabela: $e')));
  //     }
  //   }
  // }

  void editTable(int index, String newName) {
    setState(() {
      tables[index] = TableData(
        newName,
        tables[index].color,
        tables[index].keys,
      );
    });
  }

  void deleteTable(int index) {
    setState(() {
      tables.removeAt(index);
    });
  }

  void addKey(TableData table) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF232323),
            title: Text(
              'Nova chave',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            content: TextField(
              controller: controller,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nome da chave',
                hintStyle: GoogleFonts.inter(color: Colors.white54),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.inter(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    setState(() {
                      table.keys.insert(0, KeyItemData(controller.text.trim()));
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.inter(color: Colors.grey.shade900),
                ),
              ),
            ],
          ),
    );
  }

  void onKeyTap(String keyName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KeyDetailScreen(keyName: keyName)),
    );
  }

  List<TableData> get filteredTables {
    String search = searchController.text.trim().toLowerCase();
    List<TableData> filtered =
        tables
            .where(
              (t) =>
                  t.name.toLowerCase().contains(search) ||
                  t.keys.any((k) => k.name.toLowerCase().contains(search)),
            )
            .toList();

    switch (_filterOption) {
      case 0:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 1:
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 2:
        break;
      case 3:
        filtered = filtered.reversed.toList();
        break;
      case 4:
        break;
    }
    return filtered;
  }

  @override
  void dispose() {
    tableNameController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // Future<void> _loadTables() async {
  //   try {
  //     if (userId == null) {
  //       print('userId é null ao carregar tabelas!'); // DEPURAÇÃO
  //       return;
  //     }
  //     print('Buscando tabelas para userId: $userId'); // DEPURAÇÃO
  //     final list = await TableService.getUserTables(userId!.toString());
  //     print('Tabelas recebidas: $list'); // DEPURAÇÃO
  //     setState(() {
  //       tables =
  //           list
  //               .map<TableData>((t) => TableData(t['nome'], getRandomColor()))
  //               .toList();
  //     });
  //   } catch (e) {
  //     print('Erro ao carregar tabelas: $e'); // DEPURAÇÃO
  //     tables = [];
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Erro ao carregar tabelas: $e')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lista de Chaves',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 14),
              TableNameInput(controller: tableNameController, onAdd: addTable),
              const SizedBox(height: 12),
              SearchFilterBar(
                controller: searchController,
                filterOption: _filterOption,
                onChanged: (_) => setState(() {}),
                onFilterChanged:
                    (value) => setState(() => _filterOption = value),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children:
                      filteredTables.asMap().entries.map((entry) {
                        final index = entry.key;
                        final table = entry.value;
                        return KeyTableExpansion(
                          table: table,
                          index: index,
                          onEditTable: editTable,
                          onDeleteTable: deleteTable,
                          onAddKey: addKey,
                          onKeyTap: onKeyTap,
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
