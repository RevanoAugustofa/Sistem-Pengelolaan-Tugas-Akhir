import 'package:flutter/material.dart';
import 'package:frontend/controllers/dosen_controller.dart';
import 'package:get/get.dart';
import '../../../models/mahasiswa_model.dart';
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
  late Mahasiswa mahasiswa;

  @override
  void initState() {
    super.initState();
    mahasiswa = Get.arguments as Mahasiswa;
    
    // Fetch data awal untuk menentukan hak akses (isPenguji, isPembimbing, dll)
    final controller = Get.find<DosenController>();
    controller.fetchJadwalSempro(mahasiswa.id!);
    controller.fetchJadwalSidangTA(mahasiswa.id!);
  }

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

          // --- TAB BAR ---
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

          // --- TABLE / LIST AREA ---
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
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
    final controller = Get.find<DosenController>();
    
    if (selectedTab == "Proposal") {
      return Obx(() {
        if (controller.isLoadingSempro.value) {
          return const Center(child: CircularProgressIndicator());
        }
        // Hanya Penguji yang bisa melihat tab Proposal
        if (controller.isPengujiSempro.value) {
          return TugasAkhirProposalTable(searchQuery: searchQuery);
        } else {
          return _buildAccessDenied();
        }
      });
    } else if (selectedTab == "Bimbingan") {
      // Hanya Dosen Pembimbing yang bisa melihat tab Bimbingan
      if (mahasiswa.kategori_dosen == "bimbingan") {
        return TugasAkhirBimbinganTable(searchQuery: searchQuery);
      } else {
        return _buildAccessDenied();
      }
    } else {
      // Tab Sidang bisa diakses oleh Penguji maupun Pembimbing Sidang
      return Obx(() {
        if (controller.isLoadingSidang.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.isPengujiSidang.value || controller.isPembimbingSidang.value) {
          return TugasAkhirSidangTable(searchQuery: searchQuery);
        } else {
          return _buildAccessDenied();
        }
      });
    }
  }

  Widget _buildAccessDenied() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(Icons.lock_outline, size: 80, color: Colors.grey.shade400),
          // const SizedBox(height: 16),
          Text(
            "Maaf, halaman tidak tersedia",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Anda tidak memiliki akses ke tab ini.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
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
