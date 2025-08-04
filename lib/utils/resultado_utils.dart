import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/resultado_service.dart';
import 'package:chatbot/view/screens/resultado_viewer.dart';
import 'package:chatbot/view/screens/result.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

Future<void> mostrarResultadoDesdeContexto(BuildContext context) async {
  bool dialogoAbierto = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final userDeviceId = await secureStorage.read(key: "user_device");

    if (userDeviceId == null) {
      showSnackBar(context, "No se encontró el dispositivo del usuario, dispositivo: $userDeviceId");
      return;
    }

    final resultado = await ResultadoService.obtenerResultado(userDeviceId);
    final nombrePaciente = await secureStorage.read(key: "user_name");

    if (resultado != null && context.mounted) {
      dialogoAbierto = false;
      Navigator.of(context).pop();

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Result(
            nombrePaciente: nombrePaciente ?? "Paciente",
            resultado: resultado,
          ),
        ),
      );
      // Cierra el spinner SOLO después de que la pantalla Result se haya cerrado
      if (context.mounted) Navigator.of(context).pop();
    }
  } catch (e) {
    showSnackBar(context, "Ocurrió un error al obtener el resultado.");
  } finally {
    // Si aún no se ha cerrado el diálogo, cerrarlo aquí
    if (dialogoAbierto && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
