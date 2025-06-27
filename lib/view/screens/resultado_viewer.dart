import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import '../../model/responses/examen_vph_response.dart'; // ajusta si es necesario

class ResultadoViewer extends StatefulWidget {
  final ExamenVphResponse resultado;

  const ResultadoViewer({super.key, required this.resultado});

  @override
  State<ResultadoViewer> createState() => _ResultadoViewerState();
}

class _ResultadoViewerState extends State<ResultadoViewer> {
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    _prepararPDF();
  }

  Future<void> _prepararPDF() async {
    if (widget.resultado.contenido == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se encontró el contenido del PDF.")),
        );
      }
      return;
    }

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/resultado.pdf");
    await file.writeAsBytes(widget.resultado.contenido!);

    setState(() {
      pdfPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultado PDF"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst); // vuelve al dashboard
          },
        ),
      ),
      body: pdfPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: pdfPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
            ),
    );
  }
}
