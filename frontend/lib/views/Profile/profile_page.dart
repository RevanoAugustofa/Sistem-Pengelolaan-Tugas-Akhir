import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class ProfilPage extends StatelessWidget {
  ProfilPage({super.key}) {
    // Pastikan data diperbarui setiap kali masuk halaman profil
    // terutama jika dibuka dari dashboard yang berbeda
    if (Get.isRegistered<ProfileController>()) {
      final ProfileController controller = Get.find<ProfileController>();
      String? activeRole = Get.arguments?['activeRole'];
      controller.loadUserData(activeRole: activeRole);
    }
  }

  final ProfileController controller = Get.put(ProfileController());

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
        leading: Obx(() {
          String role = controller.userRole.value.toLowerCase().trim();
          if (role == 'admin' || role == 'koorprodi') {
            return IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            );
          }
          return const SizedBox.shrink();
        }),
        backgroundColor: const Color.fromARGB(255, 0, 149, 255),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // 1. Header Profil (Foto & Nama)
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Text(
                      controller.userName.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.userId.value,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 2. Daftar Menu Profil
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: "Notifikasi",
              subtitle: "Lihat notifikasi terbaru",
              onTap: () {
                Get.toNamed('/notifikasi');
              },
            ),
            _buildMenuItem(
              icon: Icons.badge_outlined,
              title: "Data Diri",
              subtitle: "Informasi data user",
              onTap: () {
                Get.toNamed('/datadiri');
              },
            ),
            _buildMenuItem(
              icon: Icons.lock_outline,
              title: "Password",
              subtitle: "Ubah password user",
              onTap: () {
                Get.toNamed('/ubah_password');
              },
            ),

            const SizedBox(height: 10),

            // SECTION ROLE (Tampil jika punya lebih dari 1 role)
            Obx(() {
              if (controller.availableRoles.length > 1) {
                // Pastikan role diurutkan agar konsisten: jabatan dulu baru 'dosen'
                List<String> sortedRoles = List<String>.from(controller.availableRoles);
                sortedRoles.sort((a, b) {
                  if (a.toLowerCase() == 'dosen') return 1;
                  if (b.toLowerCase() == 'dosen') return -1;
                  return a.compareTo(b);
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "ROLE AKUN",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "hak akses",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    ...sortedRoles.map((role) {
                      // Normalisasi untuk perbandingan
                      String currentRole = controller.userRole.value.toLowerCase().trim();
                      String roleItem = role.toLowerCase().trim();
                      
                      bool isActive = currentRole == roleItem;
                      
                      return _buildRoleCard(
                        title: role.capitalizeFirst ?? role,
                        subtitle: isActive ? "Sekarang Aktif" : "Klik untuk mengganti dengan role ini",
                        isActive: isActive,
                        onTap: isActive ? null : () => controller.switchRole(roleItem),
                      );
                    }).toList(),
                    const SizedBox(height: 10),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),

            // 3. Tombol Keluar
            _buildMenuItem(
              icon: Icons.logout,
              title: "Keluar",
              onTap: () {
                controller.logout();
              },
              color: Colors.orange,
              showArrow: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () =>
            _buildBottomNav(controller.userRole.value) ??
            const SizedBox.shrink(),
      ),
    );
  }

  // Helper untuk membuat baris menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color color = const Color(0xFF283D70),
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: color,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
            ),
            if (showArrow)
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  // Helper build card role
  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive ? const Color.fromARGB(255, 0, 149, 255) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isActive ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              // Badge kanan
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Aktif",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 149, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // BOTTOM NAVIGATION BAR DINAMIS
  Widget? _buildBottomNav(String role) {
    // Normalisasi role ke lowercase untuk pengecekan
    String roleLower = role.toLowerCase().trim();
    
    if (roleLower == 'admin' || roleLower == 'koorprodi') {
      return null;
    }

    int currentIndex = 3; // Profil biasanya di index terakhir

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF283D70),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      onTap: (index) {
        if (roleLower == 'mahasiswa') {
          if (index == 0)
            Get.offAllNamed('/dashboardMhs');
          else if (index == 1)
            Get.toNamed('/tugasAkhirMhs');
          else if (index == 2)
            Get.toNamed('/jadwalSemproMhs');
          else if (index == 3) {} // Stay here
        } else if (roleLower == 'dosen') {
          if (index == 0)
            Get.offAllNamed('/dashboardDsn');
          else if (index == 1)
            Get.toNamed('/tugasAkhirDsn');
          else if (index == 2)
            Get.toNamed('/jadwalDsn');
          else if (index == 3) {} // Stay here
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Beranda",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          label: "Tugas Akhir",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: "Jadwal",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profil",
        ),
      ],
    );
  }
}