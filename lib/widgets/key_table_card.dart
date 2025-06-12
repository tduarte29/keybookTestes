import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KeyTableCard extends StatelessWidget {
  final String label;
  final Color labelColor;
  final int itemCount;
  final List<Widget> keyItems;

  const KeyTableCard({
    super.key,
    required this.label,
    required this.labelColor,
    required this.itemCount,
    required this.keyItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: labelColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$itemCount items',
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Icon(Icons.more_horiz, color: Colors.white70),
            ],
          ),
          if (keyItems.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: keyItems
                  .map((item) => SizedBox(
                        width: (MediaQuery.of(context).size.width - 48) / 2, // 2 por linha
                        child: item,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class AddKeyCard extends StatelessWidget {
  const AddKeyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(2),
      child: Center(
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class KeyItemCard extends StatelessWidget {
  final String keyName;

  const KeyItemCard({super.key, required this.keyName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          keyName,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Exemplo de uso do KeyTableCard com os dados fornecidos
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Key Table Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            KeyTableCard(
              label: 'Chevrolet',
              labelColor: Colors.redAccent,
              itemCount: 4,
              keyItems: [
                const AddKeyCard(), // <-- Botão de adicionar chave
                KeyItemCard(keyName: 'BSD12931'),
                KeyItemCard(keyName: 'DSS36472'),
                KeyItemCard(keyName: 'ABC12345'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}