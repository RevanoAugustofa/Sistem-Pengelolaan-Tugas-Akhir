import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: DetailLogbookPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class DetailLogbookPage extends StatefulWidget {
  const DetailLogbookPage({super.key});

  @override
  State<DetailLogbookPage> createState() => _DetailLogbookPageState();
}

class _DetailLogbookPageState extends State<DetailLogbookPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section Info Mahasiswa ---
            _buildInfoRow("nama mahasiswa", "Revano Augustofa"),
            _buildInfoRow("NPM", "230102072"),
            _buildInfoRow("Judul TA", "Sistem Informasi Pengelolaan Tugas Akhir"),
            
            const SizedBox(height: 12),
            
            // Badge Belum Direkomendasikan
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryBlue.withOpacity(0.3)),
              ),
              child: const Text(
                "Belum Direkomendasikan",
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
                "Total bimbingan : 3",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // --- List Logbook Entries ---
            _buildLogItem("Jumat 23 Juli 2026"),
            _buildLogItem("Jumat 23 Juli 2026"),
            _buildLogItem("Jumat 23 Juli 2026"),
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

  // Widget Helper untuk Item Logbook
  Widget _buildLogItem(String date) {
    const primaryBlue = Color(0xFF2196F3);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryBlue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  "lihat file",
                  style: TextStyle(color: primaryBlue, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Box Konten Log (TextField/Area Kosong)
          Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
          ),
        ],
      ),
    );
  }
}