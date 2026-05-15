import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/dosen_controller.dart';
import '../../../models/mahasiswa_model.dart';
import 'package:intl/intl.dart';
import '../../../helpers/constants.dart';
import 'pdf_preview_page.dart';
import '../../Pdf/form_catatan_revisi_proposal.dart';

class TugasAkhirProposalTable extends StatefulWidget {
  final String searchQuery;
  const TugasAkhirProposalTable({super.key, required this.searchQuery});

  @override
  State<TugasAkhirProposalTable> createState() => _TugasAkhirProposalTableState();
}

class _TugasAkhirProposalTableState extends State<TugasAkhirProposalTable> {
  final DosenController controller = Get.find<DosenController>();
  final TextEditingController nilaiController = TextEditingController();
  late Mahasiswa mahasiswa;
  Worker? _worker;

  @override
  void initState() {
    super.initState();
    mahasiswa = Get.arguments as Mahasiswa;
    controller.fetchJadwalSempro(mahasiswa.id!);
    
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingSempro.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.jadwalSempro.isEmpty) {
        return const Center(child: Text("Jadwal seminar proposal belum tersedia"));
      }

      final jadwal = controller.jadwalSempro;
      final isPenguji = controller.isPengujiSempro.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildJadwalCard(jadwal),
            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              "Penilaian Seminar Proposal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 16),
            _buildDashedButton("Lihat File Proposal", jadwal['mahasiswa']?['proposal']?['file_proposal']),
            const SizedBox(height: 12),
            if (isPenguji)
              _buildCatatanRevisiButton(jadwal),
            const SizedBox(height: 20),
            const Text(
              "Nilai Seminar Proposal",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              nilaiController,
              isPenguji ? "Masukkan nilai" : "Hanya Penguji yang dapat memberi nilai",
              enabled: isPenguji,
            ),
            const SizedBox(height: 30),
            if (isPenguji)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (nilaiController.text.isEmpty) {
                      Get.snackbar("Peringatan", "Nilai tidak boleh kosong");
                      return;
                    }
                    controller.submitHasilSempro({
                      'id_jadwal_sempro': jadwal['id'],
                      'id_proposal': jadwal['mahasiswa']['proposal']['id'],
                      'nilai': nilaiController.text,
                      'id_mahasiswa_temp': mahasiswa.id, // For refresh
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

  Widget _buildJadwalCard(Map<dynamic, dynamic> jadwal) {
    String formattedDate = "-";
    if (jadwal['tanggal'] != null) {
      DateTime date = DateTime.parse(jadwal['tanggal']);
      formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    }

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
              "Jadwal Seminar Proposal",
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
                          "${jadwal['waktu_mulai'] ?? '00:00'} - ${jadwal['waktu_selesai'] ?? '00:00'} WIB",
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        jadwal['ruangan']?['nama_ruangan'] ?? "-",
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
                      _buildPengujiInfo("Penguji Utama", jadwal['penguji_utama']?['nama_dosen'] ?? "-"),
                      const SizedBox(height: 12),
                      _buildPengujiInfo("Penguji Pendamping", jadwal['penguji_pendamping']?['nama_dosen'] ?? "-"),
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
          Get.to(() => PdfPreviewPage(url: fullUrl, title: "Preview Proposal"));
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
          filePath != null ? "Lihat File Proposal" : "File tidak tersedia",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildCatatanRevisiButton(Map<dynamic, dynamic> jadwal) {
    String formattedDate = "-";
    if (jadwal['tanggal'] != null) {
      DateTime date = DateTime.parse(jadwal['tanggal']);
      formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(date);
    }

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {
          Get.to(() => FormCatatanRevisiView(
                idMahasiswa: mahasiswa.id!,
                dataJadwal: {
                  'id_jadwal_sempro': jadwal['id'],
                  'nama_mahasiswa': jadwal['mahasiswa']?['nama_mahasiswa'],
                  'npm': jadwal['mahasiswa']?['nim'],
                  'judul_proposal': jadwal['mahasiswa']?['proposal']?['judul_proposal'],
                  'tanggal': formattedDate,
                  'waktu': "${jadwal['waktu_mulai'] ?? '00:00'} - ${jadwal['waktu_selesai'] ?? '00:00'} WIB",
                  'ruangan': jadwal['ruangan']?['nama_ruangan'] ?? "-",
                  'nama_penguji': (jadwal['id_penguji_utama'] == controller.idDosenLoggedIn.value)
                      ? (jadwal['penguji_utama']?['nama_dosen'] ?? "-")
                      : (jadwal['penguji_pendamping']?['nama_dosen'] ?? "-"),
                  'jabatan_penguji': (jadwal['id_penguji_utama'] == controller.idDosenLoggedIn.value)
                      ? "Ketua"
                      : "Anggota",
                  'nidn_penguji': (jadwal['id_penguji_utama'] == controller.idDosenLoggedIn.value)
                      ? (jadwal['penguji_utama']?['nidn'] ?? "-")
                      : (jadwal['penguji_pendamping']?['nidn'] ?? "-"),
                },
              ));
        },
        icon: const Icon(Icons.edit_note, color: Color(0xFF4A89FF)),
        label: const Text(
          "Catatan Revisi Proposal",
          style: TextStyle(color: Color(0xFF4A89FF), fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF4A89FF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {int maxLines = 1, bool enabled = true}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: !enabled,
        fillColor: enabled ? Colors.transparent : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
