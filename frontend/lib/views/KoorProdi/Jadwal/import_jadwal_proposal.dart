import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' hide Border;
import '../../../controllers/koorprodi_controller.dart';

class ImportJadwalProposalPage extends StatefulWidget {
  const ImportJadwalProposalPage({super.key});

  @override
  State<ImportJadwalProposalPage> createState() => _ImportJadwalProposalPageState();
}

class _ImportJadwalProposalPageState extends State<ImportJadwalProposalPage> {
  final KoorProdiController controller = Get.find<KoorProdiController>();
  String? _fileName;
  List<Map<String, dynamic>> _previewData = [];
  bool _isLoading = false;
  bool _hasError = false;

  // Fungsi untuk mengunduh template Jadwal Proposal
  Future<void> _downloadTemplate() async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Header Template
    List<String> headers = [
      "NIM",
      "Nama Mahasiswa",
      "Judul Proposal",
      "Tanggal (YYYY-MM-DD)",
      "Jam Mulai (HH:MM)",
      "Jam Selesai (HH:MM)",
      "Ruangan",
      "Dosen Penguji 1",
      "Dosen Penguji 2"
    ];

    for (int i = 0; i < headers.length; i++) {
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(headers[i]);
    }

    // Contoh Data
    List<String> example = [
      "220101001",
      "Mahasiswa Contoh",
      "Sistem Informasi Akademik Berbasis Mobile",
      "2026-05-20",
      "08:00",
      "09:00",
      "Lab Komputer 1",
      "Dosen Penguji A, M.T.",
      "Dosen Penguji B, S.Kom."
    ];

