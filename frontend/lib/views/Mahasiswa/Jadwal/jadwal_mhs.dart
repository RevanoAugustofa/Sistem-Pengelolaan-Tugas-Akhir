import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'jadwal_sempro.dart';
import 'jadwal_sidang.dart';

class JadwalMhsPage extends StatefulWidget {
  const JadwalMhsPage({super.key});

  @override
  State<JadwalMhsPage> createState() => _JadwalMhsPageState();
}

class _JadwalMhsPageState extends State<JadwalMhsPage> {
  final TextEditingController searchController = TextEditingController();
  // int selectedTab = 0; // 0: Sempro, 1: Sidang TA
  String searchQuery = "";
  String selectedTab = "Sempro";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Jadwal",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF283D70),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 1. Tab Selector (Sempro / Sidang TA)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF8E99BA).withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildTabItem("Sempro"),
                _buildTabItem("Sidang TA"),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Search & Filter Section
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
                  hintText: "Cari nama mahasiswa...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  suffixIcon: Icon(Icons.tune, color: Color(0xFF283D70)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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

          // 3. Content Area
          Expanded(
            child: buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTabItem(String label) {
    bool isActive = selectedTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF283D70) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            label,
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

  Widget buildContent() {
    if (selectedTab == "Sempro") {
      return const JadwalSemproList();
    } else {
      return const JadwalSidangList();
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
          Get.offNamed('/dashboardMhs');
        } else if (index == 1) {
          Get.offNamed('/tugasAkhirMhs');
        } else if (index == 3) {
          Get.offNamed('/profil');
        }
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: "Beranda"),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined), label: "Tugas Akhir"),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined), label: "Jadwal"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "Profil"),
      ],
    );
  }
}
