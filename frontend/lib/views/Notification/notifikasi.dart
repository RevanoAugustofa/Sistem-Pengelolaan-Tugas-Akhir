import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Notifikasi",
          style: TextStyle(color: Color(0xFF283D70), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Biru Navy PNC
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        
        children: [
          // Daftar Menu Notifikasi
          _buildMenuItem(
            // icon: Icons.history,
            title: "Histori",
            subtitle: "Cek histori pendaftaran",
            onTap: () {
              // Get.toNamed('/');
            },
          ),

        ],
      ),
    );
  }

  // Helper untuk membuat baris menu
  Widget _buildMenuItem({
    // required IconData icon,
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
            // Icon(icon, color: const Color(0xFF283D70), size: 28),
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
}