import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class ProposalRevisionPdf {
  static Future<Uint8List> generate({
    required String namaMahasiswa,
    required String npm,
    required String judulProposal,
    required String tanggal,
    required List<String> catatanRevisi,
    required String namaPenguji,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'CATATAN REVISI SEMINAR PROPOSAL',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            
            // Student Info
            pw.Row(
              children: [
                pw.Container(width: 120, child: pw.Text('Nama Mahasiswa')),
                pw.Text(': $namaMahasiswa'),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              children: [
                pw.Container(width: 120, child: pw.Text('NPM')),
                pw.Text(': $npm'),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(width: 120, child: pw.Text('Judul Proposal')),
                pw.Expanded(child: pw.Text(': $judulProposal')),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              children: [
                pw.Container(width: 120, child: pw.Text('Tanggal Seminar')),
                pw.Text(': $tanggal'),
              ],
            ),
            
            pw.SizedBox(height: 30),
            pw.Text(
              'Catatan / Materi Revisi:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            
            // Revision List
            ...catatanRevisi.asMap().entries.map((entry) {
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('${entry.key + 1}. '),
                    pw.Expanded(child: pw.Text(entry.value)),
                  ],
                ),
              );
            }).toList(),
            
            if (catatanRevisi.isEmpty)
              pw.Text('- Tidak ada catatan revisi -', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),

            pw.Spacer(),
            
            // Signature Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  children: [
                    pw.Text('Padang, ${DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now())}'),
                    pw.SizedBox(height: 10),
                    pw.Text('Dosen Penguji,'),
                    pw.SizedBox(height: 60),
                    pw.Text(
                      namaPenguji,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
