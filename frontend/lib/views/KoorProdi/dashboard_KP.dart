import 'package:get/get.dart';
import 'package:flutter/material.dart';


class DashboardKp extends StatelessWidget {
 DashboardKp ({super.key});
 
 final List<Map<String, dynamic>> menuItems = [
    {"label": "Mahasiswa", "color": Color.fromARGB(255, 255, 255, 255)},
    {"label": "Dosen", "color": Color.fromARGB(255, 255, 254, 254)},
    {"label": "Rubrik Nilai", "color": Color.fromARGB(255, 255, 255, 255)},
    {"label": "Jadwal", "color": Color.fromARGB(255, 255, 255, 255)},
    {"label": "Logbook Bimbingan", "color": Color.fromARGB(255, 255, 255, 255)},
    {"label": "Validasi Pembimbing", "color": Color.fromARGB(255, 255, 255, 255)},
    {"label": "Hasil Akhir", "color": Color.fromARGB(255, 255, 255, 255)},
    {"label": "Lainnya", "color": Color.fromARGB(255, 255, 255, 255)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER ==========================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF233B7A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SIPTA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Halo Koor Prodi !",
                    style: TextStyle(color: Colors.white),
                  ),
                  const Text(
                    "Kelola Data Mahasiswa dan Dosen Disini.",
                    style: TextStyle(color: Colors.white, fontSize: 11,),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_none,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CARD PROFILE ======================================
            GestureDetector(
              onTap: () => Get.toNamed('/profil', arguments: {'activeRole': 'koorprodi'}),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Alle danaralle A,md",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "000000000839",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // GRID MENU ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  ...menuItems.map((item) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 85) / 4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 73,
                            decoration: BoxDecoration(
                              color: item["color"],
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item["label"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CARD REKAP VERIFIKASI ===============================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 98, 184, 254),          // background
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Rekap Verifikasi Pembimbing Mahasiswa",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,       // warna teks
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ANGKA 12 - 12
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Column(
                        children: [
                          Text("12",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
                          Text("Belum Terverifikasi", style: TextStyle(fontSize: 10),),
                        ],
                      ),
                      Column(
                        children: [
                          Text("12",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                          Text("Sudah Terverifikasi", style: TextStyle(fontSize: 10),),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // BUTTON LAINNYA
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: const Text("Lainnya →"),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CHART BOX (KOSONG)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Tempat Grafik Progress Seminar Proposal & Sidang TA\n"
                    "per Angkatan/Tahun.\n\n"
                    "- X-axis: Angkatan\n"
                    "- Y-axis: Jumlah Mahasiswa\n\n"
                    "• Belum sidang proposal\n"
                    "• Proposal sedang dilaporkan / revisi\n"
                    "• Sudah lulus seminar proposal\n"
                    "• Sedang bimbingan TA\n"
                    "• Sudah daftar sidang\n"
                    "• Sudah lulus sidang (wisuda)",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

 