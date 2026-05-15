import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../controllers/mhs_controller.dart';

class FormDaftarSidangView extends StatefulWidget {
  const FormDaftarSidangView({super.key});

  @override
  State<FormDaftarSidangView> createState() => _FormDaftarSidangViewState();
}

class _FormDaftarSidangViewState extends State<FormDaftarSidangView> {
  final MhsController controller = Get.find<MhsController>();

  // Map to store file data
  final Map<String, Uint8List?> _fileBytes = {
    'tugas_akhir': null,
    'bebas_pinjaman': null,
    'slip_pembayaran': null,
    'transkip': null,
    'pembayaran_sidang': null,
  };

  final Map<String, String?> _fileNames = {
    'tugas_akhir': null,
    'bebas_pinjaman': null,
    'slip_pembayaran': null,
    'transkip': null,
    'pembayaran_sidang': null,
  };

  Future<void> _pickFile(String key) async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _fileBytes[key] = result.files.first.bytes;
          _fileNames[key] = result.files.first.name;
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memilih file: $e");
    }
  }

  Widget _buildFilePicker(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF283D70),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickFile(key),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.upload_file,
                  color: _fileNames[key] != null ? const Color(0xFF4A89FF) : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _fileNames[key] ?? "Pilih file PDF",
                    style: TextStyle(
                      color: _fileNames[key] != null ? Colors.black87 : Colors.grey,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_fileNames[key] != null)
                  const Icon(Icons.check_circle, color: Color(0xFF4A89FF), size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Form Daftar Sidang TA",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Color.fromARGB(255, 0, 149, 255),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lengkapi dokumen persyaratan berikut untuk mendaftar sidang Tugas Akhir.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildFilePicker("File Tugas Akhir (PDF)", "tugas_akhir"),
            _buildFilePicker("File Bebas Pinjaman Administrasi (PDF)", "bebas_pinjaman"),
            _buildFilePicker("File Slip Pembayaran Semester Akhir (PDF)", "slip_pembayaran"),
            _buildFilePicker("File Transkip Sementara (PDF)", "transkip"),
            _buildFilePicker("File Bukti Pembayaran Sidang TA (PDF)", "pembayaran_sidang"),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoadingAction.value
                    ? null
                    : () {
                        // Check if all files are selected
                        if (_fileBytes.values.any((element) => element == null)) {
                          Get.snackbar(
                            "Peringatan",
                            "Mohon lengkapi semua dokumen persyaratan",
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        
                        // Prepare data for submission
                        controller.daftarSidang(
                          fileBytes: _fileBytes,
                          fileNames: _fileNames,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A89FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: controller.isLoadingAction.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        "SUBMIT PENDAFTARAN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
