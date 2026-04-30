import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JadwalDosenPage extends StatefulWidget {
  const JadwalDosenPage({super.key});

  @override
  State<JadwalDosenPage> createState() => _JadwalDosenPageState();
}

class _JadwalDosenPageState extends State<JadwalDosenPage> {
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
          "Jadwal",
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

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Jadwal - $selectedTab TA",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
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
      return buildProposalTable();
    } else if (selectedTab == "Bimbingan") {
      return buildBimbinganTable();
    } else {
      return buildSidangTable();
    }
  }

  // =============================
  // TABEL PROPOSAL
  // =============================
  Widget buildProposalTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        columns: const [
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('NPM')),
          DataColumn(label: Text('Jam & Tgl')),
        ],
        rows: List.generate(5, (index) {
          return DataRow(
            color: WidgetStateProperty.resolveWith<Color?>((states) {
              if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
              return null;
            }),
            cells: [
              const DataCell(Text("Mahasiswa Proposal")),
              const DataCell(Text("230102071")),
              const DataCell(Text("10:00, 12-03-2026")),
            ],
          );
        }),
      ),
    );
  }

  // =============================
  // TABEL BIMBINGAN
  // =============================
  Widget buildBimbinganTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        columns: const [
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('NPM')),
          DataColumn(label: Text('Jam & Tgl')),
        ],
        rows: List.generate(5, (index) {
          return DataRow(
            color: WidgetStateProperty.resolveWith<Color?>((states) {
              if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
              return null;
            }),
            cells: [
              const DataCell(Text("Mahasiswa Bimbingan")),
              const DataCell(Text("230102071")),
              const DataCell(Text("13:00, 13-03-2026")),
            ],
          );
        }),
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
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('NPM')),
          DataColumn(label: Text('Jam & Tgl')),
        ],
        rows: List.generate(5, (index) {
          return DataRow(
            color: WidgetStateProperty.resolveWith<Color?>((states) {
              if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
              return null;
            }),
            cells: [
              const DataCell(Text("Mahasiswa Sidang")),
              const DataCell(Text("230102071")),
              const DataCell(Text("09:00, 15-03-2026")),
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
      currentIndex: 2,
      onTap: (index) {
        if (index == 0) {
          Get.toNamed('/dashboardDsn');
        } else if (index == 1) {
          // Navigasi ke Tugas Akhir
          Get.toNamed('/tugasAkhirDsn');
        } else if (index == 3) {
          // Navigasi ke Profil
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
