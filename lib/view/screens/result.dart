import 'package:chatbot/view/screens/chat.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/screens/notifications.dart';
import 'package:chatbot/view/screens/resources.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'dart:async';
import 'package:logging/logging.dart';

final _log = Logger('Result');

class Result extends StatefulWidget {
  final String pdfPath; // Ruta del PDF

  const Result({super.key, required this.pdfPath});

  @override
  State<Result> createState() => _ResultPageState();
}

class _ResultPageState extends State<Result> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFileExists();
  }

  Future<void> _checkFileExists() async {
    File file = File(widget.pdfPath);
    if (await file.exists()) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 15),
            _buildPdfViewer(),
            const SizedBox(height: 20),
            _buildTextFields(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
          color: AllowedColors.red,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTitle() {
    return Text(
      "Resultado",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AllowedColors.black,
      ),
    );
  }

  Widget _buildPdfViewer() {
    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.pdfPath.isNotEmpty
              ? PDFView(
                  filePath: widget.pdfPath,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageSnap: true,
                  fitPolicy: FitPolicy.BOTH,
                  onError: (error) {
                    _log.severe("Error al cargar PDF: $error");
                  },
                  onRender: (_) {
                    setState(() {});
                  },
                )
              : const Center(
                  child: Text(
                    "No se encontró el PDF",
                    style: TextStyle(
                        fontSize: 12, color: AllowedColors.red),
                  ),
                ),
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        _buildReadOnlyField("Nombre del Paciente", "Gabriela Orellana"),
        const SizedBox(height: 10),
        _buildReadOnlyField("Fecha del Examen", "15/02/2024"),
        const SizedBox(height: 10),
        _buildReadOnlyField("Resultado", "Negativo"),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(fontSize: 12, color: AllowedColors.gray),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: AllowedColors.gray,
      ),
      style: TextStyle(fontSize: 15, color: AllowedColors.black),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home, true,
                MaterialPageRoute(builder: (context) => Dashboard())),
            _buildNavItem(Icons.folder, false,
                MaterialPageRoute(builder: (context) => Resources())),
            _buildFloatingButton(), // Botón central del chatbot
            _buildNavItem(Icons.map, false, null),
            _buildNavItem(Icons.notifications, false,
                MaterialPageRoute(builder: (context) => Notifications())),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool marked, MaterialPageRoute? nav) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: () {
              if (nav != null) {
                Navigator.push(context, nav);
              }
            },
            icon: Icon(icon,
                color: marked
                    ? AllowedColors.blue
                    : AllowedColors.gray,
                size: 28))
      ],
    );
  }

  Widget _buildFloatingButton() {
    return Transform.translate(
      offset: const Offset(0, -10),
      child: FloatingActionButton(
        backgroundColor: AllowedColors.blue,
        onPressed: () {
          // Acción del asistente virtual
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Chat()));
        },
        child: const Icon(Icons.smart_toy, size: 28, color: AllowedColors.white),
      ),
    );
  }
}
