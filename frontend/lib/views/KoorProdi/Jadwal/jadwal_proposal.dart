import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/koorprodi_controller.dart';

class ProposalTable extends StatefulWidget {
  const ProposalTable({super.key});

  @override
  State<ProposalTable> createState() => _ProposalTableState();
}

class _ProposalTableState extends State<ProposalTable> {
  final KoorProdiController controller = Get.find<KoorProdiController>();
  final TextEditingController searchController = TextEditingController();
  
  int _rowsPerPage = 5;
  int _currentPage = 0;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingJadwal.value) {
        return const Center(child: CircularProgressIndicator());
      }

      var filteredData = controller.listJadwalProposal.where((item) {
        final query = searchQuery.toLowerCase();
        return (item.mahasiswa?.namaMahasiswa?.toLowerCase().contains(query) ?? false) ||
               (item.mahasiswa?.npm?.toLowerCase().contains(query) ?? false) ||
               (item.ruangan?.namaRuangan?.toLowerCase().contains(query) ?? false);
      }).toList();
      
      int startIndex = _currentPage * _rowsPerPage;
      int endIndex = startIndex + _rowsPerPage;
      if (endIndex > filteredData.length) endIndex = filteredData.length;
      if (startIndex >= filteredData.length && filteredData.isNotEmpty) {
         _currentPage = (filteredData.length / _rowsPerPage).floor();
         startIndex = _currentPage * _rowsPerPage;
         endIndex = filteredData.length;
      }
      
      var displayedData = filteredData.isEmpty ? [] : filteredData.sublist(startIndex, endIndex);

      return RefreshIndicator(
        onRefresh: () async => controller.fetchJadwalProposal(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Search Bar
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      _currentPage = 0;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Cari Jadwal",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    suffixIcon: Icon(Icons.tune, color: Colors.blue),
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 2. Button Import
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/importJadwalProposalKp'),
                  icon: const Icon(Icons.upload_file, color: Colors.white, size: 20),
                  label: const Text(
                    "Import Jadwal Proposal",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Card(
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
                            "Tabel Jadwal",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1E3475)),
                          ),
                          Row(
                            children: [
                              const Text("Show ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(255, 79, 79, 79))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                height: 35,
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
                                        child: Text(value.toString(), style: const TextStyle(fontSize: 14)),                                 
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
                              // const Text("entries", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(255, 79, 79, 79))),
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
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 72),
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
                            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            columnSpacing: 20,
                            horizontalMargin: 15,
                            columns: const [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Mahasiswa')),
                              DataColumn(label: Text('Ruangan')),
                              DataColumn(label: Text('Penguji')),
                              DataColumn(label: Text('Waktu')),
                            ],
                            rows: List.generate(displayedData.length, (index) {
                              var item = displayedData[index];
                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>((states) {
                                  if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                                  return null;
                                }),
                                cells: [
                                  DataCell(Text((startIndex + index + 1).toString())),
                                  DataCell(Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(item.mahasiswa?.namaMahasiswa ?? "-", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      Text(item.mahasiswa?.npm ?? "-", style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                                    ],
                                  )),
                                  DataCell(Text(item.ruangan?.namaRuangan ?? "-")),
                                  DataCell(Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("1: ${item.pengujiUtama?.namaDosen ?? "-"}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                                      Text("2: ${item.pengujiPendamping?.namaDosen ?? "-"}", style: const TextStyle(fontSize: 10, color: Colors.black87)),
                                    ],
                                  )),
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
                            }),
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Showing ${filteredData.isEmpty ? 0 : startIndex + 1} to $endIndex of ${filteredData.length}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color.fromARGB(255, 79, 79, 79)),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                    color: _currentPage > 0 ? Colors.white : Colors.grey.shade100,
                                  ),
                                  child: Text(
                                    "<",
                                    style: TextStyle(
                                      color: _currentPage > 0 ? const Color(0xFF4FA5FF) : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: endIndex < filteredData.length ? () => setState(() => _currentPage++) : null,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                    color: endIndex < filteredData.length ? Colors.white : Colors.grey.shade100,
                                  ),
                                  child: Text(
                                    ">",
                                    style: TextStyle(
                                      color: endIndex < filteredData.length ? const Color(0xFF4FA5FF) : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
