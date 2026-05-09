import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/dosen_controller.dart';

class JadwalBimbinganDosenTable extends StatelessWidget {
  final String searchQuery;
  const JadwalBimbinganDosenTable({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final DosenController controller = Get.find<DosenController>();

    return Obx(() {
      if (controller.isLoadingJadwal.value) {
        return const Center(child: CircularProgressIndicator());
      }

      var filteredData = controller.listJadwalBimbingan.where((item) {
        final query = searchQuery.toLowerCase();
        return (item.tempatLink?.toLowerCase().contains(query) ?? false) ||
               (item.metodeBimbingan?.toLowerCase().contains(query) ?? false) ||
               (item.status?.toLowerCase().contains(query) ?? false);
      }).toList();

      return RefreshIndicator(
        onRefresh: () async => controller.fetchJadwalBimbingan(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Button Tambah Jadwal
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/createJadwalBimbinganDsn'),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Tambah Jadwal",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              if (filteredData.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Belum ada jadwal bimbingan", style: TextStyle(color: Colors.grey)),
                  ),
                )
              else
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
                      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      columns: const [
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Metode')),
                        DataColumn(label: Text('Tempat / Link')),
                        DataColumn(label: Text('Kuota')),
                        DataColumn(label: Text('Waktu')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: List.generate(filteredData.length, (index) {
                        var item = filteredData[index];
                        return DataRow(
                          color: WidgetStateProperty.resolveWith<Color?>((states) {
                            if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                            return null;
                          }),
                          cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: item.metodeBimbingan == 'online' ? Colors.blue.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.metodeBimbingan?.toUpperCase() ?? "-",
                                style: TextStyle(
                                  fontSize: 10, 
                                  fontWeight: FontWeight.bold,
                                  color: item.metodeBimbingan == 'online' ? Colors.blue : Colors.orange,
                                ),
                              ),
                            )),
                            DataCell(SizedBox(
                              width: 150,
                              child: Text(
                                item.tempatLink ?? "-",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11),
                              ),
                            )),
                            DataCell(Text(item.kuota.toString())),
                            DataCell(Text(
                              item.waktuTanggal != null 
                                ? DateFormat('HH:mm, dd-MM-yyyy').format(DateTime.parse(item.waktuTanggal!))
                                : "-",
                              style: const TextStyle(fontSize: 11),
                            )),
                            DataCell(Text(
                              item.status ?? "-",
                              style: TextStyle(
                                color: item.status == 'tersedia' ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            )),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
