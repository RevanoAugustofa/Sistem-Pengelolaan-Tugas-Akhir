import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'revisi_proposal_pdf.dart';
import 'pdf_preview_page.dart';

class FormCatatanRevisiView extends StatefulWidget {
  final Map<String, dynamic> dataJadwal;
  const FormCatatanRevisiView({super.key, required this.dataJadwal});

  @override
  State<FormCatatanRevisiView> createState() => _FormCatatanRevisiViewState();
}

class _FormCatatanRevisiViewState extends State<FormCatatanRevisiView> {
  final List<TextEditingController> _controllers = [TextEditingController()];

  void _addPoint() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removePoint(int index) {
    if (_controllers.length > 1) {
      setState(() {
        _controllers.removeAt(index);
      });
    }
  }

  Future<void> _generatePdf() async {
    List<String> catatan = _controllers
        .map((c) => c.text)
        .where((t) => t.isNotEmpty)
        .toList();

    Uint8List pdfBytes = await ProposalRevisionPdf.generate(
      namaMahasiswa: widget.dataJadwal['nama_mahasiswa'] ?? '-',
      npm: widget.dataJadwal['npm'] ?? '-',
      judulProposal: widget.dataJadwal['judul_proposal'] ?? '-',
      tanggal: widget.dataJadwal['tanggal'] ?? '-',
      waktu: widget.dataJadwal['waktu'] ?? '-',
      ruangan: widget.dataJadwal['ruangan'] ?? '-',
      catatanRevisi: catatan,
      namaPenguji: widget.dataJadwal['nama_penguji'] ?? '-',
      jabatanPenguji: widget.dataJadwal['jabatan_penguji'] ?? '-',
      nidnPenguji: widget.dataJadwal['nidn_penguji'] ?? '-',
    );

    Get.to(() => PdfPreviewPage(
          pdfBytes: pdfBytes,
          fileName: "Revisi_Proposal_${widget.dataJadwal['npm']}.pdf",
        ));
  }

  @override
  Widget build(BuildContext context) {
    final String jabatan = widget.dataJadwal['jabatan_penguji'] ?? '-';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Input Catatan Revisi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF283D70),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Mahasiswa", widget.dataJadwal['nama_mahasiswa']),
            _buildInfoRow("NPM", widget.dataJadwal['npm']),
            _buildInfoRow("Peran Anda", "Dosen $jabatan Penguji"),
            const Divider(height: 30),
            Text(
              "Catatan Revisi ($jabatan):",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF283D70),
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _controllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: const Color(0xFF4A89FF),
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            hintText: "Tulis poin revisi...",
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      if (_controllers.length > 1)
                        IconButton(
                          onPressed: () => _removePoint(index),
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _addPoint,
              icon: const Icon(Icons.add, color: Color(0xFF4A89FF)),
              label: const Text(
                "Tambah Poin Revisi",
                style: TextStyle(color: Color(0xFF4A89FF), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _generatePdf,
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text(
                  "GENERATE & PREVIEW PDF",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A89FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Text(": ${value ?? '-'}", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
