import 'package:flutter/material.dart';

class TugasAkhirBimbinganMhsView extends StatelessWidget {
  const TugasAkhirBimbinganMhsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFFFF9C4), borderRadius: BorderRadius.circular(10)),
            child: const Text("Ajukan Dosen Pembimbing !", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          const Text("Jadwal Bimbingan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _buildJadwalBimbinganCard(),
          const SizedBox(height: 24),
          const Text("Logbook Bimbingan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDosenTag("Pembimbing Utama", "Revano Augustofa, Amd")),
              const SizedBox(width: 8),
              Expanded(child: _buildDosenTag("Pembimbing Pendamping", "Arfilal Faiznadi, Amd")),
            ],
          ),
          const SizedBox(height: 16),
          _buildLogbookTable(),
          const SizedBox(height: 16),
          _buildFullBlueButton("Tambah Logbook"),
        ],
      ),
    );
  }

  Widget _buildJadwalBimbinganCard() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Arfilal Faiznadi S,Pd", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
              Text("Jum'at 20, Februari 2026  08.02.00 WIB", style: TextStyle(fontSize: 11)),
              Text("Kuota tersisa (4)", style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF42A5F5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text("Daftar", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildLogbookTable() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF1F1F1), borderRadius: BorderRadius.circular(10)),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Tanggal", style: TextStyle(fontSize: 12)), Text("Permasalahan", style: TextStyle(fontSize: 12)), Text("File", style: TextStyle(fontSize: 12))],
          ),
          SizedBox(height: 20),
          Text("Ketika di klik maka akan muncul modal detail Logbook", textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildDosenTag(String role, String name) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFBDC3C7), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(role, style: const TextStyle(fontSize: 10, color: Colors.white)),
          Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildBlueButton(String text) => ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A89FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)), child: Text(text, style: const TextStyle(color: Colors.white)));
  Widget _buildFullBlueButton(String text) => SizedBox(width: double.infinity, child: _buildBlueButton(text));
}
