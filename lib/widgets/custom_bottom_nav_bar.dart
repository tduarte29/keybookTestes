import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF181818),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 26),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list, size: 26),
          label: 'Tabelas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inbox_rounded, size: 26),
          label: 'Criar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 26),
          label: 'Buscar',
        ),
      ],
    );
  }
}