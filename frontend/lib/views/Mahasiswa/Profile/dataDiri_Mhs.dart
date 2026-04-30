import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataDiriPage extends StatelessWidget {
  const DataDiriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "DATA DIRI",
          style: TextStyle(color: Color(0xFF283D70), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF283D70)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // 1. Foto Profil dengan Tombol Edit
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 70, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4A89FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. Form Data Diri
            _buildDataField("Nama Mahasiswa", "Revano Augustofa"),
            _buildDataField("NIM", "2011"),
            _buildDataField("Tanggal Lahir", "1 Mei 2004"),
            _buildDataField("Tempat Lahir", "Cilacap"),
            _buildDataField("Program Studi", "D3 Teknik Informatika"),

            const SizedBox(height: 15),
            const Text("Jenis Kelamin", style: TextStyle(color: Colors.black87, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildRadioOption("Laki-laki", true),
                const SizedBox(width: 20),
                _buildRadioOption("Perempuan", false),
              ],
            ),
            const SizedBox(height: 15),

            _buildDataField("Tahun Ajaran", "2023/2024"),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat input field statis (Read-only)
  Widget _buildDataField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk Radio Button Jenis Kelamin
  Widget _buildRadioOption(String label, bool isSelected) {
    return Row(
      children: [
        Icon(
          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: isSelected ? const Color(0xFF283D70) : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}