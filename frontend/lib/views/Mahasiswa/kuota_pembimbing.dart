import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KuotaPembimbing extends StatelessWidget {
  const KuotaPembimbing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Kuota Pembimbing",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sisa kuota Dosen Pembimbing Tugas Akhir",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            
            // Tombol Kuning Highlight
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE047), // Warna Kuning sesuai desain
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: const Text(
                "Daftar Dosen\nPembimbing",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 25),

            // Header Tabel
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color(0xFFD1D5DB), // Abu-abu Header
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 1, child: Text("No", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 3, child: Text("Nama", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text("Pem 1", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text("Pem 2", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),

            // Baris Data Tabel
            _buildTableRow("1", "nama dsn", "8", "9", isAlternate: false),
            _buildTableRow("2", "nama dsn", "8", "9", isAlternate: true),
            _buildTableRow("3", "nama dsn", "8", "9", isAlternate: false),
            _buildTableRow("4", "nama dsn", "8", "9", isAlternate: true),
            _buildTableRow("5", "nama dsn", "8", "9", isAlternate: false),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(String no, String nama, String pem1, String pem2, {bool isAlternate = false}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isAlternate ? const Color(0xFFF3F4F6) : Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(no)),
          Expanded(flex: 3, child: Text(nama)),
          Expanded(flex: 2, child: Text(pem1, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(pem2, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}