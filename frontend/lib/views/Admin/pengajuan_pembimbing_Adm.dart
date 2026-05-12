import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../models/pengajuan_pembimbing_model.dart';

class PengajuanPembimbingAdminPage extends StatefulWidget {
  const PengajuanPembimbingAdminPage({super.key});

  @override
  State<PengajuanPembimbingAdminPage> createState() => _PengajuanPembimbingAdminPageState();
}

class _PengajuanPembimbingAdminPageState extends State<PengajuanPembimbingAdminPage> {
  final AdminController controller = Get.put(AdminController());
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  int _rowsPerPage = 5;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Pengajuan Pembimbing",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingPengajuanPembimbing.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredData = controller.listPengajuanPembimbing.where((item) {
          final query = searchQuery.toLowerCase();
          return (item.mahasiswa?.namaMahasiswa?.toLowerCase().contains(query) ?? false) ||
                 (item.mahasiswa?.npm?.toLowerCase().contains(query) ?? false) ||
                 (item.mahasiswa?.prodi?.toLowerCase().contains(query) ?? false) ||
                 (item.judulTa?.toLowerCase().contains(query) ?? false);
        }).toList();

        int startIndex = _currentPage * _rowsPerPage;
        int endIndex = startIndex + _rowsPerPage;
        if (endIndex > filteredData.length) endIndex = filteredData.length;
        
        List<PengajuanPembimbingModel> displayedData = filteredData.isEmpty ? [] : filteredData.sublist(startIndex, endIndex);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
                    hintText: "Cari Mahasiswa / Judul",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    suffixIcon: Icon(Icons.tune, color: Colors.blue),
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Table Card ---
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
                            "Data Pengajuan",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1E3475)),
                          ),
                          Row(
                            children: [
                              const Text("Show ", style: TextStyle(fontSize: 14)),
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
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (filteredData.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("Tidak ada data pengajuan", style: TextStyle(color: Colors.grey)),
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
                              DataColumn(label: Text('Prodi')),
                              DataColumn(label: Text('Judul')),
                              DataColumn(label: Text('Pembimbing')),
                              DataColumn(label: Text('Status')),
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
                                      Text(item.mahasiswa?.namaMahasiswa ?? "-", style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text(item.mahasiswa?.npm ?? "-", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ],
                                  )),
                                  DataCell(Text(item.mahasiswa?.prodi ?? "-")),
                                  DataCell(SizedBox(
                                    width: 150,
                                    child: Text(item.judulTa ?? "-", overflow: TextOverflow.ellipsis),
                                  )),
                                  DataCell(Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("1: ${item.pembimbingUtama?.namaDosen ?? "-"}", style: const TextStyle(fontSize: 11)),
                                      Text("2: ${item.pembimbingPendamping?.namaDosen ?? "-"}", style: const TextStyle(fontSize: 11)),
                                    ],
                                  )),
                                  DataCell(Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (item.status == 'disetujui' ? Colors.green : (item.status == 'diajukan' ? Colors.orange : Colors.red)).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item.status?.toUpperCase() ?? "-",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: item.status == 'disetujui' ? Colors.green : (item.status == 'diajukan' ? Colors.orange : Colors.red),
                                      ),
                                    ),
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
                            "Showing ${filteredData.isEmpty ? 0 : startIndex + 1} to $endIndex of ${filteredData.length} entries",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                              ),
                              Text("${_currentPage + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
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
            ],
          ),
        );
      }),
    );
  }
}
