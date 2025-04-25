import 'package:chatbot/model/requests/examen_vph_request.dart';
import 'package:chatbot/model/requests/salud_sexual_request.dart';
import 'package:chatbot/model/requests/sesion_chat_request.dart';
import 'package:chatbot/view/screens/scanner_result.dart';
import 'package:chatbot/view/widgets/custom_app_bar.dart';
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
  ExamenVphRequest? examen;
  final MobileScannerController _scannerController = MobileScannerController();

  void _onQRScanned(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty) {
      String qrData = capture.barcodes.first.rawValue ?? "Código QR no válido";
      _scannerController.stop();
      if (!widget.deviceRegister) {
        examen = ExamenVphRequest(qrData, widget.salud!,
            DateTime.now().toIso8601String().split('.').first);
        widget.sesion!.examenVph = examen;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScannerResultPage(
                  qrData: qrData,
                  deviceRegister: widget.deviceRegister,
                  restartScanner: () => _scannerController.start(),
                  sesion: widget.sesion)));
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(profileButton: false),
      body: Column(
        children: [
          _buildSubtitle(),
          Expanded(child: _buildQRScanner()),
        ],
      ),
    );
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
