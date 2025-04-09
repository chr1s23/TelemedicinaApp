import 'package:chatbot/model/requests/dispositivo_request.dart';
import 'package:chatbot/model/requests/sesion_chat_request.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/chat_service.dart';
import 'package:chatbot/service/paciente_service.dart';
import 'package:chatbot/service/sesion_chat_service.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/widgets/custom_app_bar.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chatbot/view/widgets/custom_loading_button.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

var _isLoading = false;

class ScannerResultPage extends StatefulWidget {
  const ScannerResultPage({super.key, required this.qrData, required this.deviceRegister, required this.restartScanner, this.sesion});

  final String qrData;
  final bool deviceRegister;
  final SesionChatRequest? sesion;
  final void Function() restartScanner;

  @override
  State<ScannerResultPage> createState() => ScannerResultPageState();
}

class ScannerResultPageState extends State<ScannerResultPage> {
  void _registerDevice(device) async {
    FocusScope.of(context).unfocus();
    if (_isLoading) return; // Evita múltiples clics

    setState(() {
      _isLoading = true;
    });

    if (widget.deviceRegister) {
      bool? registered = await PacienteService.registrarDispositivo(
          context, DispositivoRequest(device));
      if (registered != null && registered) {
        secureStorage.write(key: "user_device", value: device);
      }
    } else {
      await SesionChatService.registrarInfoExamen(context, widget.sesion!);
      ChatService().reset(widget.sesion!.cuentaPublicId);
    }
    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(profileButton: false),
      body: Center(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Dispositivo de Autmouestreo escaneado correctamente!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AllowedColors.gray.withAlpha(50), // Fondo más opaco
                    borderRadius: BorderRadius.circular(8),
                    border:
                      Border.all(color: Colors.black, width: 1), // Borde negro
                  ),
                  child: Text(
                    widget.qrData,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  widget.deviceRegister
                    ? "Presiona el botón 'Aceptar' para registrar el dispositivo de Automuestreo!."
                    : "✅ Todo listo!\nPresiona el botón 'Aceptar' para terminar el proceso.\nRecuerda entregar el dispositivo de Automuestreo en el GAD más cercano.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 25),
                CustomButton(
                    color: AllowedColors.red,
                    onPressed: () {
                      widget.restartScanner();
                      Navigator.pop(context);
                    },
                    label: "Escanear de nuevo"),
                SizedBox(height: 15),
                CustomLoadingButton(
                    color: AllowedColors.blue,
                    label: "Aceptar",
                    loading: _isLoading,
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (widget.qrData != "Código QR no válido") {
                              _registerDevice(widget.qrData);
                            }
                          })
              ],
            ),
          ),
      ),
    );
  }
}