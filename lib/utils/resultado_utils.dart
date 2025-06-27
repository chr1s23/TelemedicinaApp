import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/resultado_service.dart';
import 'package:chatbot/view/screens/resultado_viewer.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

Future<void> mostrarResultadoDesdeContexto(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  final userDeviceId = await secureStorage.read(key: "user_device");

  if (userDeviceId == null) {
    Navigator.of(context).pop();
    showSnackBar(context, "No se encontró el dispositivo del usuario.");
    return;
  }

  final resultado = await ResultadoService.obtenerResultado(userDeviceId);

  if (resultado != null && context.mounted) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultadoViewer(resultado: resultado)),
    );
  }
}
