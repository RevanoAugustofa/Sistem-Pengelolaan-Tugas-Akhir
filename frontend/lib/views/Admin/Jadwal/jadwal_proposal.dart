import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/jadwal_model.dart';

class JadwalProposalAdminTable extends StatefulWidget {
  final String searchQuery;
  const JadwalProposalAdminTable({super.key, required this.searchQuery});

  @override
  State<JadwalProposalAdminTable> createState() => _JadwalProposalAdminTableState();
}

class _JadwalProposalAdminTableState extends State<JadwalProposalAdminTable> {
  final AdminController controller = Get.find<AdminController>();
  
  int _rowsPerPage = 5;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingJadwal.value) {
        return const Center(child: CircularProgressIndicator());
      }

      var filteredData = controller.listJadwalProposal.where((item) {
        final query = widget.searchQuery.toLowerCase();
        return (item.mahasiswa?.namaMahasiswa?.toLowerCase().contains(query) ?? false) ||
               (item.mahasiswa?.npm?.toLowerCase().contains(query) ?? false) ||
               (item.ruangan?.namaRuangan?.toLowerCase().contains(query) ?? false);
      }).toList();
      
      int startIndex = _currentPage * _rowsPerPage;
      int endIndex = startIndex + _rowsPerPage;
      if (endIndex > filteredData.length) endIndex = filteredData.length;
      
      List<JadwalModel> displayedData = filteredData.isEmpty ? [] : filteredData.sublist(startIndex, endIndex);

      return RefreshIndicator(
        onRefresh: () async => controller.fetchJadwal(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tabel Jadwal Proposal",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3475)),
                      ),
                      Row(
                        children: [
                          const Text("Show ", style: TextStyle(fontSize: 12)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _rowsPerPage,
                                items: [5, 10, 25, 50].map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString(), style: const TextStyle(fontSize: 12)),                                 
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _rowsPerPage = value!;
                                    _currentPage = 0;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (filteredData.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Belum ada jadwal proposal", style: TextStyle(color: Colors.grey)),
                    ),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
                      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                      columns: const [
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Ruangan')),
                        DataColumn(label: Text('Waktu')),
                        DataColumn(label: Text('Penguji')),
                      ],
                      rows: List.generate(displayedData.length, (index) {
                        var item = displayedData[index];
                        return DataRow(
                          color: WidgetStateProperty.resolveWith<Color?>((states) {
                            if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                            return null;
                          }),
                          cells: [
                            DataCell(Text((startIndex + index + 1).toString(), style: const TextStyle(fontSize: 11))),
                            DataCell(Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item.mahasiswa?.namaMahasiswa ?? "-", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                Text(item.mahasiswa?.npm ?? "-", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            )),
                            DataCell(Text(item.ruangan?.namaRuangan ?? "-", style: const TextStyle(fontSize: 11))),
                            DataCell(Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item.tanggal ?? "-", style: const TextStyle(fontSize: 11)),
                                Text("${item.waktuMulai ?? ''} - ${item.waktuSelesai ?? ''}", 
                                     style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
                              ],
                            )),
                            DataCell(Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("1: ${item.pengujiUtama?.namaDosen ?? "-"}", style: const TextStyle(fontSize: 10)),
                                Text("2: ${item.pengujiPendamping?.namaDosen ?? "-"}", style: const TextStyle(fontSize: 9, color: Colors.black54)),
                              ],
                            )),
                          ],
                        );
                      }),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Showing ${filteredData.isEmpty ? 0 : startIndex + 1} to $endIndex of ${filteredData.length}",
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, size: 20),
                            onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                          ),
                          Text("${_currentPage + 1}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, size: 20),
                            onPressed: endIndex < filteredData.length ? () => setState(() => _currentPage++) : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
