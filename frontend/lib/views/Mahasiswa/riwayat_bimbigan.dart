import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RiwayatBimbingan extends StatelessWidget {
  const RiwayatBimbingan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Riwayat Bimbingan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF283D70),
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
            // 1. Kartu Total Bimbingan (Dosen 1 & 2)
            Row(
              children: [
                Expanded(child: _buildTotalCard("nama dosen pembimbing 1", "2")),
                const SizedBox(width: 15),
                Expanded(child: _buildTotalCard("nama dosen pembimbing 2", "2")),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Daftar Riwayat Pendaftaran
            _buildRiwayatItem("nama dosen pembimbing 1", "Jum'at 20, Februari 2026", "08.02.00 WIB"),
            _buildRiwayatItem("nama dosen pembimbing 2", "Jum'at 20, Februari 2026", "08.02.00 WIB"),
            _buildRiwayatItem("nama dosen pembimbig 1", "Jum'at 20, Februari 2026", "08.02.00 WIB"),
            _buildRiwayatItem("nama dosen pembimbing 2", "Jum'at 20, Februari 2026", "08.02.00 WIB"),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard(String label, String count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          const Text("total bimbigan", style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatItem(String dosen, String tanggal, String jam) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dosen,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(tanggal, style: const TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ADE80), // Warna Hijau Terdaftar
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Terdaftar",
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Text(jam, style: const TextStyle(fontSize: 11, color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }
}