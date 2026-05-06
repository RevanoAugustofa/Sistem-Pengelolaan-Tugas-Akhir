import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/koorprodi_controller.dart';

class SidangTable extends StatelessWidget {
  const SidangTable({super.key});

  @override
  Widget build(BuildContext context) {
    final KoorProdiController controller = Get.find<KoorProdiController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                // Logika navigasi ke halaman import sidang
              },
              icon: const Icon(Icons.upload_file, color: Colors.white, size: 20),
              label: const Text(
                "Import Jadwal Sidang",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingJadwal.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.listJadwalSidang.isEmpty) {
              return const Center(
                child: Text("Belum ada jadwal sidang", style: TextStyle(color: Colors.grey)),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                columns: const [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Nama')),
                  DataColumn(label: Text('Penguji')),
                  DataColumn(label: Text('Ruangan')),
                  DataColumn(label: Text('Waktu')),
                ],
                rows: controller.listJadwalSidang.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color?>((states) {
                      if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                      return null;
                    }),
                    cells: [
                      DataCell(Text("${index + 1}")),
                      DataCell(Text(item.mahasiswa?.namaMahasiswa ?? "-")),
                      DataCell(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("U: ${item.pengujiUtama?.namaDosen ?? "-"}", style: const TextStyle(fontSize: 11)),
                          Text("P: ${item.pengujiPendamping?.namaDosen ?? "-"}", style: const TextStyle(fontSize: 10, color: Colors.black54)),
                        ],
                      )),
                      DataCell(Text(item.ruangan?.namaRuangan ?? "-")),
                      DataCell(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.tanggal ?? "-", style: const TextStyle(fontSize: 11)),
                          Text("${item.waktuMulai} - ${item.waktuSelesai}", 
                               style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              ),
            );
          }),
        ),
      ],
    );
  }
}
