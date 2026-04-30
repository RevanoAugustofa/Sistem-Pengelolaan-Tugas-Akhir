import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailTugasAkhirDosenPage extends StatelessWidget {
  const DetailTugasAkhirDosenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3475), // Biru Navy
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Detail Tugas Akhir",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: Detail Mahasiswa ---
            const Text(
              "Detail Mahasiswa",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3475), // Biru Navy
              ),
            ),
            const SizedBox(height: 15),
            
            _buildInfoRow("NPM", "230102078"),
            _buildInfoRow("Kelas", "TI-3C"),
            _buildInfoRow("Nama", "Revano Augustofa", isBold: true),
            _buildInfoRow("Judul TA", "Sistem Informasi Pengelolaan Tugas Akhir", isUnderline: true, isBold: true),
            
            const SizedBox(height: 20),
            
            // Kartu Pembimbing
            Row(
              children: [
                _buildPembimbingBox("Pembimbing 1", "Alle Danaralle A,MD"),
                const SizedBox(width: 15),
                _buildPembimbingBox("Pembimbing 2", "Alle Danaralle A,MD"),
              ],
            ),

            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade300, thickness: 1),
            const SizedBox(height: 20),

            // --- SECTION 2: Jadwal Sidang TA ---
            _buildJadwalCard(),

            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade300, thickness: 1),
            const SizedBox(height: 20),

            // --- SECTION 3: Penilaian Sidang Tugas Akhir ---
            const Text(
              "Penilaian Sidang Tugas Akhir",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 15),

            // Tombol Lihat File TA (Box)
            InkWell(
              onTap: () {
                // Aksi membuka file
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  // Menggunakan border solid, namun kamu bisa pakai library 'dotted_border' jika butuh putus-putus
                  border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                ),
                child: const Center(
                  child: Text(
                    "lihat file TA",
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Input Nilai Sidang
            const Text("Nilai Sidang Tugas Akhir", style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Masukkan nilai",
                  hintStyle: TextStyle(color: Colors.black87, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Input Catatan Revisi
            const Text("Catatan Revisi", style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Masukkan Catatan Revisi",
                  hintStyle: TextStyle(color: Colors.black87, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- TOMBOL SIMPAN ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B9DFF), // Biru tombol cerah
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "SIMPAN",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- HELPER: Baris Info Mahasiswa ---
  Widget _buildInfoRow(String label, String value, {bool isUnderline = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80, 
            child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87))
          ),
          const Text(" : ", style: TextStyle(fontSize: 13, color: Colors.black87)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER: Kotak Pembimbing ---
  Widget _buildPembimbingBox(String title, String name) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F8FF), // Biru sangat muda
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFB5CFFF)), // Border biru muda
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // --- HELPER: Kartu Jadwal Sidang TA ---
  Widget _buildJadwalCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFB5CFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Biru di Kiri Atas
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF4FA5FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              "Jadwal Sidang TA", // Diubah sesuai gambar
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          
          // Konten Jadwal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Waktu & Tempat
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Jum'at 20, Februari 2026",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7E89AC), // Warna abu/biru badge
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "08.30.00 - 09.45.00 WIB",
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Lab. Jaringan",
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                
                // Info Penguji
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Penguji 1", style: TextStyle(fontSize: 11, color: Color(0xFF1E3475), fontWeight: FontWeight.bold)),
                      const Text("Arfilal Faiznadi S,Pd", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 10),
                      const Text("Penguji 2", style: TextStyle(fontSize: 11, color: Color(0xFF1E3475), fontWeight: FontWeight.bold)),
                      const Text("Arfilal Faiznadi S,Pd", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}