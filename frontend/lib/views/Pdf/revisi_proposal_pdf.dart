import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

    // Load logo from assets using rootBundle for web compatibility
    final ByteData bytes = await rootBundle.load('img/logo_pnc.png');
    final Uint8List logoBytes = bytes.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 30,
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 70,
                    height: 70,
                    child: pw.Image(logoImage),
                  ),

                  pw.SizedBox(width: 15),

                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'KEMENTERIAN PENDIDIKAN, KEBUDAYAAN,',
                          style: const pw.TextStyle(fontSize: 12),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          'RISET, DAN TEKNOLOGI',
                          style: const pw.TextStyle(fontSize: 12),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          'POLITEKNIK NEGERI CILACAP',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.SizedBox(height: 4),

                        pw.Text(
                          'Jalan Dr. Soetomo No. 1, Sidakaya - CILACAP 53212 Jawa Tengah',
                          style: const pw.TextStyle(fontSize: 9),
                          textAlign: pw.TextAlign.center,
                        ),

                        pw.Text(
                          'Telepon: (0282) 533329 , Fax: (0282) 537992',
                          style: const pw.TextStyle(fontSize: 9),
                          textAlign: pw.TextAlign.center,
                        ),

                        pw.Text(
                          'Website:www.pnc.ac.id, Email: sekretariat@pnc.ac.id',
                          style: const pw.TextStyle(fontSize: 9),
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10),

              pw.Divider(
                thickness: 1.5,
                color: PdfColors.black,
              ),

              pw.SizedBox(height: 25),

              // ================= TITLE =================
              pw.Center(
                child: pw.Text(
                  'FORM REVISI SIDANG PROPOSAL TUGAS AKHIR',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                'Hasil Revisi Sidang Proposal Tugas Akhir Untuk Mahasiswa:',
                style: const pw.TextStyle(fontSize: 10),
              ),

              pw.SizedBox(height: 15),

              // ================= BIODATA =================
              _buildRow('Nama', namaMahasiswa),
              _buildRow('NPM', npm),
              _buildRow('Judul Tugas Akhir', judulProposal),
              _buildRow('Hari / Tanggal', tanggal),
              _buildRow('Waktu', '08.00-10.00'),
              _buildRow('Ruang', 'R.3.7'),

              pw.SizedBox(height: 20),

              // ================= BOX REVISI =================
              pw.Container(
                width: double.infinity,
                height: 280,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColors.black,
                    width: 1,
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(6),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom: pw.BorderSide(),
                        ),
                      ),
                      child: pw.Text(
                        'Hasil Revisi',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),

                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: catatanRevisi.isNotEmpty
                            ? catatanRevisi.asMap().entries.map((e) {
                                return pw.Padding(
                                  padding: const pw.EdgeInsets.only(bottom: 6),
                                  child: pw.Text(
                                    '${e.key + 1}. ${e.value}',
                                    style: const pw.TextStyle(fontSize: 10),
                                  ),
                                );
                              }).toList()
                            : [
                                pw.Text(
                                  '-',
                                  style: const pw.TextStyle(fontSize: 10),
                                )
                              ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              // ================= TTD =================
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'Cilacap, ${DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now())}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),

                    pw.SizedBox(height: 5),

                    pw.Text(
                      'Dosen Ketua Penguji Proposal',
                      style: const pw.TextStyle(fontSize: 10),
                    ),

                    pw.SizedBox(height: 70),

                    pw.Text(
                      namaPenguji,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),

                    pw.SizedBox(height: 3),

                    pw.Text(
                      'NIDN. 199508282024061003',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildRow(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 120,
            child: pw.Text(
              title,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),

          pw.Text(
            ': ',
            style: const pw.TextStyle(fontSize: 10),
          ),

          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}