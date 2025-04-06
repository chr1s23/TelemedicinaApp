import 'dart:convert';
import 'dart:typed_data';

import 'package:chatbot/service/archivo_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:pdfx/pdfx.dart';

final _log = Logger('PDFViewer');

class PDFViewer extends StatefulWidget {
  const PDFViewer({super.key, required this.pdfName});
  final String pdfName;

  @override
  State<StatefulWidget> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  PdfControllerPinch? pdfController;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    try {
      String? base64String =
          await ArchivoService.getArchivo(context, widget.pdfName);
      if (base64String == null) return;

      Uint8List pdfBytes = base64Decode(base64String);
      final controller = PdfControllerPinch(
        document: PdfDocument.openData(pdfBytes),
      );

      setState(() {
        pdfController = controller;
      });
    } catch (e, stackTrace) {
      _log.severe('Error loading PDF', e, stackTrace);
    }
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return pdfController == null
        ? const Center(child: CircularProgressIndicator())
        : PdfViewPinch(
            controller: pdfController!,
            onDocumentError: (error) => _log.severe(error),
          );
  }
}
