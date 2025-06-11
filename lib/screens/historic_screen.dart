import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: Center(
        child: Text(
          'Tela de Historico',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}