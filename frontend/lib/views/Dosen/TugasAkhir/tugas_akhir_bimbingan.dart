import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/dosen_controller.dart';
import '../../../models/mahasiswa_model.dart';

class TugasAkhirBimbinganTable extends StatefulWidget {
  final String searchQuery;
  const TugasAkhirBimbinganTable({super.key, required this.searchQuery});

  @override
  State<TugasAkhirBimbinganTable> createState() => _TugasAkhirBimbinganTableState();
}

class _TugasAkhirBimbinganTableState extends State<TugasAkhirBimbinganTable> {
  final DosenController controller = Get.find<DosenController>();
  late Mahasiswa mahasiswa;

  @override
  void initState() {
    super.initState();
    mahasiswa = Get.arguments as Mahasiswa;
    controller.fetchLogbook(mahasiswa.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingLogbook.value) {
        return const Center(child: CircularProgressIndicator());
      }

      int jumlahLogbook = controller.listLogbook.length;

      return RefreshIndicator(
        onRefresh: () async {
          controller.fetchLogbook(mahasiswa.id!);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Logbook",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              if (controller.listLogbook.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Belum ada data logbook"),
                  ),
                )
              else
                ...controller.listLogbook.map((log) {
                  String formattedDate = "-";
                  if (log.daftarBimbingan?.jadwalBimbingan?.waktuTanggal != null) {
                    try {
                      DateTime dt = DateTime.parse(log.daftarBimbingan!.jadwalBimbingan!.waktuTanggal!);
                      formattedDate = DateFormat("dd MMMM yyyy", 'id_ID').format(dt);
                    } catch (e) {
                      formattedDate = log.daftarBimbingan!.jadwalBimbingan!.waktuTanggal!;
                    }
                  } else if (log.createdAt != null) {
                    try {
                      DateTime dt = DateTime.parse(log.createdAt!);
                      formattedDate = DateFormat("dd MMMM yyyy", 'id_ID').format(dt);
                    } catch (e) {
                      formattedDate = log.createdAt!;
                    }
                  }

                  return Column(
                    children: [
                      _buildLogbookCard(
                        idLog: log.id!,
                        tanggal: formattedDate,
                        catatanMahasiswa: log.permasalahan,
                        rekomUtama: log.rekomPembimbingUtama,
                        rekomPendamping: log.rekomPembimbingPendamping,
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),

              const SizedBox(height: 14),

              // --- Tombol Rekomendasikan Sidang (Kondisional) ---
              if (jumlahLogbook >= 5)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Logika untuk merekomendasikan sidang
                      Get.snackbar(
                        "Info",
                        "Merekomendasikan sidang TA...",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF2196F3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Rekomendasikan Sidang TA",
                      style: TextStyle(
                        color: Color(0xFF2196F3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  // --- WIDGET HELPER: Card Logbook ---
  Widget _buildLogbookCard({
    required int idLog,
    required String tanggal,
    String? catatanMahasiswa,
    String? rekomUtama,
    String? rekomPendamping,
  }) {
    String? catatanDosen = (mahasiswa.role_pembimbing == "Utama") ? rekomUtama : rekomPendamping;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tanggal,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Logika lihat file
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A89F3),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      "Lihat File",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Permasalahan Mahasiswa:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  catatanMahasiswa ?? "Tidak ada catatan permasalahan.",
                  style: const TextStyle(fontSize: 13),
                ),
                const Divider(height: 24),
                const Text(
                  "Rekomendasi Dosen:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 4),
                _buildLogbookContent(idLog, catatanDosen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogbookContent(int idLog, String? catatan) {
    if (catatan == null || catatan.isEmpty) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: () => _showAddCatatanDialog(idLog),
          icon: const Icon(Icons.add, size: 16, color: Colors.white),
          label: const Text("Tambah Catatan"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6CBE71),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              catatan,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade800,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
            onPressed: () => _showAddCatatanDialog(idLog, existingCatatan: catatan),
          ),
        ],
      );
    }
  }

  void _showAddCatatanDialog(int idLog, {String? existingCatatan}) {
    final TextEditingController catatanController = TextEditingController(text: existingCatatan);
    
    Get.dialog(
      AlertDialog(
        title: Text(existingCatatan == null ? "Tambah Catatan" : "Edit Catatan"),
        content: TextField(
          controller: catatanController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Masukkan rekomendasi pembimbing...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (catatanController.text.isNotEmpty) {
                controller.updateLogbook(
                  idLog, 
                  mahasiswa.id!, 
                  {"rekom_pembimbing": catatanController.text}
                );
                Get.back();
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