    for (int i = 0; i < example.length; i++) {
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1)).value = TextCellValue(example[i]);
    }

    var fileBytes = excel.save();
    
    String? outputFile = await FilePicker.saveFile(
      dialogTitle: 'Simpan Template Jadwal Proposal',
      fileName: 'template_import_jadwal_proposal.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      bytes: Uint8List.fromList(fileBytes!),
    );

    if (outputFile != null) {
      Get.snackbar("Sukses", "Template berhasil diunduh", backgroundColor: Colors.green, colorText: Colors.white);
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _fileName = file.name;
          _previewData = [];
        });
        if (file.bytes != null) _processExcel(file.bytes!);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memilih file: $e");
    }
  }

  Future<void> _processExcel(Uint8List bytes) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      var excel = Excel.decodeBytes(bytes);
      List<Map<String, dynamic>> tempItems = [];
      
      for (var table in excel.tables.keys) {
        var rows = excel.tables[table]?.rows;
        if (rows == null || rows.length <= 1) continue;

        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];
          if (row.isEmpty || row.length < 3) continue;

          String nim = row[0]?.value?.toString() ?? "";
          String namaMhs = row[1]?.value?.toString() ?? "";
          String judul = row[2]?.value?.toString() ?? "";
          String tanggal = (row.length > 3) ? row[3]?.value?.toString() ?? "" : "";
          String jamMulai = (row.length > 4) ? row[4]?.value?.toString() ?? "" : "";
          String jamSelesai = (row.length > 5) ? row[5]?.value?.toString() ?? "" : "";
          String namaRuangan = (row.length > 6) ? row[6]?.value?.toString() ?? "" : "";
          String namaPenguji1 = (row.length > 7) ? row[7]?.value?.toString() ?? "" : "";
          String namaPenguji2 = (row.length > 8) ? row[8]?.value?.toString() ?? "" : "";

          // Lookup IDs
          var mhs = controller.listMahasiswa.firstWhereOrNull((m) => m.npm == nim);
          var ruangan = controller.listRuangan.firstWhereOrNull((r) => r.namaRuangan?.toLowerCase() == namaRuangan.toLowerCase());
          var penguji1 = controller.listDosenManajemen.firstWhereOrNull((d) => d.namaDosen?.toLowerCase() == namaPenguji1.toLowerCase());
          var penguji2 = controller.listDosenManajemen.firstWhereOrNull((d) => d.namaDosen?.toLowerCase() == namaPenguji2.toLowerCase());

          String? errorMsg;
          if (mhs == null) errorMsg = "NIM $nim tidak ditemukan";
          else if (ruangan == null) errorMsg = "Ruangan $namaRuangan tidak ditemukan";
          else if (penguji1 == null) errorMsg = "Penguji 1 tidak ditemukan";
          else if (penguji2 == null) errorMsg = "Penguji 2 tidak ditemukan";

          if (errorMsg != null) _hasError = true;

          tempItems.add({
            'id_mahasiswa': mhs?.id,
            'nim': nim,
            'nama': namaMhs,
            'judul': judul,
            'tanggal': tanggal,
            'waktu_mulai': jamMulai,
            'waktu_selesai': jamSelesai,
            'id_ruang_sidang': ruangan?.id,
            'ruangan': namaRuangan,
            'id_penguji_utama': penguji1?.id,
            'nama_penguji1': namaPenguji1,
            'id_penguji_pendamping': penguji2?.id,
            'nama_penguji2': namaPenguji2,
            'jenis_sidang': 'proposal',
            'error': errorMsg,
          });
        }
      }
      setState(() => _previewData = tempItems);
    } catch (e) {
      Get.snackbar("Error", "Gagal membaca excel: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSave() async {
    if (_hasError) {
      Get.snackbar("Perhatian", "Harap perbaiki data yang error sebelum menyimpan", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    setState(() => _isLoading = true);
    // Di sini nanti panggil controller.importJadwal(tempItems)
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    Get.snackbar("Selesai", "Berhasil mengimpor ${_previewData.length} data jadwal proposal.");
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), 
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        title: const Text("Import Jadwal Proposal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30), onPressed: () => Get.back()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOMBOL UNDUH TEMPLATE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.shade200)),
              child: Row(
                children: [
                  const Icon(Icons.description, color: Colors.green, size: 30),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Gunakan Template", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text("Unduh template agar format data sesuai.", style: TextStyle(fontSize: 13, color: Colors.black54)),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _downloadTemplate,
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text("Unduh Template (.xlsx)"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, elevation: 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Pilih File Excel", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildFilePicker(),
            if (_isLoading) const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
            if (!_isLoading && _previewData.isNotEmpty) ...[
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pratinjau (${_previewData.length} data)", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (_hasError) const Text("Ada Error!", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              _buildPreviewTable(),
              const SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilePicker() {
    return InkWell(
      onTap: _pickFile,
      child: Container(
        width: double.infinity, padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
        child: Row(
          children: [
            const Icon(Icons.file_upload, color: Colors.blue),
            const SizedBox(width: 15),
            Expanded(child: Text(_fileName ?? "Klik untuk pilih file .xlsx")),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewTable() {
    return Card(
      elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFEEEEEE)),
          columns: const [
            DataColumn(label: Text('Mahasiswa')),
            DataColumn(label: Text('Waktu')),
            DataColumn(label: Text('Ruangan')),
            DataColumn(label: Text('Dosen Penguji')),
            DataColumn(label: Text('Status')),
          ],
          rows: _previewData.map((item) {
            bool hasErr = item['error'] != null;
            return DataRow(
              color: hasErr ? WidgetStateProperty.all(Colors.red.withOpacity(0.1)) : null,
              cells: [
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item['nama'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(item['nim'], style: const TextStyle(fontSize: 11, color: Colors.black54)),
                  ],
                )),
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item['tanggal'], style: const TextStyle(fontSize: 11)),
                    Text("${item['waktu_mulai']} - ${item['waktu_selesai']}", 
                         style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                )),
                DataCell(Text(item['ruangan'], style: const TextStyle(fontSize: 11))),
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("U: ${item['nama_penguji1']}", style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
                    Text("P: ${item['nama_penguji2']}", style: const TextStyle(fontSize: 10, color: Colors.black54), overflow: TextOverflow.ellipsis),
                  ],
                )),
                DataCell(hasErr 
                  ? Text(item['error'], style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10))
                  : const Icon(Icons.check_circle, color: Colors.green, size: 20)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity, height: 50,
      child: ElevatedButton(
        onPressed: _hasError ? null : _handleSave,
        style: ElevatedButton.styleFrom(backgroundColor: _hasError ? Colors.grey : const Color(0xFF4CAF50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: const Text("Simpan Jadwal ke Database", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
