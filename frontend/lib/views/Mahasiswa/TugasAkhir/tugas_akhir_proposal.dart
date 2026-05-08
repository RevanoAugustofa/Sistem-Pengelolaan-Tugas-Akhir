import 'package:flutter/material.dart';

class TugasAkhirProposalMhsView extends StatelessWidget {
  const TugasAkhirProposalMhsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Proposal Tugas Akhir", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Text("Kelola dokumen proposal, lihat catatan revisi dan status persetujuan", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          _buildStatusCard(),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: _buildBlueButton("Unggah")),
          const SizedBox(height: 24),
          const Text("Catatan Revisi Sempro", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("12 januari 2026", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          _buildRevisionItem("Bab 1, Rumusan Masalah dipertegas.", "Arfilal Faiznadi, Amd."),
          _buildRevisionItem("Bab 2, Rumusan Masalah dipertegas.", "Arfilal Faiznadi, Amd."),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: _buildBlueButton("Unggah")),
          const SizedBox(height: 24),
          const Text("Berita Acara", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Center(child: Text("Berita Acara Seminar Proposal - 15 Desember 2025", style: TextStyle(fontSize: 12))),
          const SizedBox(height: 12),
          _buildBeritaAcaraPreview(),
          const SizedBox(height: 12),
          _buildOutlineButton("Unduh Dokumen"),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFE8E8E8), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
      child: const Column(
        children: [
          _StatusRow("Unggah Proposal", "Belum"),
        ],
      ),
    );
  }

  Widget _buildBeritaAcaraPreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: const Center(child: Icon(Icons.article_outlined, size: 100, color: Colors.grey)),
    );
  }

  Widget _buildBlueButton(String text) => ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A89FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)), child: Text(text, style: const TextStyle(color: Colors.white)));
  Widget _buildOutlineButton(String text) => SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () {}, child: Text(text, style: const TextStyle(color: Colors.black54))));
  Widget _buildRevisionItem(String t, String d) => ListTile(title: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), subtitle: Text("Dosen: $d", style: const TextStyle(fontSize: 11)), trailing: const Text("Belum", style: TextStyle(color: Colors.red, fontSize: 10)));
}

class _StatusRow extends StatelessWidget {
  final String label, status;
  const _StatusRow(this.label, this.status);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(8)), child: Text(status, style: const TextStyle(fontSize: 11))),
      ],
    );
  }
}
