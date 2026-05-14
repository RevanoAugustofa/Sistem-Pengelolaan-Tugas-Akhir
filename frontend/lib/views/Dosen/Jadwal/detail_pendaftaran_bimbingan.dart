import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controllers/dosen_controller.dart';
import '../../../models/jadwal_model.dart';
import '../../../models/daftar_bimbingan_model.dart';

class DetailPendaftaranBimbinganView extends StatelessWidget {
  const DetailPendaftaranBimbinganView({super.key});

  @override
  Widget build(BuildContext context) {
    final DosenController controller = Get.find<DosenController>();
    final JadwalModel jadwal = Get.arguments as JadwalModel;

    // Fetch pendaftaran when view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (jadwal.id != null) {
        controller.fetchPendaftaranBimbingan(jadwal.id!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pendaftaran Bimbingan"),
        backgroundColor: const Color(0xFF1E3475),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoadingPendaftaran.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(jadwal),
              const SizedBox(height: 24),
              const Text(
                "Daftar Mahasiswa Mendaftar",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (controller.listPendaftaranBimbingan.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Belum ada mahasiswa yang mendaftar"),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.listPendaftaranBimbingan.length,
                  itemBuilder: (context, index) {
                    final pendaftaran = controller.listPendaftaranBimbingan[index];
                    return _buildMahasiswaCard(pendaftaran, controller, jadwal.id!);
                  },
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(JadwalModel jadwal) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow("Metode", jadwal.metodeBimbingan?.toUpperCase() ?? "-"),
            const Divider(),
            _buildInfoRow(
              "Tempat/Link", 
              jadwal.tempatLink ?? "-", 
              isLink: jadwal.metodeBimbingan?.toLowerCase() == 'online'
            ),
            const Divider(),
            _buildInfoRow("Kuota", jadwal.kuota.toString()),
            const Divider(),
            _buildInfoRow("Waktu", jadwal.waktuTanggal ?? "-"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Row(
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
              if (isLink && value != "-")
                IconButton(
                  icon: const Icon(Icons.copy, size: 16, color: Colors.blue),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    Get.snackbar(
                      "Copied",
                      "Link berhasil disalin",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 1),
                      margin: const EdgeInsets.all(10),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMahasiswaCard(DaftarBimbinganModel pendaftaran, DosenController controller, int idJadwal) {
    Color statusColor = Colors.grey;
    if (pendaftaran.status == 'diterima') statusColor = Colors.green;
    if (pendaftaran.status == 'ditolak') statusColor = Colors.red;
    if (pendaftaran.status == 'menunggu') statusColor = Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF1E3475),
              child: Text(
                pendaftaran.mahasiswa?.namaMahasiswa?.substring(0, 1).toUpperCase() ?? "M",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pendaftaran.mahasiswa?.namaMahasiswa ?? "Unknown",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    pendaftaran.mahasiswa?.npm ?? "-",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      pendaftaran.status?.toUpperCase() ?? "MENUNGGU",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ),
                ],
              ),
            ),
            if (pendaftaran.status == 'menunggu')
              Row(
                children: [
                  IconButton(
                    onPressed: () => controller.updateStatusPendaftaran(pendaftaran.id!, idJadwal, 'diterima'),
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    tooltip: "Terima",
                  ),
                  IconButton(
                    onPressed: () => controller.updateStatusPendaftaran(pendaftaran.id!, idJadwal, 'ditolak'),
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    tooltip: "Tolak",
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
