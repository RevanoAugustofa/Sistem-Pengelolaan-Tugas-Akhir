import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/mhs_controller.dart';

class JadwalSemproList extends StatelessWidget {
  final String searchQuery;
  const JadwalSemproList({super.key, this.searchQuery = ""});

  @override
  Widget build(BuildContext context) {
    final MhsController controller = Get.find<MhsController>();

    return Obx(() {
      if (controller.isLoadingJadwalSempro.value) {
        return const Center(child: CircularProgressIndicator());
      }

      var filteredList = controller.listJadwalSempro.where((jadwal) {
        return (jadwal.mahasiswa?.namaMahasiswa ?? "")
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();

      if (filteredList.isEmpty) {
        return const Center(child: Text("Belum ada jadwal sempro"));
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final jadwal = filteredList[index];
          String nama = jadwal.mahasiswa?.namaMahasiswa ?? "Tidak ada nama";
          String tanggal = jadwal.tanggal ?? "-";
          String jam = "${jadwal.waktuMulai ?? ''} - ${jadwal.waktuSelesai ?? ''} WIB";
          
          return _buildJadwalCard(nama, tanggal, jam);
        },
      );
    });
  }

  Widget _buildJadwalCard(String nama, String tanggal, String jam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nama,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF283D70), fontSize: 15),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
              Text(tanggal, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
              Text(jam, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
