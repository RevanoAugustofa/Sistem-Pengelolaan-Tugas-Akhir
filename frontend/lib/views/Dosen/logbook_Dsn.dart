import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogbookDosenPage extends StatelessWidget {
  const LogbookDosenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang utama putih
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3475), // Biru Navy
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Logbook",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: Header Info Mahasiswa ---
            Container(
              width: double.infinity,
              color: const Color(0xFFF8F9FB), // Latar belakang abu-abu sangat muda
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoText("nama mahasiswa", "Revano Augustofa"),
                  _buildInfoText("NPM", "230102072"),
                  _buildInfoText("Judul TA", "Sistem Informasi Pengelolaan Tugas Akhir"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4FA5FF), // Biru muda
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: const Text(
                      "Rekomendasikan Sidang TA",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            // --- SECTION 2: Daftar Logbook ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Logbook",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),

                  // Kartu Logbook 1 (Sudah Diperbaiki)
                  _buildCompletedCard(),

                  const SizedBox(height: 15),

                  // Kartu Logbook 2 (Belum ada catatan)
                  _buildPendingCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER: Teks Info Header ---
  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
          children: [
            TextSpan(
              text: "$label : ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  // --- HELPER: Kartu Logbook (Selesai/Diperbaiki) ---
  Widget _buildCompletedCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Revisi 1", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("19 Januari 2026", style: TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 8),
          
          // Status Diperbaiki
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF12B76A), // Hijau
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "Diperbaiki",
                style: TextStyle(color: Color(0xFF12B76A), fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Catatan Pembimbing 1
          const Text("dosen pembimbing 1", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const Text(
            "Bab 1, Latar belakang penggunaan kata asing\nBab 2, -\nBab 3, -",
            style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 12),

          // Catatan Pembimbing 2
          const Text("dosen pembimbing 2", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const Text(
            "Bab 1, Latar belakang penggunaan kata asing\nBab 2, -\nBab 3, -",
            style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 15),

          // Tombol Lihat File
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FA5FF),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text("Lihat file", style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER: Kartu Logbook (Belum ada catatan) ---
  Widget _buildPendingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4), // Warna background abu-abu terang
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Revisi 2", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("27 Januari 2026", style: TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 20),
          
          const Text(
            "belum ada catatan",
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 15),

          // Tombol Tambah (+)
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                // Aksi tambah catatan
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FA5FF), // Biru tombol
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}