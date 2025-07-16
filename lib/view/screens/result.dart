import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:chatbot/model/responses/examen_vph_response.dart';
import 'package:chatbot/view/screens/resultado_viewer.dart';
import 'package:chatbot/view/widgets/custom_app_bar.dart';
import 'package:chatbot/view/widgets/utils.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
      case "bajo":
        return "Un resultado positivo en VPH no significa que tengas cáncer.\nEs un virus común que, en la mayoría de los casos, se elimina solo en uno o dos años.\nLo más importante es acudir al médico para hacer los controles necesarios. Puedes identificar el centro de salud más cercano usando el mapa de nuestra aplicación.\nComo recomendación utiliza preservativo en tus relaciones. Detectarlo a tiempo te da la oportunidad de actuar y proteger tu salud.";
      case "negativo":
        return "No se detectaron genotipos de VPH dentro de los incluidos en la prueba. Se sugiere repetir el estudio en 5 años, de acuerdo con las recomendaciones para el tamizaje rutinario.";
      default:
        return "Consulta con tu médico para más información.";
    }
  }

  Future<void> solicitarPermisos() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }
  }

  Future<void> guardarPdfDesdeBytes(
      Uint8List pdfBytes, String fileName, BuildContext context) async {
    try {
      final dir =
          await getExternalStorageDirectory(); // ruta como /storage/emulated/0/Android/data/tu.app/files/
      final filePath = "${dir!.path}/$fileName.pdf";
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ PDF guardado exitosamente, revisa tu carpeta de descargas.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al guardar PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
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
                      _buildInfoItem("Fecha del examen",
                          resultado.fechaResultado ?? "Desconocida"),
                      const SizedBox(height: 10),
                      _buildInfoItem("Diagnóstico",
                          _descripcionDiagnostico(resultado.diagnostico)),
                      const SizedBox(height: 30),
                      Text(
                        "En el siguiente apartado podrá visualizar su resultado completo en PDF.",
                        style:
                            TextStyle(fontSize: 14, color: AllowedColors.gray),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Nombre del archivo: ${resultado.nombre}",
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ResultadoViewer(resultado: resultado),
                              ),
                            );
                          },
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text("Ver resultado en PDF"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await solicitarPermisos();

                            final pdfBytes = resultado.contenido;
                            if (pdfBytes == null || pdfBytes.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('No se encontró el archivo PDF')),
                              );
                              return;
                            }

                            await guardarPdfDesdeBytes(
                              Uint8List.fromList(pdfBytes),
                              resultado.nombre ?? 'resultado',
                              context,
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: const Text("Descargar PDF"),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
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
