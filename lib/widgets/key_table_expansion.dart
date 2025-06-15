import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/table_data.dart';
import 'add_key_card.dart';
import '../widgets/key_item_card.dart' as item_card;
import '../screens/key_detail_screen.dart';

class KeyTableExpansion extends StatelessWidget {
  final TableData table;
  final int index;
  final Function(int, String) onEditTable;
  final Function(int) onDeleteTable;
  final Function(TableData) onAddKey;
  final Function(String) onKeyTap;

  const KeyTableExpansion({
    super.key,
    required this.table,
    required this.index,
    required this.onEditTable,
    required this.onDeleteTable,
    required this.onAddKey,
    required this.onKeyTap,
  });

  @override
  Widget build(BuildContext context) {
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
                        onEditTable(index, controller.text.trim());
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
                      onDeleteTable(index);
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
              double cardWidth = (constraints.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: AddKeyCard(
                      onTap: () => onAddKey(table),
                    ),
                  ),
                  ...table.keys.map(
                    (k) => SizedBox(
                      width: cardWidth,
                      child: GestureDetector(
                        onTap: () => onKeyTap(k.name),
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
  }
}