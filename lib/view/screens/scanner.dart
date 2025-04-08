import 'package:chatbot/model/requests/dispositivo_request.dart';
import 'package:chatbot/model/requests/examen_vph_request.dart';
import 'package:chatbot/model/requests/salud_sexual_request.dart';
import 'package:chatbot/model/requests/sesion_chat_request.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/chat_service.dart';
import 'package:chatbot/service/paciente_service.dart';
import 'package:chatbot/service/sesion_chat_service.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chatbot/view/widgets/custom_loading_button.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner(
      {super.key, this.deviceRegister = false, this.sesion, this.salud});

  final bool deviceRegister;
  final SesionChatRequest? sesion;
  final SaludSexualRequest? salud;

  @override
  State<Scanner> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<Scanner> {
  bool _isLoading = false;
  ExamenVphRequest? examen;
  final MobileScannerController _scannerController = MobileScannerController();

  void _onQRScanned(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty) {
      String qrData = capture.barcodes.first.rawValue ?? "Código QR no válido";
      _scannerController.stop();
      if (!widget.deviceRegister) {
        examen = ExamenVphRequest(qrData, widget.salud!);
        widget.sesion!.examenVph = examen;
      } //TODO: Cambiar el dialogo por una ventana aparte, tal como esta en el prototipo
      _showQRResultDialog(qrData);
    }
  }

  void registerDevice(device) async {
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }

  void _showQRResultDialog(String qrData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: AllowedColors.white,
        insetPadding: EdgeInsets.zero,
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
                  qrData,
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
                    _scannerController.start();
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
                          if (qrData != "Código QR no válido") {
                            registerDevice(qrData);
                          }
                        })
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSubtitle(),
          Expanded(child: _buildQRScanner()),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        elevation: 0,
        title: Text(
          "SISA",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AllowedColors.red,
          ),
        ),
        centerTitle: true);
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Automuestreo\nColoca el código QR dentro del recuadro para escanearlo automáticamente.",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AllowedColors.black),
      ),
    );
  }

  Widget _buildQRScanner() {
    return MobileScanner(
      controller: _scannerController,
      onDetect: _onQRScanned,
    );
  }
}
