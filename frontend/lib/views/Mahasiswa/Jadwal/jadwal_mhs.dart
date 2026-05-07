import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'jadwal_sempro.dart';
import 'jadwal_sidang.dart';

class JadwalController extends GetxController {
  var selectedJadwalTab = 0.obs; // 0: Sempro, 1: Sidang TA
}

class JadwalMhsPage extends StatelessWidget {
  const JadwalMhsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JadwalController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Jadwal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF283D70),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                _buildTabItem("Sempro", 0, controller),
                _buildTabItem("Sidang TA", 1, controller),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Search & Filter Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Cari nama mahasiswa...",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5F74),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text("filter", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Filter", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("-All", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // 3. Content Area
          Expanded(
            child: Obx(() {
              return controller.selectedJadwalTab.value == 0
                  ? const JadwalSemproList()
                  : const JadwalSidangList();
            }),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTabItem(String label, int index, JadwalController controller) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedJadwalTab.value = index,
        child: Obx(() {
          bool isActive = controller.selectedJadwalTab.value == index;
          return Container(
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
          Get.toNamed('/dashboardMhs'); 
        } else if (index == 1) {
          Get.toNamed('/tugasAkhirMhs');
        } else if (index == 3) {
          Get.toNamed('/profil');
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