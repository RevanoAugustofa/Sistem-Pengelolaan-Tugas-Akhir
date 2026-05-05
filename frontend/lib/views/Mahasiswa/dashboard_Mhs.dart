import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/mhs_controller.dart';

class DashboardMhs extends StatelessWidget {
  DashboardMhs({super.key});

  final ProfileController profileController = Get.put(ProfileController());
  final MhsController mhsController = Get.put(MhsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Stack(
        children: [
          // Background Biru Navy bagian atas
          Container(
            height: 220,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 149, 255),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
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
                  // Header: Logo SIPTA & Notifikasi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/img/logo2_putih.png', height: 50),
                    GestureDetector(
                        onTap: () => Get.toNamed('/notifikasi'),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(
                                Icons.notifications,
                                color: Colors.blue,
                                size: 20,
                              ),
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Halo Mahasiswa !",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Kelola Progres Tugas Akhir Anda Disini.",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 10),

                  // 1. Kartu Profil Mahasiswa
                  _buildProfileCard(),
                  const SizedBox(height: 16),

                  // 2. Baris Dosen & Tahap
                  Row(
                    children: [
                      Expanded(child: Obx(() => _buildDosenCard())),
                      // const SizedBox(width: 12),
                      // Expanded(child: _buildTahapCard()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 3. Ringkasan Progres Section
                  const Text(
                    "Ringkasan Progres",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildProgresItem(
                    Icons.description,
                    "Proposal",
                    "Belum diunggah",
                  ),
                  Obx(() => _buildProgresItem(
                    Icons.people,
                    "Pembimbing",
                    mhsController.pengajuanStatus.value == "diajukan"
                        ? "Sudah Diajukan"
                        : mhsController.pengajuanStatus.value == "disetujui"
                            ? "Disetujui"
                            : "Belum Diajukan",
                  )),
                  _buildProgresItem(
                    Icons.event_note,
                    "Seminar Proposal",
                    "Belum Terjadwal",
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

  // --- WIDGET HELPERS ---

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Image.asset('assets/img/profile.png', height: 70),
          // Container(height: 70, width: 70, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Revano Augustofa",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "NPM. 03929833",
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 0, 149, 255)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Angkatan 2023",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 149, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosenCard() {
    bool isApplied = mhsController.pengajuanStatus.value == "diajukan";

    return Container(
      height: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isApplied
                    ? "Pengajuan Dosen Pembimbing sedang diproses"
                    : "Daftar Dosen Pembimbing sekarang",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 35,
            child: ElevatedButton(
              onPressed: isApplied
                  ? null
                  : () {
                      Get.toNamed('/pendaftaranDosen');
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isApplied ? Colors.blue : const Color(0xFFFDE047),
                foregroundColor: isApplied ? Colors.white : Colors.black,
                disabledBackgroundColor: Colors.blue,
                disabledForegroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                isApplied ? "MENUNGGU" : "DAFTAR",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildTahapCard() {
  //   return Container(
  //     height: 130,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         // KIRI (text)
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: const [
  //             Text(
  //               "Progres",
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  //             ),
  //             // Text(
  //             //   "98%",
  //             //   style: TextStyle(
  //             //     fontSize: 22,
  //             //     fontWeight: FontWeight.bold,
  //             //   ),
  //             // ),
  //           ],
  //         ),

  //         // KANAN (circular progress)
  //         SizedBox(
  //           width: 70,
  //           height: 70,
  //           child: Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               CircularProgressIndicator(
  //                 value: 0.98,
  //                 strokeWidth: 8,
  //                 backgroundColor: Colors.grey.shade300,
  //                 valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
  //               ),
  //               const Text(
  //                 "98%",
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildProgresItem(IconData icon, String title, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF283D70)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 106, 106, 106),
              ),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Color.fromARGB(255, 94, 94, 94),
                fontSize: 10,
              ),
            ),
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
      currentIndex: 0,
      onTap: (index) {
        // Logika pindah halaman berdasarkan index menu
        if (index == 1) {
          // Index 1 "Tugas Akhir"
          Get.toNamed('/proposalMhs');
        } else if (index == 2) {
          Get.toNamed('/jadwalSemproMhs');
        } else if (index == 3) {
          Get.toNamed('/profil', arguments: {'activeRole': 'mahasiswa'});
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
