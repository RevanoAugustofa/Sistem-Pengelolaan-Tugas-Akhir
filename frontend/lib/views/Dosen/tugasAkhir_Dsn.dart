import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TugasAkhirDosenPage extends StatefulWidget {
  const TugasAkhirDosenPage({super.key});

  @override
  State<TugasAkhirDosenPage> createState() => _TugasAkhirDosenPageState();
}

class _TugasAkhirDosenPageState extends State<TugasAkhirDosenPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedTab = "Proposal";
  String searchQuery = "";

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
          "Tugas Akhir",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- TAB BAR ---
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFF7E89AC),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildTabItem("Proposal"),
                _buildTabItem("Bimbingan"),
                _buildTabItem("Sidang"),
              ],
            ),
          ),

          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
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
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Filter - All",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),

          // --- TABLE / LIST AREA ---
          Expanded(
            child: buildTable(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- TAB BUTTON ---
  Widget _buildTabItem(String title) {
    bool isActive = selectedTab == title;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1E3475) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // --- SWITCH KONTEN ---
  Widget buildTable() {
    if (selectedTab == "Proposal") {
      return buildProposalList(); // Panggil fungsi list vertikal
    } else if (selectedTab == "Bimbingan") {
      return buildBimbinganTable();
    } else {
      return buildSidangTable();
    }
  }

  // =============================
  // KONTEN PROPOSAL (DIUBAH MENJADI LIST)
  // =============================
  Widget buildProposalList() {
   return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        dataRowHeight: 60,
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Link')),
          DataColumn(label: Text('Tanggal')),
        ],
        rows: List.generate(5, (index) {
          return DataRow(
            color: WidgetStateProperty.resolveWith<Color?>((states) {
              if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
              return null;
            }),
            cells: [
              DataCell(Text("${index + 1}")),
              const DataCell(Text("Mahasiswa")),
              const DataCell(Text("Zoom Meeting")),
              const DataCell(Text("12-03-2026")),
            ],
          );
        }),
      ),
    );
  } 
  

  // Widget Bantuan untuk List Card (Dari desain atas)
  Widget _buildStudentCard(String nama, String npm, String kelas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  "$npm    $kelas",
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                 Get.toNamed('/logbookDsn');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FA5FF), // Warna biru filter
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text("Pilih", style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  // =============================
  // TABEL BIMBINGAN
  // =============================
  Widget buildBimbinganTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentCard("Revano Augustofa", "230102071", "TI-C"),
          _buildStudentCard("Arya Awikwok", "230102071", "TI-C"),
          _buildStudentCard("Arya Awikwok", "230102071", "TI-C"),
          _buildStudentCard("Alle Danaralle", "230102071", "TI-C"),
          
          const SizedBox(height: 10),
          const Text(
            "Menampilkan 4 dari 10 data",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // =============================
  // TABEL SIDANG
  // =============================
  Widget buildSidangTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Penguji')),
          DataColumn(label: Text('Tanggal')),
        ],
        rows: List.generate(5, (index) {
          return DataRow(
            color: WidgetStateProperty.resolveWith<Color?>((states) {
              if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
              return null;
            }),
            cells: [
              DataCell(Text("${index + 1}")),
              const DataCell(Text("Mahasiswa")),
              const DataCell(Text("Dr. Dosen")),
              const DataCell(Text("20-03-2026")),
            ],
          );
        }),
      ),
    );
  }

  //  BOTTOM NAVIGATION BAR ==================================================
    Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF283D70),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      currentIndex: 1,
      onTap: (index) {
        // Logika pindah halaman berdasarkan index menu
        if (index == 0) {
          // Index 1 "Tugas Akhir"
          Get.toNamed('/dashboardDsn'); 
        } else if (index == 2) {
          Get.toNamed('/jadwalDsn');
        } else if (index == 3) {
          Get.toNamed('/');
        }
      },
      
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "Tugas Akhir"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Jadwal"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
      ],
    );
  }
}
