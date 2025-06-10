import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const KeybookApp());
}

class KeybookApp extends StatelessWidget {
  const KeybookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: AppRoutes.routes,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1D1D1D), // Fundo global
        textTheme: GoogleFonts.interTextTheme(),
      ),
    );
  }
}