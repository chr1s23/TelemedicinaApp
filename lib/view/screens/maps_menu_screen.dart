import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'maps_screen.dart';

class MapsMenuScreen extends StatelessWidget {
  const MapsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
            "Servicios de Salud",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AllowedColors.black),
          ),),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MapsScreen(establecimiento: 'CENTRO_SALUD'),
                  ),
                );
              },
              child: const Text('Mapa - Centros de Salud y Hospitales'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapsScreen(
                        establecimiento: 'CENTRO_PROTECCION'),
                  ),
                );
              },
              child: const Text('Mapa - Centros contra la Violencia'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapsScreen(
                        establecimiento: 'ATENCION_PSICOLOGICA'),
                  ),
                );
              },
              child: const Text('Mapa - Centros de Atención Psicológica'),
            ),
          ],
        ),
      ),
    );
  }
}
