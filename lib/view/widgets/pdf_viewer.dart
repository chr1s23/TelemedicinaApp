import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:pdfx/pdfx.dart';

final _log = Logger('PDFViewer');

class PDFViewer extends StatefulWidget {
  const PDFViewer({super.key, required this.assetPath});
  final String assetPath;
  
  @override
  State<StatefulWidget> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  late PdfControllerPinch pdfController;

  @override
  void initState() {
    pdfController = PdfControllerPinch(
      document: PdfDocument.openAsset(widget.assetPath),
    );
    super.initState();
  }

  @override
  void dispose() {
    pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PdfViewPinch(
      controller: pdfController,
      onDocumentError: (error) => _log.severe(error),
    );
  }
}