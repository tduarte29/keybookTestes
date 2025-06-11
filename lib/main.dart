import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';

// ADICIONE ESTES IMPORTS:
import 'screens/home_screen.dart';
import 'screens/key_list_screen.dart';
import 'screens/profile_screen.dart'; // Aqui está o CreateScreen
import 'screens/historic_screen.dart'; // Aqui está o SearchScreen
import 'widgets/custom_bottom_nav_bar.dart';
// FIM DOS IMPORTS

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

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const KeyListScreen(), // Agora o primeiro ícone é a lista de chaves
    const HomeScreen(),    // Home vai para o segundo ícone
    const CreateScreen(),
    const SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}