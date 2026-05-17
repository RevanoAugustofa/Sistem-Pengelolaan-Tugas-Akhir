import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' hide Border;
import '../../../controllers/koorprodi_controller.dart';
import '../../../helpers/download_helper.dart';

class ImportDataDosenPage extends StatefulWidget {
  const ImportDataDosenPage({super.key});

  @override
  State<ImportDataDosenPage> createState() => _ImportDataDosenPageState();
}

class _ImportDataDosenPageState extends State<ImportDataDosenPage> with DownloadCooldownMixin {
  final KoorProdiController controller = Get.find<KoorProdiController>();
  String? _fileName;
  List<Map<String, dynamic>> _previewData = [];
  bool _isLoading = false;
  bool _hasError = false;

  // Fungsi untuk mengunduh template
  Future<void> _downloadTemplate() async {
    if (isCooldown) {
      showCooldownMessage();
      return;
    }

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Header Template
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value = TextCellValue("Nama Dosen");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value = TextCellValue("NIP");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value = TextCellValue("Email");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value = TextCellValue("Password");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value = TextCellValue("Tgl Lahir (YYYY-MM-DD)");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value = TextCellValue("Jenis Kelamin");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0)).value = TextCellValue("Alamat");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0)).value = TextCellValue("Jabatan");

    // Contoh Data
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value = TextCellValue("Contoh Dosen, S.T., M.T.");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1)).value = TextCellValue("199001012020011001");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1)).value = TextCellValue("dosen@example.com");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1)).value = TextCellValue("123456");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1)).value = TextCellValue("1990-01-01");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 1)).value = TextCellValue("Laki-laki");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1)).value = TextCellValue("Jl. Kampus No. 1");
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1)).value = TextCellValue("Lektor");

    var fileBytes = excel.save();
    
    String? outputFile = await FilePicker.saveFile(
      dialogTitle: 'Simpan Template Dosen',
      fileName: 'template_import_dosen.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      bytes: Uint8List.fromList(fileBytes!),
    );

    if (outputFile != null) {
      Get.snackbar("Sukses", "Template berhasil diunduh", backgroundColor: Colors.green, colorText: Colors.white);
      startCooldown();
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
          _hasError = false;
        });
        if (file.bytes != null) _processExcel(file.bytes!);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memilih file: $e");
    }
  }

  Future<void> _processExcel(Uint8List bytes) async {
    setState(() => _isLoading = true);
    try {
      var excel = Excel.decodeBytes(bytes);
      List<Map<String, dynamic>> tempItems = [];
      
      for (var table in excel.tables.keys) {
        var rows = excel.tables[table]?.rows;
        if (rows == null || rows.length <= 1) continue;

        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];
          if (row.isEmpty || row.length < 2) continue;

          String nama = row[0]?.value?.toString() ?? "";
          String nip = row[1]?.value?.toString() ?? "";
          String email = (row.length > 2) ? row[2]?.value?.toString() ?? "" : "";
          String password = (row.length > 3) ? row[3]?.value?.toString() ?? "123456" : "123456";
          String tglLahir = (row.length > 4) ? row[4]?.value?.toString() ?? "" : "";
          String jk = (row.length > 5) ? row[5]?.value?.toString() ?? "" : "";
          String alamat = (row.length > 6) ? row[6]?.value?.toString() ?? "" : "";
          String jabatan = (row.length > 7) ? row[7]?.value?.toString() ?? "" : "";

          if (nama.trim().isEmpty || nip.trim().isEmpty) continue;

          bool isDuplicateInDB = controller.listDosenManajemen.any((dsn) => dsn.nip == nip);
          bool isDuplicateInFile = tempItems.any((item) => item['nip'] == nip);
          
          String? errorMsg;
          if (isDuplicateInDB) errorMsg = "NIP sudah terdaftar";
          else if (isDuplicateInFile) errorMsg = "Duplikat di file";
          else if (email.isEmpty) errorMsg = "Email kosong";
          else if (tglLahir.isEmpty) errorMsg = "Tgl Lahir kosong";

          tempItems.add({
            'nama_dosen': nama,
            'nip': nip,
            'email': email,
            'password': password,
            'tgl_lahir': tglLahir,
            'jenis_kelamin': jk,
            'alamat': alamat,
            'jabatan': jabatan,
            'is_error': errorMsg != null,
            'error_msg': errorMsg,
          });
          if (errorMsg != null) _hasError = true;
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
      Get.snackbar("Peringatan", "Mohon perbaiki data yang error terlebih dahulu", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    setState(() => _isLoading = true);
    int successCount = 0;
    for (var item in _previewData) {
      try {
        await controller.addDosen(item);
        successCount++;
      } catch (e) {}
    }
    setState(() => _isLoading = false);
    Get.snackbar("Selesai", "Berhasil simpan $successCount data.");
    controller.fetchDosenManajemen();
    if (successCount > 0) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), 
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        title: const Text("Import Dosen", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30), onPressed: () => Get.back()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.shade200)),
              child: Row(
                children: [
                  const Icon(Icons.description, color: Colors.blue, size: 30),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Gunakan Template", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text("Unduh template agar format data sesuai. Pastikan format NIP dan Email benar.", style: TextStyle(fontSize: 13, color: Colors.black54)),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _downloadTemplate,
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text("Unduh Template (.xlsx)"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, elevation: 0),
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
              _buildPreviewHeader(),
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

  Widget _buildPreviewHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Pratinjau (${_previewData.length} data)", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (_hasError) const Text("Ada Masalah Data!", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      ],
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
            DataColumn(label: Text('Nama')),
            DataColumn(label: Text('NIP')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Jabatan')),
            DataColumn(label: Text('Status')),
          ],
          rows: _previewData.map((item) {
            bool isErr = item['is_error'];
            return DataRow(
              color: isErr ? WidgetStateProperty.all(Colors.red.withOpacity(0.1)) : null,
              cells: [
                DataCell(Text(item['nama_dosen'])),
                DataCell(Text(item['nip'])),
                DataCell(Text(item['email'])),
                DataCell(Text(item['jabatan'])),
                DataCell(isErr ? Text(item['error_msg'], style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)) : const Icon(Icons.check_circle, color: Colors.green)),
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
        child: const Text("Simpan Data ke Database", style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
