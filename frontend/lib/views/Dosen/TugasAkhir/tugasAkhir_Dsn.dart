import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tugas_akhir_proposal.dart';
import 'tugas_akhir_bimbingan.dart';
import 'tugas_akhir_sidang.dart';

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
        backgroundColor: Color(0xFF2196F3),
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

          _buildInfoMahasiswa(),


          // --- TAB BAR ---
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 149, 255),
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
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Container(
          //     height: 50,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(8),
          //       border: Border.all(color: Colors.grey.shade400),
          //     ),
          //     child: TextField(
          //       controller: searchController,
          //       onChanged: (value) {
          //         setState(() {
          //           searchQuery = value;
          //         });
          //       },
          //       decoration: const InputDecoration(
          //         hintText: "Cari Mahasiswa",
          //         hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          //         suffixIcon: Icon(Icons.tune, color: Colors.blue),
          //         contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          //         border: InputBorder.none,
          //       ),
          //     ),
          //   ),
          // ),

          // const Padding(
          //   padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
          //   child: Align(
          //     alignment: Alignment.centerLeft,
          //     child: Text(
          //       "Filter - All",
          //       style: TextStyle(color: Colors.grey, fontSize: 13),
          //     ),
          //   ),
          // ),

          // --- TABLE / LIST AREA ---
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      // bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- WIDGET BARU: INFO MAHASISWA ---
  Widget _buildInfoMahasiswa() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildDetailRow("NPM", "230102078"),
          const SizedBox(height: 10),
          _buildDetailRow("Nama", "Revano Augustofa"),
          const SizedBox(height: 10),
          // Khusus untuk Judul TA, kita buat Row manual agar teksnya bisa underline dan multiline dengan baik
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80, // Lebar tetap untuk label
                child: Text("Judul TA", style: TextStyle(color: Colors.grey.shade800)),
              ),
              Expanded(
                child: Text(
                  "Sistem Informasi Pengelolaan Tugas Akhir",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline, // Menambahkan garis bawah (underline)
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Baris Info Mahasiswa biasa
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80, // Memberikan lebar tetap (fixed width) untuk kolom Label agar rapi
          child: Text(label, style: TextStyle(color: Colors.grey.shade800)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
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
            color: isActive ? Color.fromARGB(74, 0, 0, 0): Colors.transparent,
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
  Widget _buildContent() {
    if (selectedTab == "Proposal") {
      return TugasAkhirProposalTable(searchQuery: searchQuery);
    } else if (selectedTab == "Bimbingan") {
      return TugasAkhirBimbinganTable(searchQuery: searchQuery);
    } else {
      return TugasAkhirSidangTable(searchQuery: searchQuery);
    }
  }

  //  BOTTOM NAVIGATION BAR ==================================================
    // Widget _buildBottomNav() {
    // return BottomNavigationBar(
    //   type: BottomNavigationBarType.fixed,
    //   selectedItemColor: const Color(0xFF283D70),
    //   unselectedItemColor: Colors.grey,
    //   backgroundColor: Colors.white,
    //   currentIndex: 1,
    //   onTap: (index) {
    //     if (index == 0) {
    //       Get.toNamed('/dashboardDsn'); 
    //     } else if (index == 2) {
    //       Get.toNamed('/jadwalDsn');
    //     } else if (index == 3) {
    //       Get.toNamed('/profil', arguments: {'activeRole': 'dosen'});
    //     }
    //   },
      
    //   items: const [
    //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Beranda"),
    //     BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "Tugas Akhir"),
    //     BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Jadwal"),
    //     BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
    //   ],
    // );
  // }
}
