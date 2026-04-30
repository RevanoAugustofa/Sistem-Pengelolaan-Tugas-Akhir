import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF283D70),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          // 1. Header Profil (Foto & Nama)
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Revano Augustofa",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "21312301301",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // 2. Daftar Menu Profil
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: "Notifikasi",
            subtitle: "",
            onTap: () {
              Get.toNamed('/notifikasi');
            },
          ),
          _buildMenuItem(
            icon: Icons.badge_outlined,
            title: "Data Diri",
            subtitle: "informasi data user",
            onTap: () {
              Get.toNamed('/datadiri');
            },
          ),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: "Profil",
            subtitle: "Ubah profil user",
            onTap: () {
              Get.toNamed('/ubah_informasiProfil');
            },
          ),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: "Password",
            subtitle: "Ubah password user",
            onTap: () {
              Get.toNamed('/ubah_password');
            },
          ),
          
          

          const SizedBox(height: 30),

          // 3. Tombol Keluar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: InkWell(
              onTap: () {
                // Logika Logout, misalnya kembali ke halaman Login
                Get.offAllNamed('/login');
              },
              child: const Row(
                children: [
                  Icon(Icons.logout, color: Colors.orange, size: 28),
                  const SizedBox(width: 15),
                  Text(
                    "KELUAR",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(), 
    );
  }

  // Helper untuk membuat baris menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap, // Parameter onTap ditambahkan
  }) {
    return InkWell(
      onTap: onTap, // Menjalankan fungsi navigasi saat diklik
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF283D70), size: 28),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  // BOTTOM NAVIGATION BAR 
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF283D70),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      currentIndex: 3, // Aktif di tab Profil
      onTap: (index) {
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