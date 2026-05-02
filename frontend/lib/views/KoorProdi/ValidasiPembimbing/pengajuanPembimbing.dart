import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/koorprodi_controller.dart';
import '../../../models/pengajuan_pembimbing_model.dart';
import 'components/filter_pengajuan.dart';

class PengajuanPembimbing extends StatefulWidget {
  const PengajuanPembimbing({super.key});

  @override
  State<PengajuanPembimbing> createState() => _VPengajuanPembimbingState();
}

class _VPengajuanPembimbingState extends State<PengajuanPembimbing> {
  final KoorProdiController controller = Get.put(KoorProdiController());
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _showFilter() {
    Get.bottomSheet(
      const FilterPengajuan(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _toggleSelection(int id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedIds.clear();
    });
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
          "Validasi Pembimbing",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.listPengajuan.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refreshData(),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Search Bar
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      controller.updateSearch(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Cari Mahasiswa",
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.blue),
                        onPressed: _showFilter,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // --- Bulk Action Bar or Filter/Export Bar ---
                if (selectedIds.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "${selectedIds.length} Terpilih",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            var pendingIds = controller.listPengajuan
                                .where((p) => p.status == "diajukan")
                                .map((p) => p.id!)
                                .toList();
                            setState(() {
                              selectedIds.addAll(pendingIds);
                            });
                          },
                          icon: const Icon(Icons.select_all, size: 18),
                          label: const Text("Semua", style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                        ),
                        const SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: () => _showBulkValidationDialog(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(0, 32),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text("Setujui", style: TextStyle(fontSize: 12)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                          onPressed: _clearSelection,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.only(left: 8),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Filter - ${controller.searchQuery.isEmpty ? 'All' : 'Hasil Pencarian'}",
                            style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          if (controller.selectedDosen.isNotEmpty || 
                              controller.selectedTahunAjar.isNotEmpty || 
                              controller.selectedStatus.isNotEmpty)
                            const Text(
                              "Advanced Filter Aktif",
                              style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Get.snackbar("Info", "Fitur Eksport sedang disiapkan",
                              backgroundColor: Colors.blue.withOpacity(0.8), colorText: Colors.white);
                        },
                        icon: const Icon(Icons.download, size: 18, color: Colors.green),
                        label: const Text(
                          "Eksport Data",
                          style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          backgroundColor: Colors.green.shade50,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                
                const SizedBox(height: 10),

                if (controller.listPengajuan.isEmpty)
                  const Center(child: Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text("Tidak ada data pengajuan"),
                  )),

                // --- List Card Mahasiswa ---
                ...controller.listPengajuan.map((p) => _buildStudentCard(p)).toList(),

                // Loading indicator for more data
                if (controller.isMoreLoading.value)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- WIDGET HELPER: Card Mahasiswa ---
  Widget _buildStudentCard(PengajuanPembimbingModel pengajuan) {
    bool isSelected = selectedIds.contains(pengajuan.id);
    String statusStr = pengajuan.status ?? "diajukan";
    String displayStatus;
    if (statusStr == "diajukan") {
      displayStatus = "Menunggu";
    } else {
      displayStatus = "disetujui";
    }

    Color badgeColor;
    Color textColor;
    BoxBorder? badgeBorder;

    if (statusStr == "diajukan") {
      badgeColor = const Color.fromARGB(255, 255, 255, 255);
      badgeBorder = Border.all(color: Colors.green);
      textColor = const Color(0xFF12B76A);
    } else {
      badgeBorder = Border.all(color: Color.fromARGB(255, 76, 162, 238));
      badgeColor = const Color.fromARGB(255, 255, 255, 255);
      textColor = const Color.fromARGB(255, 50, 142, 248);
    }

    return GestureDetector(
      onLongPress: () {
        if (statusStr == "diajukan") {
          _toggleSelection(pengajuan.id!);
        }
      },
      onTap: () {
        if (selectedIds.isNotEmpty) {
          if (statusStr == "diajukan") {
            _toggleSelection(pengajuan.id!);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (selectedIds.isNotEmpty && statusStr == "diajukan")
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                      color: Colors.blue,
                    ),
                  ),
                // Info Mahasiswa (Kiri)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pengajuan.mahasiswa?.namaMahasiswa ?? "-",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${pengajuan.mahasiswa?.npm ?? "-"}",
                        style: const TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Badge & Tombol (Kanan)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(4),
                        border: badgeBorder,
                      ),
                      child: Text(
                        displayStatus,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    if (statusStr == "diajukan" && selectedIds.isEmpty)
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () => _showValidationDialog(pengajuan),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4FA5FF),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            "validasi",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Pembimbing 1", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text(pengajuan.pembimbingUtama?.namaDosen ?? "-",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Pembimbing 2", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text(pengajuan.pembimbingPendamping?.namaDosen ?? "-",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showBulkValidationDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Validasi Massal",
                style: TextStyle(
                  color: Color(0xFF0D47A1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Apakah Anda yakin ingin menyetujui ${selectedIds.length} pengajuan pembimbing yang dipilih?",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text("BATAL"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3399FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        controller.validasiMassal(selectedIds.toList(), "disetujui");
                        _clearSelection();
                        Get.back();
                      },
                      child: const Text("SETUJU", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showValidationDialog(PengajuanPembimbingModel pengajuan) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent, // Mencegah warna berubah di Material 3
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Verivikasi",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF0D47A1), // Warna biru gelap
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, color: Colors.black, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Info Mahasiswa ---
              Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FixedColumnWidth(14), // Jarak untuk titik dua
                  2: FlexColumnWidth(),
                },
                children: [
                  _buildTableRow("Nama ", pengajuan.mahasiswa?.namaMahasiswa ?? "-"),
                  // Sesuaikan pemanggilan variabel 'npm' dan 'judul' dengan model Anda
                  _buildTableRow("NPM", pengajuan.mahasiswa?.npm ?? "-"), 
                  _buildTableRow("Judul TA ", pengajuan.judulTa ?? "-"),
                ],
              ),
              const SizedBox(height: 16),

              // --- Card Info Pembimbing ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pembimbing Utama",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    _buildDosenChip(pengajuan.pembimbingUtama?.namaDosen ?? "Fajar Mahardika"),
                    
                    const SizedBox(height: 16),
                    
                    const Text(
                      "Pembimbing Pendamping",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    _buildDosenChip(pengajuan.pembimbingPendamping?.namaDosen ?? "Cahya Vikasari"),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Teks Konfirmasi ---
              const Text(
                "Apakah ingin menerima atau memilih ulang \ndosen pembimbing untuk  mahasiswa ini ?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 24),

              // --- Action Buttons ---
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3399FF), // Biru
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: Colors.blueGrey, width: 0.5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        // Logika bawaan tidak dirubah
                        controller.validasi(pengajuan.id!, "disetujui");
                        Get.back();
                      },
                      child: const Text("SETUJU", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA000), // Orange
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Get.back(); // Close validation dialog
                        _showSelectSupervisorDialog(pengajuan);
                      },
                      child: const Text("PILIH ULANG", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // Opsional: agar tidak bisa ditutup dengan tap di luar area
    );
  }

  void _showSelectSupervisorDialog(PengajuanPembimbingModel pengajuan) {
    int? selectedUtama = pengajuan.idPembimbingUtama;
    int? selectedPendamping = pengajuan.idPembimbingPendamping;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Pilih Dosen Pembimbing",
                  style: TextStyle(
                    color: Color(0xFF0D47A1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Pembimbing Utama", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: selectedUtama,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: controller.listDosen.map((dosen) {
                  return DropdownMenuItem<int>(
                    value: dosen.id,
                    child: Text(dosen.namaDosen ?? "-", style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (val) => selectedUtama = val,
              ),
              const SizedBox(height: 16),
              const Text("Pembimbing Pendamping", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: selectedPendamping,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: controller.listDosen.map((dosen) {
                  return DropdownMenuItem<int>(
                    value: dosen.id,
                    child: Text(dosen.namaDosen ?? "-", style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (val) => selectedPendamping = val,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text("BATAL"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3399FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (selectedUtama != null && selectedPendamping != null) {
                          if (selectedUtama == selectedPendamping) {
                            Get.snackbar("Peringatan", "Pembimbing 1 dan 2 tidak boleh sama",
                                backgroundColor: Colors.orange, colorText: Colors.white);
                            return;
                          }
                          controller.updateSupervisor(pengajuan.id!, selectedUtama!, selectedPendamping!);
                          Get.back();
                        }
                      },
                      child: const Text("SIMPAN", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widget untuk baris tabel (Letakkan di dalam atau di luar class yang sama) ---
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: Text(":", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ),
      ],
    );
  }

  // --- Helper Widget untuk label nama dosen (Letakkan di dalam atau di luar class yang sama) ---
  Widget _buildDosenChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFC8E6C9), // Hijau muda pucat sesuai gambar
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        name,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }
}
