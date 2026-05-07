import 'package:flutter/material.dart';

class JadwalBimbinganDosenTable extends StatelessWidget {
  final String searchQuery;
  const JadwalBimbinganDosenTable({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        columns: const [
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('NPM')),
          DataColumn(label: Text('Jam & Tgl')),
        ],
        rows: List.generate(5, (index) {
          return DataRow(
            color: WidgetStateProperty.resolveWith<Color?>((states) {
              if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
              return null;
            }),
            cells: [
              const DataCell(Text("Mahasiswa Bimbingan")),
              const DataCell(Text("230102071")),
              const DataCell(Text("13:00, 13-03-2026")),
            ],
          );
        }),
      ),
    );
  }
}
