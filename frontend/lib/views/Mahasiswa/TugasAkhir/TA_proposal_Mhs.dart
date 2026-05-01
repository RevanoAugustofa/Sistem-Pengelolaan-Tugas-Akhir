import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaProposalMhs extends StatelessWidget {
  const TaProposalMhs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Tugas Akhir", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF283D70), // Warna biru navy PNC
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Tab Navigation (Proposal, Bimbingan, Sidang)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF8E99BA),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  _buildTabItem("Proposal", isActive: true),
                  _buildTabItem("Bimbingan",
                    onTap: () {
                      Get.toNamed('/bimbinganMhs');
                    }, ),
                    
                  _buildTabItem("Sidang"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Proposal Section Header
            const Text(
              "Proposal Tugas Akhir",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Kelola dokumen proposal, lihat catatan revisi dan status persetujuan",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // 3. Status Card
            _buildStatusCard(),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: _buildBlueButton("Unggah"),
            ),
            const SizedBox(height: 24),

            // 4. Catatan Revisi Section
            const Text(
              "Catatan Revisi Seminar Proposal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRevisionItem("Bab 1, Rumusan Masalah dipertegas.", "Arfilal Faiznadi, Amd."),
            _buildRevisionItem("Bab 2, Rumusan Masalah dipertegas.", "Arfilal Faiznadi, Amd."),
            _buildRevisionItem("Bab 3, Rumusan Masalah dipertegas.", "Arfilal Faiznadi, Amd."),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: _buildBlueButton("Unggah"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildTabItem(String title, {bool isActive = false, VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildStatusRow("Unggah Proposal", "Belum"),
          const Divider(),
          _buildStatusRow("Tinjau Dosen", "Menunggu"),
          const Divider(),
          _buildStatusRow("Seminar Proposal", "Belum Terjadwal"),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 12, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildRevisionItem(String title, String dosen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Dosen : $dosen", style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.red),
                  const SizedBox(width: 4),
                  const Text("Belum diperbaiki", style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text("01 juni 2025", style: TextStyle(fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBlueButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A89FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
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