import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final int filterOption;
  final ValueChanged<String> onChanged;
  final ValueChanged<int> onFilterChanged;

  const SearchFilterBar({
    super.key,
    required this.controller,
    required this.filterOption,
    required this.onChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search, color: Colors.white54, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Pesquisar items',
                hintStyle: GoogleFonts.inter(color: Colors.white54),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
            ),
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.filter_list, color: Colors.white54, size: 22),
            color: const Color(0xFF232323),
            onSelected: onFilterChanged,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    const Icon(Icons.sort_by_alpha, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('Ordem Alfabética (A-Z)', style: GoogleFonts.inter(color: Colors.white)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    const Icon(Icons.sort_by_alpha, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('Ordem Alfabética (Z-A)', style: GoogleFonts.inter(color: Colors.white)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('Mais Recentes', style: GoogleFonts.inter(color: Colors.white)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('Mais Antigas', style: GoogleFonts.inter(color: Colors.white)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 4,
                child: Row(
                  children: [
                    const Icon(Icons.vpn_key, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('Filtrar por Propriedade Importante', style: GoogleFonts.inter(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}