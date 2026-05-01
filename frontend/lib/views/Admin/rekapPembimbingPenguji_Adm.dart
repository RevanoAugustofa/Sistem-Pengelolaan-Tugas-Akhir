import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RekapPembimbingPengujiAdminPage extends StatefulWidget {
  const RekapPembimbingPengujiAdminPage({super.key});

  @override
  State<RekapPembimbingPengujiAdminPage> createState() => _RekapPembimbingPengujiAdminPageState();
}

class _RekapPembimbingPengujiAdminPageState extends State<RekapPembimbingPengujiAdminPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Background abu-abu muda
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Rekap Pembimbing & Penguji",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Cari Mahasiswa",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  suffixIcon: Icon(Icons.tune, color: Colors.blue),
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Filter - All",
              style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // --- List Card Mahasiswa ---
            _buildStudentCard(
              nama: "Revano Augustofa",
              npm: "230102071",
              kelas: "TI-C",
              status: "Disetujui",
            ),
            _buildStudentCard(
              nama: "Arya Awikwok",
              npm: "230102071",
              kelas: "TI-C",
              status: "Disetujui",
            ),
            _buildStudentCard(
              nama: "Arya Awikwok",
              npm: "230102071",
              kelas: "TI-C",
              status: "Disetujui",
            ),
            _buildStudentCard(
              nama: "Alle Danaralle",
              npm: "230102071",
              kelas: "TI-C",
              status: "Ditolak",
            ),
            _buildStudentCard(
              nama: "Alle Danaralle",
              npm: "230102071",
              kelas: "TI-C",
              status: "Menunggu",
            ),

            const SizedBox(height: 30),

            // --- Pagination ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Menampilkan 5 dari 10 data",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Row(
                  children: [
                    _buildPageNode("1", isActive: false),
                    const SizedBox(width: 5),
                    _buildPageNode("2", isActive: true),
                    const SizedBox(width: 5),
                    _buildPageNode("...", isActive: false, isGreyBackground: true),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER: Card Mahasiswa ---
  Widget _buildStudentCard({
    required String nama,
    required String npm,
    required String kelas,
    required String status,
  }) {
    // Logika Warna Badge Status
    Color badgeColor;
    Color textColor;
    BoxBorder? badgeBorder;

    if (status == "Disetujui") {
      badgeColor = const Color(0xFFD1FADF); // Hijau muda
      textColor = const Color(0xFF12B76A); // Hijau tua
    } else if (status == "Ditolak") {
      badgeColor = const Color(0xFFFEE4E2); // Merah muda
      textColor = const Color(0xFFF04438); // Merah tua
    } else {
      // Menunggu
      badgeColor = Colors.transparent;
      textColor = Colors.grey.shade700;
      badgeBorder = Border.all(color: Colors.grey.shade400);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Info Mahasiswa (Kiri)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "$npm   $kelas",
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          
          // Badge & Tombol (Kanan)
          Row(
            children: [
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(4),
                  border: badgeBorder,
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              
              // Tombol Validasi
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi validasi
                  },
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
    );
  }

  // --- WIDGET HELPER: Pagination Node ---
  Widget _buildPageNode(String text, {required bool isActive, bool isGreyBackground = false}) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive 
            ? Colors.grey.shade400 
            : (isGreyBackground ? Colors.grey.shade200 : Colors.transparent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}
