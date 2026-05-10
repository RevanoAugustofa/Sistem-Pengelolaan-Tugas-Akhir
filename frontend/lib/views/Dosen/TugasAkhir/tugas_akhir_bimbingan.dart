import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TugasAkhirBimbinganTable extends StatelessWidget {
  final String searchQuery;
  const TugasAkhirBimbinganTable({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sidang TA",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // --- Daftar Card Logbook ---
          // Kamu bisa menggunakan ListView.builder jika datanya dinamis dari API.
          // Di sini saya mencontohkan dua card sesuai desain.
          _buildLogbookCard(
            tanggal: "18 Agustus 2026",
            // Card pertama: contoh ketika belum ada catatan dosen
            catatanMahasiswa: null,
          ),

          const SizedBox(height: 16),

          _buildLogbookCard(
            tanggal: "18 Agustus 2026",
            // Card kedua: contoh ketika sudah ada catatan/progress mahasiswa
            catatanMahasiswa:
                "Mahasiswa telah menyelesaikan revisi Bab 1 dan Bab 2 sesuai arahan dosen. Dokumen telah diunggah dan menunggu verifikasi.",
          ),

          const SizedBox(height: 30),

          // --- Tombol Rekomendasikan Sidang ---
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Logika untuk merekomendasikan sidang
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color(0xFF2196F3),
                ), // Warna biru garis tepi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Rekomendasikan Sidang TA",
                style: TextStyle(
                  color: Color(0xFF2196F3), // Warna teks biru
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20), // Spasi bawah
        ],
      ),
    );
  }

  // --- WIDGET HELPER: Card Logbook ---
  Widget _buildLogbookCard({
    required String tanggal,
    String? catatanMahasiswa,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Abu-abu (Tanggal & Tombol Lihat File)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tanggal,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Logika lihat file
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A89F3), // Biru tombol
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      "Lihat File",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Area Konten / Catatan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildLogbookContent(catatanMahasiswa),
          ),
        ],
      ),
    );
  }

  // Menentukan apa yang tampil di dalam card berdasarkan ada/tidaknya catatan
  Widget _buildLogbookContent(String? catatan) {
    if (catatan == null || catatan.isEmpty) {
      // Jika tidak ada catatan, tampilkan tombol "+ Tambah Catatan" hijau
      return Center(
        child: ElevatedButton.icon(
          onPressed: () {
            // TODO: Logika buka form tambah catatan
          },
          icon: const Icon(Icons.add, size: 16, color: Colors.white),
          label: const Text("Tambah Catatan"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6CBE71), // Warna hijau tombol
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );
    } else {
      // Jika ada catatan, tampilkan teks catatannya (italic)
      return Text(
        catatan,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey.shade800,
          fontSize: 13,
          height: 1.4,
        ),
      );
    }
  }
}
