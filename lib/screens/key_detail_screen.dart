import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KeyDetailScreen extends StatelessWidget {
  final String keyName;
  const KeyDetailScreen({super.key, required this.keyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(keyName, style: GoogleFonts.inter()),
        backgroundColor: const Color(0xFF232323),
      ),
      body: Center(
        child: Text(
          'Detalhes da chave "$keyName"',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
        ),
      ),
      backgroundColor: const Color(0xFF1D1D1D),
    );
  }
}