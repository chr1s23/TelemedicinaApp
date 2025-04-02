import 'package:chatbot/view/widgets/custom_app_bar.dart';
import 'package:chatbot/view/widgets/custom_input_decoration.dart';
import 'package:chatbot/view/widgets/pdf_viewer.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

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
      appBar: const CustomAppBar(),
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
      //bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Resultado",
      textAlign: TextAlign.center,
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
              ? PDFViewer(assetPath: widget.pdfPath)
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
      decoration: CustomInputDecoration.getDecoration("Detalle resultado"),
      style: TextStyle(fontSize: 15, color: AllowedColors.black),
    );
  }
}