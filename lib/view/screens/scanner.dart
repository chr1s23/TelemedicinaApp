import 'package:chatbot/view/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});
  
  @override
  State<Scanner> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<Scanner> {
  final MobileScannerController _scannerController = MobileScannerController();

  void _onQRScanned(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty) {
      String qrData = capture.barcodes.first.rawValue ?? "Código no válido";
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, qrData); // Devuelve el resultado a la pantalla anterior
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
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
        "HELPY",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(165, 16, 08, 1),
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
