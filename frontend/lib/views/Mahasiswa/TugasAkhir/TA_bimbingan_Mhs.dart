import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller untuk mengatur perpindahan tab
class TugasAkhirController extends GetxController {
  var selectedTab = 0.obs; // 0: Proposal, 1: Bimbingan, 2: Sidang
}

class TaBimbinganMhs extends StatelessWidget {
  const TaBimbinganMhs({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final controller = Get.put(TugasAkhirController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Tugas Akhir", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF283D70),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 1. Tab Navigation (Toggle Button)
          Obx(() => Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF8E99BA),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildTabItem("Proposal", 0, controller),
                _buildTabItem("Bimbingan", 1, controller),
                _buildTabItem("Sidang", 2, controller),
              ],
            ),
          )),

          // 2. Konten Dinamis berdasarkan Tab yang dipilih
          Expanded(
            child: Obx(() {
              switch (controller.selectedTab.value) {
                case 0:
                  return _buildProposalView();
                case 1:
                  return _buildBimbinganView();
                case 2:
                  return const Center(child: Text("Halaman Sidang Belum Tersedia"));
                default:
                  return const SizedBox();
              }
            }),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- HELPER: TAB ITEM ---
  Widget _buildTabItem(String title, int index, TugasAkhirController controller) {
    bool isActive = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedTab.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF283D70) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // --- VIEW: PROPOSAL (Gambar 2 & 3) ---
  Widget _buildProposalView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Proposal Tugas Akhir", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("Kelola dokumen proposal, lihat catatan revisi dan status persetujuan", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          _buildStatusCard(),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: _buildBlueButton("Unggah")),
          const SizedBox(height: 24),
          const Text("Catatan Revisi Seminar Proposal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildRevisionItem("Bab 1, Rumusan Masalah dipertegas.", "Arfilal Faiznadi, Amd."),
          _buildRevisionItem("Bab 2, Rumusan Masalah dipertegas.", "Arfilal Faiznadi, Amd."),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: _buildBlueButton("Unggah")),
          const SizedBox(height: 24),
          const Text("Berita Acara", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Center(child: Text("Berita Acara Seminar Proposal - 15 Desember 2025", style: TextStyle(fontSize: 12))),
          const SizedBox(height: 12),
          _buildBeritaAcaraPreview(),
          const SizedBox(height: 12),
          _buildOutlineButton("Unduh Dokumen"),
        ],
      ),
    );
  }

  // --- VIEW: BIMBINGAN (Gambar 4, 5, 6) ---
  Widget _buildBimbinganView() {
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

  // --- UI COMPONENTS ---
  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFE8E8E8), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
      child: const Column(
        children: [
          _StatusRow("Unggah Proposal", "Belum"),
          Divider(),
          _StatusRow("Tinjau Dosen", "Menunggu"),
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

  Widget _buildBeritaAcaraPreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: const Center(child: Icon(Icons.article_outlined, size: 100, color: Colors.grey)),
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

  Widget _buildBlueButton(String text) => ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A89FF)), child: Text(text, style: const TextStyle(color: Colors.white)));
  Widget _buildFullBlueButton(String text) => SizedBox(width: double.infinity, child: _buildBlueButton(text));
  Widget _buildOutlineButton(String text) => SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () {}, child: Text(text, style: const TextStyle(color: Colors.black54))));
  Widget _buildRevisionItem(String t, String d) => ListTile(title: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), subtitle: Text("Dosen: $d", style: const TextStyle(fontSize: 11)), trailing: const Text("Belum", style: TextStyle(color: Colors.red, fontSize: 10)));
  
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      selectedItemColor: const Color(0xFF283D70),
      onTap: (i) { if(i==0) Get.toNamed('/dashboardMhs'); },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "Tugas Akhir"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Jadwal"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
      ],
    );
  }
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