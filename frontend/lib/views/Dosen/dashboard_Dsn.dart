import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/dosen_controller.dart';

class DashboardDsn extends StatefulWidget {
  const DashboardDsn({super.key});

  @override
  State<DashboardDsn> createState() => _DashboardDsnState();
}

class _DashboardDsnState extends State<DashboardDsn> {
  final ProfileController profileController = Get.put(ProfileController());
  final DosenController dosenController = Get.put(DosenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // HEADER BACKGROUND
          Container(
            height: 230,
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                           Image.asset('assets/img/logo2_putih.png', height: 50),
                      
                      Stack(
                        children: [
                          const Icon(Icons.notifications_none,
                              color: Colors.white, size: 30),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  Obx(() => Text(
                    "Halo ${profileController.userName.value.split(' ').first}!",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(height: 4),
                  const Text(
                    "Kelola Progres Tugas Akhir Mahasiswa Disini.",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),

                  const SizedBox(height: 20),

                  _buildProfileCard(),

                  const SizedBox(height: 25),

                  // STAT CARDS
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                        "Bimbingan",
                        "6",
                        Icons.people,
                      )),
                      const SizedBox(width: 15),
                      Expanded(
                          child: _buildStatCard(
                        "Penilaian",
                        "12",
                        Icons.assignment,
                      )),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                        "Logbook Baru",
                        "5",
                        Icons.book,
                      )),
                      const SizedBox(width: 15),
                      Expanded(
                          child: _buildStatCard(
                        "Jadwal",
                        "-",
                        Icons.calendar_today,
                      )),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Jadwal Terdekat",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  _buildJadwalList(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // PROFILE CARD
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  profileController.userName.value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
                const SizedBox(height: 4),
                Obx(() => Text(
                  profileController.userId.value,
                  style: const TextStyle(fontSize: 13),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  // STAT CARD
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      height: 85,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(value,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue),
          )
        ],
      ),
    );
  }

  // JADWAL LIST
  Widget _buildJadwalList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
      ),
      child: Column(
        children: [
          _jadwalItem("25 Nov", "Revano Augustofa", "Ruangan : GTIL I.41"),
          const Divider(),
          _jadwalItem("25 Nov", "Nama Mahasiswa", "Ruangan : GTIL I.41"),
          const Divider(),
          _jadwalItem("25 Nov", "Nama Mahasiswa", "Ruangan : GTIL I.41"),
        ],
      ),
    );
  }

  Widget _jadwalItem(String date, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 45,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  // BOTTOM NAV
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF283D70),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Get.toNamed('/listMahasiswaDsn');
        } else if (index == 2) {
          Get.toNamed('/jadwalDsn');
        } else if (index == 3) {
          Get.toNamed('/profil', arguments: {'activeRole': 'dosen'});
        }
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: "Beranda"),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: "Tugas Akhir"),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Jadwal"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "Profil"),
      ],
    );
  }
}