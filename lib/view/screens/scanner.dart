import 'package:chatbot/model/requests/dispositivo_request.dart';
import 'package:chatbot/model/requests/sesion_chat_request.dart';
import 'package:chatbot/service/paciente_service.dart';
import 'package:chatbot/service/sesion_chat_service.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatefulWidget {
  Scanner({super.key, this.deviceRegister = false});

  bool deviceRegister;

  @override
  State<Scanner> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<Scanner> {
  final MobileScannerController _scannerController = MobileScannerController();

  void _onQRScanned(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty) {
      String qrData = capture.barcodes.first.rawValue ?? "Código QR no válido";
      _scannerController.stop();
      _showQRResultDialog(qrData);
    }
  }

  void _showQRResultDialog(String qrData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Código QR escaneado correctamente!"),
        content: Text(qrData),
        actions: [
          TextButton(
            onPressed: () {
              _scannerController.start();
              Navigator.pop(context);
            },
            child: const Text("Escanear de nuevo"),
          ),
          TextButton(
            onPressed: () async {
              if (widget.deviceRegister) {
                await PacienteService.registrarDispositivo(
                    context, DispositivoRequest(qrData));
              } else {
                //TODO: Logica para recolectar las preguntas del formulario y guardarlas en el servidor
                //inicio y fin deben ser de la forma 2025-03-10T10:30:00
                //cuentaPublicId es el id del usuario
                //contenido es un string con todo el contenido del chat
                //se requiere la informacion sexual del formulario SaludSexualRequest obligatoriamente
                //await SesionChatService.registrarInfoExamen(context, SesionChatRequest(cuentaPublicId, inicio, fin, contenido, SaludSexualRequest));
              }

              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context,
                    qrData); // Devuelve el resultado a la pantalla anterior
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              }
            },
            child: const Text("Aceptar"),
          ),
        ],
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
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AllowedColors.red,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Coloca el código QR dentro del recuadro para escanearlo automáticamente.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13, color: Colors.black54),
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
