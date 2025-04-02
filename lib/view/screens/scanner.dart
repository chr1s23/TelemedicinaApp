import 'package:chatbot/model/requests/dispositivo_request.dart';
import 'package:chatbot/service/paciente_service.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
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
    bool isLoading = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: AllowedColors.white,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          //height: MediaQuery.of(context).size.height * 0.9,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.center,
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
                "✅ Todo listo!\nRecuerda entregar el dispositivo de Automuestreo en el GAD más cercano.",
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
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AllowedColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true; // Activa el estado de carga
                          });

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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard()));
                          }
                          setState(() {
                            isLoading = false; // Desactiva el estado de carga
                          });
                        },
                  child: isLoading
                      ? CircularProgressIndicator(color: AllowedColors.white)
                      : Text(
                          "Aceptar",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AllowedColors.white),
                        ),
                ),
              )
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
      centerTitle: true,
      actions: [
        IconButton(
          icon: CircleAvatar(
            backgroundImage:
                AssetImage('assets/images/avatar.png'), // Imagen del avatar
            radius: 15,
          ),
          onPressed: () {
            // Acción del perfil
            _showQRResultDialog("pruebas de codigo qr");
          },
        ),
      ],
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
