import 'package:flutter/material.dart';

class WIPScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 100,
          ),
          Text(
            '¡Próximamente!',
            style: TextStyle(fontSize: 40),
          ),
          Text(
            'Estamos trabajando en esta sección.',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 200),
        ],
      ),
    );
  }
}
