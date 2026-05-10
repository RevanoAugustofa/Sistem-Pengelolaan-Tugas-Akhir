import 'package:flutter/material.dart';

class TugasAkhirSidangTable extends StatelessWidget {
  final String searchQuery;
  const TugasAkhirSidangTable({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. CARD JADWAL Sidang TA
          _buildJadwalCard(),
          
          const SizedBox(height: 24),
          const Divider(thickness: 1, color: Colors.grey), // Garis pembatas abu-abu
          const SizedBox(height: 20),

          // 2. BAGIAN PENILAIAN Sidang TA
          const Text(
            "Penilaian Sidang TA",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),

          // Tombol Lihat File TA (Dashed Border)
          _buildDashedButton("lihat file TA"),
          
          const SizedBox(height: 20),

          // Input Field: Nilai Sidang TA
          const Text(
            "Nilai Sidang TA",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildTextField("Masukkan nilai"),

          const SizedBox(height: 20),

          // Input Field: Catatan Revisi
          const Text(
            "Catatan Revisi",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildTextField("Masukkan Catatan Revisi", maxLines: 5),

          const SizedBox(height: 30),

          // Tombol Simpan
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Tambahkan logika simpan di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3), // Biru Primary
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                "SIMPAN",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
            ),
          ),
          
          const SizedBox(height: 20), // Spasi bawah
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  // Card Jadwal
  Widget _buildJadwalCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FF), // Warna latar biru sangat pucat
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Biru Gelap
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF0056A8), // Biru Gelap
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8), // Disesuaikan dengan desain, ada versi yang asimetris
              ),
            ),
            child: const Text(
              "Jadwal Sidang TA",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          // Isi Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kolom Kiri: Waktu & Tempat
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Jum'at 20, Februari 2026",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      // Badge Jam
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C7A89), // Abu-abu kebiruan
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "08.30.00 - 09.45.00 WIB",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Lab. Jaringan",
                        style: TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                // Kolom Kanan: Penguji
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPengujiInfo("Penguji 1", "Arfilal Faiznadi S,Pd"),
                      const SizedBox(height: 12),
                      _buildPengujiInfo("Penguji 2", "Arfilal Faiznadi S,Pd"),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPengujiInfo(String label, String nama) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF0056A8), fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          nama,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }

  // Tombol Lihat File TA (Garis Putus-putus)
  // Karena Flutter tidak punya native dashed border untuk Container,
  // kita gunakan CustomPaint sederhana atau bisa juga pakai package 'dotted_border'
  // Di sini saya pakai style sederhana yang mirip.
  Widget _buildDashedButton(String text) {
    return InkWell(
      onTap: () {
        // TODO: Logika buka file TA
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          // Menggunakan solid border sementara. Jika HARUS dashed, disarankan install package 'dotted_border'
          border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid), 
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
      ),
    );
  }

  // Text Field Generic
  Widget _buildTextField(String hintText, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}