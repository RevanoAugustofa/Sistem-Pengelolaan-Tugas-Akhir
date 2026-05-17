import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/mahasiswa_model.dart';
import '../../controllers/koorprodi_controller.dart';

class DetailLogbookPage extends StatefulWidget {
  final Mahasiswa mahasiswa;
  const DetailLogbookPage({super.key, required this.mahasiswa});

  @override
  State<DetailLogbookPage> createState() => _DetailLogbookPageState();
}

class _DetailLogbookPageState extends State<DetailLogbookPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final KoorProdiController controller = Get.find<KoorProdiController>();
  var logbookData = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchLogbook();
  }

  void _fetchLogbook() async {
    try {
      isLoading(true);
      // Asumsi ada service untuk mengambil logbook berdasarkan ID mahasiswa
      // Untuk sementara kita gunakan dummy atau placeholder jika service belum ada
      // var data = await controller.fetchLogbookMahasiswa(widget.mahasiswa.id!);
      // logbookData.assignAll(data);
    } catch (e) {
      print("Error fetch logbook: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2196F3);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail Logbook",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 149, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section Info Mahasiswa ---
            _buildInfoRow("nama mahasiswa", widget.mahasiswa.namaMahasiswa ?? "-"),
            _buildInfoRow("NPM", widget.mahasiswa.npm ?? "-"),
            _buildInfoRow("Judul TA", widget.mahasiswa.judulTa),
            
            const SizedBox(height: 12),
            
            // Badge Status (Contoh: Menggunakan data dari mahasiswa)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryBlue.withOpacity(0.3)),
              ),
              child: const Text(
                "Sedang Berjalan",
                style: TextStyle(color: primaryBlue, fontSize: 12),
              ),
            ),
            
            const SizedBox(height: 24),

            // --- Custom Tab Bar ---
            TabBar(
              controller: _tabController,
              labelColor: primaryBlue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryBlue,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: "Pembimbing Utama"),
                Tab(text: "Pembimbing Pendamping"),
              ],
            ),
            
            const SizedBox(height: 20),

            // --- Total Bimbingan Summary ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Pilih tab untuk melihat riwayat bimbingan",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // --- List Logbook Entries (Placeholder) ---
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Data bimbingan detail akan muncul di sini", style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Baris Informasi (Label : Value)
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: "$label : ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}