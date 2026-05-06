import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProposalTable extends StatelessWidget {
  const ProposalTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed('/importJadwalProposalKp'),
              icon: const Icon(Icons.upload_file, color: Colors.white, size: 20),
              label: const Text(
                "Import Jadwal Proposal",
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor:
                  WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
              headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              columns: const [
                DataColumn(label: Text('No')),
                DataColumn(label: Text('Nama')),
                DataColumn(label: Text('Judul Proposal')),
                DataColumn(label: Text('Ruangan')),
              ],
              rows: List.generate(5, (index) {
                return DataRow(
                  color: WidgetStateProperty.resolveWith<Color?>((states) {
                    if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                    return null;
                  }),
                  cells: [
                    DataCell(Text("${index + 1}")),
                    const DataCell(Text("Mahasiswa")),
                    const DataCell(Text("Sistem Informasi Akademik")),
                    const DataCell(Text("Lab Komputer")),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
