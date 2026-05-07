import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tugas_akhir_proposal.dart';
import 'tugas_akhir_bimbingan.dart';
import 'tugas_akhir_sidang.dart';

class TugasAkhirMhsController extends GetxController {
  var selectedTab = 0.obs; // 0: Proposal, 1: Bimbingan, 2: Sidang
}

class TugasAkhirMhsPage extends StatefulWidget {
  const TugasAkhirMhsPage({super.key});

  @override
  State<TugasAkhirMhsPage> createState() => _TugasAkhirMhsPageState();
}

class _TugasAkhirMhsPageState extends State<TugasAkhirMhsPage> {
  late TugasAkhirMhsController controller;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dan set tab awal dari arguments jika ada
    controller = Get.put(TugasAkhirMhsController());
    if (Get.arguments != null && Get.arguments is int) {
      controller.selectedTab.value = Get.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Tugas Akhir", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF283D70),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 1. Tab Navigation
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF8E99BA),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildTabItem("Proposal", 0),
                _buildTabItem("Bimbingan", 1),
                _buildTabItem("Sidang", 2),
              ],
            ),
          ),

          // 2. Dynamic Content
          Expanded(
            child: Obx(() {
              switch (controller.selectedTab.value) {
                case 0:
                  return const TugasAkhirProposalMhsView();
                case 1:
                  return const TugasAkhirBimbinganMhsView();
                case 2:
                  return const TugasAkhirSidangMhsView();
                default:
                  return const SizedBox();
              }
            }),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTabItem(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedTab.value = index,
        child: Obx(() {
          bool isActive = controller.selectedTab.value == index;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF283D70) : Colors.transparent,
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
          );
        }),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      selectedItemColor: const Color(0xFF283D70),
      onTap: (index) {
        if (index == 0) {
          Get.toNamed('/dashboardMhs'); 
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
