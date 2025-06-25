import 'package:flutter/material.dart';

class ResultadoViewer extends StatelessWidget {
  const ResultadoViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resultado PDF")),
      body: const Center(child: Text("Aquí se mostrará el PDF.")),
    );
  }
}
