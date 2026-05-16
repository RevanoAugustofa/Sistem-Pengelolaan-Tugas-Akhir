import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/dosen_controller.dart';
import 'jadwal_proposal.dart';
import 'jadwal_bimbingan.dart';
import 'jadwal_sidang.dart';
import 'widgets/filter_jadwal_modal.dart';

class JadwalDosenPage extends StatefulWidget {
  const JadwalDosenPage({super.key});

  @override
  State<JadwalDosenPage> createState() => _JadwalDosenPageState();
}

class _JadwalDosenPageState extends State<JadwalDosenPage> {
  final DosenController controller = Get.put(DosenController());
  final TextEditingController searchController = TextEditingController();
  String selectedTab = "Proposal";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        automaticallyImplyLeading: false,
        elevation: 0,
        
        title: const Text(
          "Jadwal",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  controller.searchSchedule(value);
                },
                decoration: InputDecoration(
                  hintText: "Cari Mahasiswa...",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune, color: Color(0xFF10A8E5)),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => FilterJadwalModal(selectedTab: selectedTab),
                      );
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Jadwal - $selectedTab TA",
                  style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Obx(() {
                  if (controller.filterScheduleDate.value.isNotEmpty || controller.filterScheduleRuangan.value.isNotEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Filter Aktif",
                        style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return const SizedBox();
                }),
              ],
            ),
          ),

          // --- TABLE / LIST AREA ---
          Expanded(
            child: _buildTable(),
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
        onTap: () {
          setState(() => selectedTab = title);
          controller.resetScheduleFilter();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.black12 : Colors.transparent,
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
  Widget _buildTable() {
    if (selectedTab == "Proposal") {
      return const JadwalProposalDosenTable(searchQuery: "");
    } else if (selectedTab == "Bimbingan") {
      return const JadwalBimbinganDosenTable(searchQuery: "");
    } else {
      return const JadwalSidangDosenTable(searchQuery: "");
    }
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
          Get.toNamed('/listMahasiswaDsn');
        } else if (index == 3) {
          Get.toNamed('/profil', arguments: {'activeRole': 'dosen'});
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
