import 'package:get/get.dart';
import 'package:flutter/material.dart';


class DashboardDsn extends StatelessWidget {
const DashboardDsn ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Stack(
        children: [
          // 1. Background Biru Navy bagian atas
          Container(
            height: 240,
            decoration: const BoxDecoration(
              color: Color(0xFF1E3475),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // 2. Konten Utama
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // --- Header: Logo SIPTA & Notifikasi ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Ganti dengan Image.asset jika ada logo putih
                      const Text(
                        'SIPTA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Stack(
                          children: [
                            const Icon(Icons.notifications_none, color: Colors.white, size: 32),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  const Text("Halo Dosen !",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Kelola Progres Tugas Akhir Mahasiswa Disini.",
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  
                  const SizedBox(height: 20),

                  // --- 3. Kartu Profil Dosen ---
                  _buildProfileCard(),

                  const SizedBox(height: 25),

                  // --- 4. Grid Statistik ---
                  Row(
                    children: [
                      Expanded(child: _buildStatCard1()),
                      const SizedBox(width: 15),
                      Expanded(child: _buildStatCard2()),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: _buildStatCard3()),
                      const SizedBox(width: 15),
                      Expanded(child: _buildStatCard4()),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- 5. Jadwal Kegiatan Section ---
                  const Text("Jadwal Kegiatan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildJadwalList(),

                  const SizedBox(height: 30),

                  // --- 6. Aktivitas Terbaru Mahasiswa Section ---
                  const Text("Aktivitas terbaru Mahasiswa", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildAktivitasList(),

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

  // --- WIDGET HELPERS ---

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Arfilal Faiznadi A,md",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 4),
                Text("000283883839", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Kartu 1: Mahasiswa Bimbingan
  Widget _buildStatCard1() {
    return _baseStatCard(
      title: "Mahasiswa Bimbingan",
      subtitle: "jumlah Mahasiswa",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("6", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 40,
            width: 40,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0.75,
                  backgroundColor: Colors.grey.shade300,
                  color: const Color(0xFF2E7D32), // Hijau tua
                  strokeWidth: 4,
                ),
                const Center(child: Text("75%", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Kartu 2: Penilaian Belum Diinput
  Widget _buildStatCard2() {
    return _baseStatCard(
      title: "Penilaian Belum Diinput",
      subtitle: "Jumlah Seminar/Sidang yang belum dinilai",
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Text("12", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
          SizedBox(width: 8),
          Expanded(child: Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text("Seminar belum dinilai", style: TextStyle(fontSize: 10)),
          )),
        ],
      ),
    );
  }

  // Kartu 3: Logbook Baru
  Widget _buildStatCard3() {
    return _baseStatCard(
      title: "Logbook Baru",
      subtitle: "Jumlah catatan Logbook Minggu ini",
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Text("5", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
          SizedBox(width: 8),
          Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text("Logbook baru", style: TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  // Kartu 4: Jadwal Terdekat
  Widget _buildStatCard4() {
    return _baseStatCard(
      title: "Jadwal Terdekat",
      subtitle: "Event terdekat (Bimbingan, Seminar, Sidang)",
      child: const Padding(
        padding: EdgeInsets.only(top: 5),
        child: Text("Sidang TA - 24 Okt 2025", 
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFE65100))),
      ),
    );
  }

  // Base Layout untuk Kartu Statistik
  Widget _baseStatCard({required String title, required String subtitle, required Widget child}) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 9, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
          const Spacer(),
          child,
        ],
      ),
    );
  }

  // List Jadwal Kegiatan
  Widget _buildJadwalList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Header Abu-abu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF9E9E9E), // Abu-abu Header
              borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("jadwal terdekat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text("lihat semua jadwal >", style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          // Body List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildJadwalItem("25\nNov", "Seminar Proposal", "Ruangan : GTIL I.41"),
                      const SizedBox(height: 15),
                      _buildJadwalItem("26\nNov", "Sidang Tugas Akhir", "Ruangan : GTIL I.41"),
                    ],
                  ),
                ),
                // Indikator Scroll (Mockup)
                Container(
                  width: 6,
                  height: 60,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildJadwalItem(String date, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.2)),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black)),
          ],
        )
      ],
    );
  }

  // List Aktivitas Terbaru
  Widget _buildAktivitasList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF9E9E9E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text("Aktivitas Mahasiswa", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Rina : Upload Logbook Bimbingan (20 Oktober)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      SizedBox(height: 10),
                      Text("Dito : Minta Jadwal Bimbingan (Menunggu)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      SizedBox(height: 10),
                      Text("Sari : Revisi Laporan TA Selesai", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
                // Indikator Scroll (Mockup)
                Container(
                  width: 6,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                )
              ],
            ),
          )
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
          Get.toNamed('/tugasAkhirDsn'); 
        } else if (index == 2) {
          Get.toNamed('/jadwalDsn');
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