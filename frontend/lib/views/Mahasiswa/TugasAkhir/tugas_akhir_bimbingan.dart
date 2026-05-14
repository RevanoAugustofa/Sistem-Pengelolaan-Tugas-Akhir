import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../../../controllers/mhs_controller.dart';
import '../../../models/jadwal_model.dart';
import '../../../models/logbook_model.dart';
import '../../../models/daftar_bimbingan_model.dart';
import '../../../helpers/constants.dart';

class TugasAkhirBimbinganMhsView extends StatelessWidget {
  const TugasAkhirBimbinganMhsView({super.key});

  @override
  Widget build(BuildContext context) {
    final MhsController controller = Get.put(MhsController());

    return RefreshIndicator(
      onRefresh: () async {
        controller.fetchJadwalBimbingan();
        controller.fetchLogbook();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Jadwal Bimbingan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Obx(() {
              // Menambahkan listLogbook.length agar Obx ini rebuild saat data logbook dimuat
              // ignore: unused_local_variable
              int logCount = controller.listLogbook.length;
              
              if (controller.isLoadingJadwalBimbingan.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Filter: Sembunyikan jadwal yang sudah lewat 24 jam
              final now = DateTime.now();
              final activeJadwal = controller.listJadwalBimbingan.where((jadwal) {
                if (jadwal.waktuTanggal == null) return true;
                try {
                  final scheduledTime = DateTime.parse(jadwal.waktuTanggal!);
                  final expirationTime = scheduledTime.add(const Duration(hours: 24));
                  return now.isBefore(expirationTime);
                } catch (e) {
                  return true; 
                }
              }).toList();

              if (activeJadwal.isEmpty) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Center(
                    child: Text(
                      "Belum ada jadwal bimbingan tersedia",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return Column(
                children: activeJadwal.map((jadwal) {
                  return _buildJadwalBimbinganCard(jadwal);
                }).toList(),
              );
            }),
            Obx(() {
              // Get all accepted registrations
              final acceptedRegs = <Map<String, dynamic>>[];
              for (var jadwal in controller.listJadwalBimbingan) {
                if (jadwal.pendaftaran != null) {
                  for (var p in jadwal.pendaftaran!) {
                    if (p.status?.toLowerCase() == 'diterima') {
                      acceptedRegs.add({
                        'pendaftaran': p,
                        'jadwal': jadwal,
                      });
                    }
                  }
                }
              }

              if (acceptedRegs.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    "Logbook Bimbingan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  
                  if (controller.isLoadingLogbook.value)
                    const Center(child: CircularProgressIndicator())
                  else
                    Column(
                      children: acceptedRegs.map((item) {
                        final DaftarBimbinganModel p = item['pendaftaran'];
                        final JadwalModel j = item['jadwal'];
                        
                        // Find matching logbook
                        LogbookBimbingan? log;
                        for (var l in controller.listLogbook) {
                          if (l.idDaftarBimbingan == p.id) {
                            log = l;
                            break;
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildLogbookItem(p, j, log),
                        );
                      }).toList(),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLogbookItem(DaftarBimbinganModel p, JadwalModel j, LogbookBimbingan? log) {
    String formattedDate = "";
    if (j.waktuTanggal != null) {
      try {
        DateTime dt = DateTime.parse(j.waktuTanggal!);
        formattedDate = DateFormat("EEEE dd, MMMM yyyy", 'id_ID').format(dt);
      } catch (e) {
        formattedDate = j.waktuTanggal!;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
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
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    j.dosen?.user?.name ?? "-",
                    style: const TextStyle(fontSize: 11, color: Colors.blue),
                  ),
                ],
              ),
              if (log != null && log.fileBimbingan != null)
                OutlinedButton(
                  onPressed: () {
                    final url = "${AppConstants.storageUrl}/${log!.fileBimbingan}";
                    Get.to(() => PdfPreviewPage(url: url, title: "File Bimbingan"));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  ),
                  child: const Text(
                    "lihat file",
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (log == null)
            Center(
              child: Column(
                children: [
                  const Text(
                    "Belum ada catatan bimbingan",
                    style: TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => _showTambahLogbookDialog(p.id!),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text("tambah catatan", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            )
          else ...[
            Text(
              log.permasalahan ?? "-",
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            if (log.rekomPembimbingUtama != null || log.rekomPembimbingPendamping != null) ...[
              const Divider(height: 24),
              const Text(
                "Rekomendasi Pembimbing:",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              if (log.rekomPembimbingUtama != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Utama: ${log.rekomPembimbingUtama}",
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ),
              if (log.rekomPembimbingPendamping != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Pendamping: ${log.rekomPembimbingPendamping}",
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ),
            ]
          ],
        ],
      ),
    );
  }

  Widget _buildJadwalBimbinganCard(JadwalModel jadwal) {
    final MhsController controller = Get.find<MhsController>();
    String formattedDate = "";
    if (jadwal.waktuTanggal != null) {
      try {
        DateTime dt = DateTime.parse(jadwal.waktuTanggal!);
        formattedDate = DateFormat("EEEE dd, MMMM yyyy  HH:mm 'WIB'", 'id_ID').format(dt);
      } catch (e) {
        formattedDate = jadwal.waktuTanggal!;
      }
    }

    bool isRegistered = jadwal.pendaftaran != null && jadwal.pendaftaran!.isNotEmpty;
    String status = isRegistered ? (jadwal.pendaftaran!.first.status ?? "Menunggu") : "Daftar";
    
    // Mencari data logbook yang sesuai dengan pendaftaran ini
    LogbookBimbingan? log;
    if (isRegistered) {
      final pId = jadwal.pendaftaran!.first.id;
      for (var l in controller.listLogbook) {
        if (l.idDaftarBimbingan == pId) {
          log = l;
          break;
        }
      }
    }

    return GestureDetector(
      onTap: () {
        if (isRegistered) {
          _showDetailPendaftaran(jadwal);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          jadwal.dosen?.user?.name ?? jadwal.dosen?.namaDosen ?? "Dosen Tidak Diketahui",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (log?.fileBimbingan != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                            onTap: () {
                              final url = "${AppConstants.storageUrl}/${log!.fileBimbingan}";
                              Get.to(() => PdfPreviewPage(url: url, title: "File Bimbingan"));
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.file_present, size: 14, color: Colors.blue),
                                SizedBox(width: 2),
                                Text(
                                  "lihat file",
                                  style: TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 11),
                  ),
                  Text(
                    "Kuota tersisa (${jadwal.kuota ?? 0})",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: isRegistered
                  ? null
                  : () {
                      _showDaftarConfirmation(jadwal);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isRegistered ? Colors.grey : const Color(0xFF42A5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                status.capitalizeFirst!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDaftarConfirmation(JadwalModel jadwal) {
    Get.dialog(
      AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin mendaftar bimbingan ini?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              final MhsController controller = Get.find<MhsController>();
              if (jadwal.id != null) {
                controller.daftarBimbingan(jadwal.id!);
              }
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  void _showDetailPendaftaran(JadwalModel jadwal) {
    String formattedDate = "";
    if (jadwal.waktuTanggal != null) {
      try {
        DateTime dt = DateTime.parse(jadwal.waktuTanggal!);
        formattedDate = DateFormat("EEEE dd, MMMM yyyy  HH:mm 'WIB'", 'id_ID').format(dt);
      } catch (e) {
        formattedDate = jadwal.waktuTanggal!;
      }
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Detail Pendaftaran Bimbingan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow("Dosen", jadwal.dosen?.user?.name ?? "-"),
            _buildDetailRow("Waktu", formattedDate),
            _buildDetailRow("Metode", jadwal.metodeBimbingan ?? "-"),
            _buildDetailRow(
              "Tempat/Link",
              jadwal.tempatLink ?? "-",
              showCopyButton: jadwal.metodeBimbingan?.toLowerCase() == "online" && jadwal.tempatLink != null,
              onCopy: () {
                Clipboard.setData(ClipboardData(text: jadwal.tempatLink!));
                Get.snackbar("Sukses", "Link berhasil disalin",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 1));
              },
            ),
            _buildDetailRow("Status", jadwal.pendaftaran?.first.status?.capitalizeFirst ?? "-"),
            const SizedBox(height: 20),
            _buildFullBlueButton("Tutup", onPressed: () => Get.back()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool showCopyButton = false, VoidCallback? onCopy}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(": "),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Text(value)),
                if (showCopyButton)
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16, color: Colors.blue),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onCopy,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTambahLogbookDialog(int idDaftarBimbingan) {
    final TextEditingController masalahController = TextEditingController();
    var fileName = "".obs;
    Uint8List? fileBytes;

    Get.dialog(
      AlertDialog(
        title: const Text("Isi Logbook Bimbingan"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: masalahController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Permasalahan / Progress",
                  border: OutlineInputBorder(),
                  hintText: "Tuliskan progress atau kendala bimbingan Anda...",
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => Row(
                children: [
                  Expanded(
                    child: Text(
                      fileName.value.isEmpty ? "Belum ada file dipilih" : fileName.value,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                        withData: true, // Tambahkan ini agar bytes tidak null
                      );
                      if (result != null) {
                        fileBytes = result.files.first.bytes;
                        fileName.value = result.files.first.name;
                      }
                    },
                  ),
                ],
              )),
              const Text(
                "*Hanya file PDF (max 2MB)",
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              if (masalahController.text.isEmpty) {
                Get.snackbar("Peringatan", "Permasalahan harus diisi",
                    backgroundColor: Colors.orange, colorText: Colors.white);
                return;
              }
              final MhsController controller = Get.find<MhsController>();
              controller.submitLogbook({
                'id_daftar_bimbingan': idDaftarBimbingan,
                'permasalahan': masalahController.text,
              }, fileBytes: fileBytes, fileName: fileName.value);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  Widget _buildBlueButton(String text, {VoidCallback? onPressed}) => ElevatedButton(
    onPressed: onPressed ?? () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4A89FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white)),
  );
  Widget _buildFullBlueButton(String text, {VoidCallback? onPressed}) =>
      SizedBox(width: double.infinity, child: _buildBlueButton(text, onPressed: onPressed));
}

class PdfPreviewPage extends StatelessWidget {
  final String url;
  final String title;
  const PdfPreviewPage({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            Text(url, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Launch URL
              },
              child: const Text("Buka di Browser"),
            ),
          ],
        ),
      ),
    );
  }
}
