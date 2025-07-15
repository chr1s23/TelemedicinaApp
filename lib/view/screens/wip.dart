import 'package:flutter/material.dart';

class WIPScreen extends StatelessWidget {
  const WIPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 100,
            color: Color(0xFFA51008),
          ),
          Text(
            '¡Sección en desarrollo!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            'Pronto podrás usar la visualización con Google Maps.\nEstamos trabajando para ofrecerte más opciones.',
            style: TextStyle(fontSize: 14), 
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 200),
        ],
      ),
    );
  }
}
