import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PembimbingPage extends StatelessWidget {
  const PembimbingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Pembimbing",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF283D70), // Biru Navy PNC
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. Banner Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFC0D9F9), // Biru Muda Header
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Pembimbing Tugas Akhir",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Kartu Detail Pembimbing & Judul
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDosenRow("Revano Augustofa , Amd", "NIP. 9328494004930999", "Pembimbing 1"),
                  const Divider(height: 30),
                  _buildDosenRow("Arfilal Faiznadi , Amd", "NIP. 9328494004930999", "Pembimbing 2"),
                  const Divider(height: 30),
                  
                  // Bagian Judul TA
                  const Text(
                    "Judul Tugas Akhir",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "\"Sistem Informasi Pengelolaan Tugas Akhir\"", // Menyesuaikan judul proyekmu
                    style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDosenRow(String nama, String nip, String peran) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                nip,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        ),
        Text(
          peran,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}