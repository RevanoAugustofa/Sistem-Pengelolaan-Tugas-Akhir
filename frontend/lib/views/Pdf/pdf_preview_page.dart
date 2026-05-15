import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  final Uint8List pdfBytes;
  final String fileName;

  const PdfPreviewPage({
    super.key,
    required this.pdfBytes,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preview PDF",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF283D70),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PdfPreview(
        build: (format) => pdfBytes,
        canChangePageFormat: false,
        canChangeOrientation: false,
        maxPageWidth: 700,
        pdfFileName: fileName,
        loadingWidget: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
