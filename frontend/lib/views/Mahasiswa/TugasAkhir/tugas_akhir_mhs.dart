import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tugas_akhir_proposal.dart';
import 'tugas_akhir_bimbingan.dart';
import 'tugas_akhir_sidang.dart';

class TugasAkhirMhsPage extends StatefulWidget {
  const TugasAkhirMhsPage({super.key});

  @override
  State<TugasAkhirMhsPage> createState() => _TugasAkhirMhsPageState();
}

class _TugasAkhirMhsPageState extends State<TugasAkhirMhsPage> {
  String selectedTab = "Proposal";

  @override
  void initState() {
    super.initState();
    // Set tab awal dari arguments jika ada
    if (Get.arguments != null) {
      if (Get.arguments is String) {
        selectedTab = Get.arguments;
      } else if (Get.arguments is int) {
        // Fallback jika masih ada yang mengirim int
        if (Get.arguments == 1) selectedTab = "Bimbingan";
        if (Get.arguments == 2) selectedTab = "Sidang";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Tugas Akhir",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                _buildTabItem("Proposal"),
                _buildTabItem("Bimbingan"),
                _buildTabItem("Sidang"),
              ],
            ),
          ),

          // 2. Dynamic Content
          Expanded(
            child: buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTabItem(String title) {
    bool isActive = selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = title;
          });
        },
        child: Container(
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
        ),
      ),
    );
  }

  Widget buildContent() {
    switch (selectedTab) {
      case "Proposal":
        return const TugasAkhirProposalMhsView();
      case "Bimbingan":
        return const TugasAkhirBimbinganMhsView();
      case "Sidang":
        return const TugasAkhirSidangMhsView();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      selectedItemColor: const Color(0xFF283D70),
      onTap: (index) {
        if (index == 0) {
          Get.offNamed('/dashboardMhs');
        } else if (index == 2) {
          Get.offNamed('/jadwalSemproMhs');
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
