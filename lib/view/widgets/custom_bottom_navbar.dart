import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color.fromRGBO(0, 40, 86, 1),
      unselectedItemColor: Color.fromRGBO(111, 111, 111, 1),
      showSelectedLabels: true,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Inicio",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          label: "Recursos",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy, size: 30), // Ícono más grande para chatbot
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: "Mapa",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Notificaciones",
        ),
      ],
    );
  }
}
