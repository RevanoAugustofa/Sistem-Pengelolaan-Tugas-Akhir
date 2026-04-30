import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProposalMhs extends StatelessWidget {
  const ProposalMhs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Proposal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Kartu Ringkasan Pengajuan
            _buildSummaryCard(),
            const SizedBox(height: 30),

            // 2. Judul Section
            const Text(
              "Catatan Revisi Proposal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // 3. Daftar Revisi
            _buildRevisionCard(
              title: "Revisi 1",
              date: "19 Januari 2026",
              isDone: true,
              showUploadBtn: false,
            ),
            const SizedBox(height: 15),
            _buildRevisionCard(
              title: "Revisi 2",
              date: "27 Januari 2026",
              isDone: false,
              showUploadBtn: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildInfoRow("tanggal pengajuan", "jumat 23 januari 2026"),
          const SizedBox(height: 12),
          _buildInfoRow("Nama Mahasiswa", "Revano"),
          const SizedBox(height: 12),
          _buildInfoRow("Judul TA", "Sistem informasi tugas akhir berbasis mobile"),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A89FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("file", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.black))),
      ],
    );
  }

  Widget _buildRevisionCard({
    required String title,
    required String date,
    required bool isDone,
    required bool showUploadBtn,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: isDone ? Colors.green : Colors.red),
              const SizedBox(width: 8),
              Text(
                isDone ? "Diperbaiki" : "Belum diperbaiki",
                style: TextStyle(color: isDone ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildDosenRevision("dosen pembimbing 1"),
          const SizedBox(height: 10),
          _buildDosenRevision("dosen pembimbing 2"),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A89FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                showUploadBtn ? "unggah perbaikan" : "Lihat file",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDosenRevision(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const Text("Bab 1, Latar belakang penggunaan kata asing", style: TextStyle(fontSize: 12)),
        const Text("Bab 2, -", style: TextStyle(fontSize: 12)),
        const Text("Bab 3, -", style: TextStyle(fontSize: 12)),
      ],
    );
  }
}