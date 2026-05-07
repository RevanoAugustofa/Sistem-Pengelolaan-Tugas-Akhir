import 'package:flutter/material.dart';

class TugasAkhirSidangTable extends StatelessWidget {
  final String searchQuery;
  const TugasAkhirSidangTable({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Penguji')),
          DataColumn(label: Text('Tanggal')),
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
              const DataCell(Text("Dr. Dosen")),
              const DataCell(Text("20-03-2026")),
            ],
          );
        }),
      ),
    );
  }
}
