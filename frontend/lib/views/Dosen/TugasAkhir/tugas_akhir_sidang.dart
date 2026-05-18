import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/dosen_controller.dart';
import '../../../models/mahasiswa_model.dart';
import '../../../helpers/constants.dart';
import 'pdf_preview_page.dart';

class TugasAkhirSidangTable extends StatefulWidget {
  final String searchQuery;
  const TugasAkhirSidangTable({super.key, required this.searchQuery});

  @override
  State<TugasAkhirSidangTable> createState() => _TugasAkhirSidangTableState();
}

class _TugasAkhirSidangTableState extends State<TugasAkhirSidangTable> {
  final DosenController controller = Get.find<DosenController>();
  late Mahasiswa mahasiswa;
  final TextEditingController nilaiController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();
  Worker? _worker;

  @override
  void initState() {
    super.initState();
    mahasiswa = Get.arguments as Mahasiswa;
    // Data sudah di-fetch oleh parent saat cek akses
    
    _worker = ever(controller.currentGrade, (String grade) {
      if (grade.isNotEmpty) {
        nilaiController.text = grade;
      }
    });
  }

  @override
  void dispose() {
    _worker?.dispose();
    nilaiController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingSidang.value) {
        return const Center(child: CircularProgressIndicator());
      }

      var jadwal = controller.jadwalSidangTA;
      if (jadwal.isEmpty) {
        return const Center(child: Text("Belum ada jadwal sidang TA"));
      }

      String formattedDate = "-";
      if (jadwal['tanggal'] != null) {
        try {
          DateTime dt = DateTime.parse(jadwal['tanggal']);
          formattedDate = DateFormat("EEEE, dd MMMM yyyy", 'id_ID').format(dt);
        } catch (e) {
          formattedDate = jadwal['tanggal'];
        }
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoMahasiswa(),
            const SizedBox(height: 20),
            // 1. CARD JADWAL Sidang TA
            _buildJadwalCard(jadwal, formattedDate),
            
            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 20),

            // 2. BAGIAN PENILAIAN Sidang TA
            const Text(
              "Penilaian Sidang TA",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 16),

            // Tombol Lihat File TA
            _buildDashedButton("lihat file TA", jadwal['mahasiswa']?['daftar_sidangta']?['file_tugas_akhir']),
            
            const SizedBox(height: 20),

            // Input Field: Nilai Sidang TA
            const Text(
              "Nilai Sidang TA",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildTextField(nilaiController, "Masukkan nilai", keyboardType: TextInputType.number),

            const SizedBox(height: 20),

            // Input Field: Catatan Revisi
            const Text(
              "Catatan Revisi",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildTextField(catatanController, "Masukkan Catatan Revisi", maxLines: 5),

            const SizedBox(height: 30),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (nilaiController.text.isEmpty) {
                    Get.snackbar("Error", "Nilai tidak boleh kosong", backgroundColor: Colors.red, colorText: Colors.white);
                    return;
                  }
                  
                  controller.submitHasilSidang({
                    'id_jadwal_sidangTA': jadwal['id'],
                    'nilai': nilaiController.text,
                    'catatan': catatanController.text,
                    'id_mahasiswa_temp': mahasiswa.id, // For refreshing
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "SIMPAN",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildJadwalCard(Map<dynamic, dynamic> jadwal, String formattedDate) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF0056A8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              "Jadwal Sidang TA",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C7A89),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "${jadwal['waktu_mulai'] ?? '-'} - ${jadwal['waktu_selesai'] ?? '-'} WIB",
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        jadwal['ruangan']?['nama_ruangan'] ?? "Ruangan TBD",
                        style: const TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPengujiInfo("Penguji 1", jadwal['penguji_utama']?['nama_dosen'] ?? "-"),
                      const SizedBox(height: 12),
                      _buildPengujiInfo("Penguji 2", jadwal['penguji_pendamping']?['nama_dosen'] ?? "-"),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoMahasiswa() {
    return Column(
      children: [
        _buildDetailRow("NPM", mahasiswa.npm ?? "-"),
        const SizedBox(height: 10),
        _buildDetailRow("Nama", mahasiswa.namaMahasiswa ?? "-"),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child:
                  Text("Judul TA", style: TextStyle(color: Colors.grey.shade800)),
            ),
            Expanded(
              child: Text(
                mahasiswa.proposal?.judulProposal ?? "Belum ada judul",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: TextStyle(color: Colors.grey.shade800)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildPengujiInfo(String label, String nama) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF0056A8), fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          nama,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildDashedButton(String text, String? filePath) {
    return InkWell(
      onTap: () {
        if (filePath != null) {
          final baseUrl = AppConstants.baseUrl.replaceAll('/api', '');
          final fullUrl = "$baseUrl/storage/$filePath";
          Get.to(() => PdfPreviewPage(url: fullUrl, title: "Preview Tugas Akhir"));
        } else {
          Get.snackbar("Peringatan", "File tidak tersedia", 
            backgroundColor: Colors.orange, colorText: Colors.white);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid), 
        ),
        child: Text(
          filePath != null ? "Lihat File Tugas Akhir" : "File tidak tersedia",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
