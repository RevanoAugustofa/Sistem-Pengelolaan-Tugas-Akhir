import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfPreviewPage extends StatelessWidget {
  final String url;
  final String title;

  const PdfPreviewPage({super.key, required this.url, required this.title});

  Future<void> _launchInBrowser() async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug URL
    debugPrint("Attempting to load PDF from: $url");

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF0056A8),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _launchInBrowser,
            tooltip: "Buka di Browser",
          ),
        ],
      ),
      body: SfPdfViewer.network(
        url,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          debugPrint("PDF Load Failed: ${details.description}");
          debugPrint("Error Code: ${details.error}");
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memuat PDF: ${details.description}'),
              action: SnackBarAction(
                label: 'Buka Browser',
                onPressed: _launchInBrowser,
              ),
            ),
          );
        },
      ),
    );
  }
}
