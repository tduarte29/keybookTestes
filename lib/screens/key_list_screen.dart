import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/key_item_card.dart' as item_card;
import 'key_detail_screen.dart';

// MODELOS LOCAIS
class TableData {
  final String name;
  final Color color;
  final List<_KeyItemData> keys;

  TableData(this.name, this.color, [List<_KeyItemData>? keys])
      : keys = keys ?? [];
}

class _KeyItemData {
  final String name;
  _KeyItemData(this.name);
}

// WIDGET AUXILIAR
class AddKeyCard extends StatelessWidget {
  final VoidCallback? onTap;
  const AddKeyCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 64,
          child: Center(
            child: Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}

// TELA PRINCIPAL
class KeyListScreen extends StatefulWidget {
  const KeyListScreen({super.key});

  @override
  State<KeyListScreen> createState() => _KeyListScreenState();
}

class _KeyListScreenState extends State<KeyListScreen> {
  late List<TableData> tables;

  // Gera uma cor randômica para o label da tabela/marca
  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      50 + random.nextInt(156), // evita cores muito claras/escura
      50 + random.nextInt(156),
      50 + random.nextInt(156),
    );
  }

  void addTable(String name) {
    setState(() {
      tables.add(TableData(name, getRandomColor()));
      // TODO: Chamar API/backend para criar tabela
    });
  }

  void showAddTableDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        title: Text('Nova tabela', style: GoogleFonts.inter(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: GoogleFonts.inter(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Nome da tabela',
            hintStyle: GoogleFonts.inter(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.inter(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                addTable(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text('OK', style: GoogleFonts.inter(color: Colors.grey.shade900)),
          ),
        ],
      ),
    );
  }

  void showAddKeyDialog(TableData table) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        title: Text('Nova chave', style: GoogleFonts.inter(color: Colors.white)),
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
            child: Text('Cancelar', style: GoogleFonts.inter(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  table.keys.insert(0, _KeyItemData(controller.text.trim()));
                  // TODO: Chamar API/backend para criar chave
                });
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KeyDetailScreen(
                      keyName: controller.text.trim(),
                    ),
                  ),
                );
              }
            },
            child: Text('OK', style: GoogleFonts.inter(color: Colors.grey.shade900)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tables = [
      TableData('Chevrolet', Colors.redAccent, [
        _KeyItemData('BSD12931'),
        _KeyItemData('DSS36472'),
        _KeyItemData('ABC12345'),
      ]),
      TableData('Honda', Colors.blueAccent),
      TableData('Mercedes', Colors.green),
      TableData('Ferrari', Colors.red, [
        _KeyItemData('BSD12931'),
        _KeyItemData('DSS36472'),
        _KeyItemData('XYZ98765'),
      ]),
    ];
    // TODO: Carregar tabelas e chaves do backend aqui
  }

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
              // Campo nome da tabela + botão
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.inter(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Nome da tabela',
                        hintStyle: GoogleFonts.inter(color: Colors.white70),
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24, width: 1.2),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24, width: 1.2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: showAddTableDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Adicionar Tabela',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Campo pesquisar items com lupa e filtro
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF181818),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    const Icon(Icons.search, color: Colors.white54, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.inter(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Pesquisar Items',
                          hintStyle: GoogleFonts.inter(color: Colors.white54),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white54, size: 22),
                      onPressed: () {
                        // TODO: Implementar filtro usando API/backend
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Lista de tabelas/marcas retraídas
              Expanded(
                child: ListView(
                  children: tables.asMap().entries.map((entry) {
                    final index = entry.key;
                    final table = entry.value;
                    return ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      collapsedBackgroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      leading: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: table.color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          table.name,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      title: Text(
                        '${table.keys.length} items',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                        textAlign: TextAlign.end,
                      ),
                      trailing: PopupMenuButton<int>(
                        color: const Color(0xFF232323),
                        icon: const Icon(Icons.more_vert, color: Colors.white70),
                        onSelected: (value) {
                          if (value == 0) {
                            // Editar tabela
                            final controller = TextEditingController(text: table.name);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(0xFF232323),
                                title: Text('Editar Tabela', style: GoogleFonts.inter(color: Colors.white)),
                                content: TextField(
                                  controller: controller,
                                  style: GoogleFonts.inter(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Novo nome',
                                    hintStyle: GoogleFonts.inter(color: Colors.white54),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancelar', style: GoogleFonts.inter(color: Colors.white70)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (controller.text.trim().isNotEmpty) {
                                        setState(() {
                                          tables[index] = TableData(
                                            controller.text.trim(),
                                            table.color,
                                            table.keys,
                                          );
                                          // TODO: Atualizar nome da tabela no backend
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('OK', style: GoogleFonts.inter(color: Colors.grey.shade900)),
                                  ),
                                ],
                              ),
                            );
                          } else if (value == 1) {
                            // Deletar tabela
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(0xFF232323),
                                title: Text('Deletar Tabela', style: GoogleFonts.inter(color: Colors.red)),
                                content: Text(
                                  'Tem certeza que deseja deletar esta tabela?',
                                  style: GoogleFonts.inter(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancelar', style: GoogleFonts.inter(color: Colors.white70)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        tables.removeAt(index);
                                        // TODO: Remover tabela do backend
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text('Deletar Tabela', style: GoogleFonts.inter(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Row(
                              children: [
                                const Icon(Icons.edit, color: Colors.white70, size: 18),
                                const SizedBox(width: 8),
                                Text('Editar Tabela', style: GoogleFonts.inter(color: Colors.white)),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                const Icon(Icons.delete, color: Colors.red, size: 18),
                                const SizedBox(width: 8),
                                Text('Deletar Tabela', style: GoogleFonts.inter(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Largura mínima para 2 cards por linha
                              double cardWidth = (constraints.maxWidth - 8) / 2;
                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  SizedBox(
                                    width: cardWidth,
                                    child: AddKeyCard(
                                      onTap: () {
                                        showAddKeyDialog(table);
                                      },
                                    ),
                                  ),
                                  ...table.keys.map(
                                    (k) => SizedBox(
                                      width: cardWidth,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => KeyDetailScreen(keyName: k.name),
                                            ),
                                          );
                                        },
                                        child: item_card.KeyItemCard(
                                          keyName: k.name,
                                          cardColor: const Color(0xFF0F0F0F),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
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