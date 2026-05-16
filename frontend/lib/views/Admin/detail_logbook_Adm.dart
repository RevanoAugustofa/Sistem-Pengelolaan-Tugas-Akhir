import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/mahasiswa_model.dart';
import '../../../models/logbook_model.dart';
import '../../../helpers/constants.dart';
import '../Profile/profile_page.dart'; // For PdfPreviewPage if available or internal

class DetailLogbookAdminPage extends StatefulWidget {
  final Mahasiswa mahasiswa;
  const DetailLogbookAdminPage({super.key, required this.mahasiswa});

  @override
  State<DetailLogbookAdminPage> createState() => _DetailLogbookAdminPageState();
}

class _DetailLogbookAdminPageState extends State<DetailLogbookAdminPage> {
  final AdminController controller = Get.find<AdminController>();

  @override
  void initState() {
    super.initState();
    if (widget.mahasiswa.id != null) {
      controller.fetchLogbookMahasiswa(widget.mahasiswa.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Detail Logbook",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (widget.mahasiswa.id != null) {
            controller.fetchLogbookMahasiswa(widget.mahasiswa.id!);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Mahasiswa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mahasiswa.namaMahasiswa ?? "-",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3475)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "NPM: ${widget.mahasiswa.npm ?? '-'}",
                      style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.school_outlined, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(widget.mahasiswa.prodi ?? "-", style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Riwayat Logbook Bimbingan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.isLoadingLogbook.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.listLogbook.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Center(
                      child: Text("Belum ada logbook yang diisi", style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.listLogbook.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final log = controller.listLogbook[index];
                    return _buildLogbookCard(log);
                  },
                );
              }),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogbookCard(LogbookBimbingan log) {
    String formattedDate = "-";
    String dosenName = log.daftarBimbingan?.jadwalBimbingan?.dosen?.namaDosen ?? "-";
    
    if (log.daftarBimbingan?.jadwalBimbingan?.waktuTanggal != null) {
      try {
        DateTime dt = DateTime.parse(log.daftarBimbingan!.jadwalBimbingan!.waktuTanggal!);
        formattedDate = DateFormat("EEEE dd, MMMM yyyy", 'id_ID').format(dt);
      } catch (e) {
        formattedDate = log.daftarBimbingan!.jadwalBimbingan!.waktuTanggal!;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dosenName,
                    style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              if (log.fileBimbingan != null)
                TextButton.icon(
                  onPressed: () {
                    final url = "${AppConstants.storageUrl}/${log.fileBimbingan}";
                    Get.to(() => PdfPreviewPage(url: url, title: "File Bimbingan"));
                  },
                  icon: const Icon(Icons.file_present, size: 16, color: Colors.blue),
                  label: const Text("Lihat File", style: TextStyle(fontSize: 12, color: Colors.blue)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
              else
                const Text("No File", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const Divider(height: 24),
          const Text(
            "Permasalahan / Progress:",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          Text(
            (log.permasalahan == null || log.permasalahan!.isEmpty || log.permasalahan == "-")
                ? "Tidak ada rincian"
                : log.permasalahan!,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: (log.permasalahan == null || log.permasalahan!.isEmpty || log.permasalahan == "-")
                  ? Colors.grey
                  : Colors.black87,
              fontStyle: (log.permasalahan == null || log.permasalahan!.isEmpty || log.permasalahan == "-")
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
          if (log.rekomPembimbingUtama != null || log.rekomPembimbingPendamping != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rekomendasi Dosen:",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E3475)),
                  ),
                  if (log.rekomPembimbingUtama != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 12, color: Colors.orange),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "Utama: ${log.rekomPembimbingUtama}",
                              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (log.rekomPembimbingPendamping != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.star_border, size: 12, color: Colors.orange),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "Pendamping: ${log.rekomPembimbingPendamping}",
                              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Simple PdfPreview internal or use existing if any
class PdfPreviewPage extends StatelessWidget {
  final String url;
  final String title;
  const PdfPreviewPage({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color.fromARGB(255, 0, 149, 255),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(url, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Implement URL launcher if needed
                Get.snackbar("Info", "Membuka browser...");
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Buka di Browser", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
