import 'package:chatbot/model/responses/examen_vph_response.dart';
import 'package:chatbot/view/screens/resultado_viewer.dart';
import 'package:chatbot/view/widgets/custom_app_bar.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final String nombrePaciente;
  final ExamenVphResponse resultado;

  const Result({
    super.key,
    required this.nombrePaciente,
    required this.resultado,
  });

  String _descripcionDiagnostico(String? diagnostico) {
    switch (diagnostico?.toLowerCase()) {
      case "alto":
        return "Positivo para VPH de riesgo intermedio/alto";
      case "bajo":
        return "Positivo para VPH de riesgo bajo";
      case "negativo":
        return "Negativo para VPH";
      default:
        return "Diagnóstico desconocido";
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Información del Examen",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 1.5, height: 30),
            _buildInfoItem("Paciente", nombrePaciente),
            const SizedBox(height: 10),
            _buildInfoItem("Fecha del examen", resultado.fechaResultado ?? "Desconocida"),
            const SizedBox(height: 10),
            _buildInfoItem("Diagnóstico", _descripcionDiagnostico(resultado.diagnostico)),
            const SizedBox(height: 30),
            Text(
              "En el siguiente apartado podrá visualizar su resultado completo en PDF.",
              style: TextStyle(fontSize: 14, color: AllowedColors.gray),
            ),
            const SizedBox(height: 15),
            Text(
              "Nombre del archivo: ${resultado.nombre}",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultadoViewer(resultado: resultado),
                    ),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Ver resultado en PDF"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String titulo, String contenido) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            contenido,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
