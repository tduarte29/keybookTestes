import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: Center(
        child: Text(
          'Tela de Perfil',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}





