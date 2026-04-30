import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JadwalController extends GetxController {
  var selectedJadwalTab = 0.obs; // 0: Sempro, 1: Sidang TA
}

class JadwalSemproMhs extends StatelessWidget {
  const JadwalSemproMhs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JadwalController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Jadwal Sempro", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          Obx(() => Container(
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
          )),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Filter", style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("-All", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // 3. List Jadwal
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 3, // Sesuai desain kamu
              itemBuilder: (context, index) {
                return _buildJadwalCard("Revano Augustofa", "Jum'at 20, Februari 2026", "08.30.00 - 09.45.00 WIB");
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(), // Index 2 untuk Jadwal
    );
  }

  Widget _buildTabItem(String label, int index, JadwalController controller) {
    bool isActive = controller.selectedJadwalTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedJadwalTab.value = index,
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

  Widget _buildJadwalCard(String nama, String tanggal, String jam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nama,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF283D70), fontSize: 15),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
              Text(tanggal, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
              Text(jam, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
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
        // Logika pindah halaman berdasarkan index menu
        if (index == 0) {
          Get.toNamed('/dashboardMhs'); 
        } else if (index == 1) {
          Get.toNamed('/proposalMhs');
        } else if (index == 2) {
          Get.toNamed('/jadwalSemproMhs');
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