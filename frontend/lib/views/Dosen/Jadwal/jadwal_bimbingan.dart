import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/dosen_controller.dart';

class JadwalBimbinganDosenTable extends StatefulWidget {
  final String searchQuery;
  const JadwalBimbinganDosenTable({super.key, required this.searchQuery});

  @override
  State<JadwalBimbinganDosenTable> createState() => _JadwalBimbinganDosenTableState();
}

class _JadwalBimbinganDosenTableState extends State<JadwalBimbinganDosenTable> {
  final DosenController controller = Get.find<DosenController>();
  
  int _rowsPerPage = 5;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingJadwal.value) {
        return const Center(child: CircularProgressIndicator());
      }

      var filteredData = controller.filteredJadwalBimbingan;

      // Sort descending by ID (newest first)
      // Note: We might want to do this in the controller's filter logic, but keeping it here for now if needed.
      // However, it's better to sort listJadwalBimbingan when fetching.
      
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
        onRefresh: () async => controller.fetchJadwalBimbingan(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Button Tambah Jadwal
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed('/createJadwalBimbinganDsn'),
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text(
                      "Tambah Jadwal",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    ),
                  ),
                ),
              ),

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
                            "Tabel Jadwal Bimbingan",
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
                          child: Text("Belum ada jadwal bimbingan", style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dataRowMinHeight: 48,
                          dataRowMaxHeight: 65,
                          headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
                          headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                          columnSpacing: 25,
                          columns: const [
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('Metode')),
                            DataColumn(label: Text('Tempat / Link')),
                            DataColumn(label: Text('Kuota')),
                            DataColumn(label: Text('Waktu')),
                            DataColumn(label: Text('Aksi')),
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
                                  width: 140,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.tempatLink ?? "-",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ),
                                      if (item.tempatLink != null && item.tempatLink!.isNotEmpty && item.metodeBimbingan?.toLowerCase() == 'online')
                                        IconButton(
                                          icon: const Icon(Icons.copy, size: 14, color: Colors.blue),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: item.tempatLink!));
                                            Get.snackbar(
                                              "Copied",
                                              "Link berhasil disalin",
                                              snackPosition: SnackPosition.BOTTOM,
                                              backgroundColor: Colors.black87,
                                              colorText: Colors.white,
                                              duration: const Duration(seconds: 1),
                                              margin: const EdgeInsets.all(10),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                )),
                                DataCell(Center(child: Text(item.kuota.toString(), style: const TextStyle(fontSize: 11)))),
                                DataCell(
                                  item.waktuTanggal != null 
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.parse(item.waktuTanggal!)).toLowerCase(),
                                            style: const TextStyle(fontSize: 10, color: Colors.black87),
                                          ),
                                          Text(
                                            DateFormat('HH:mm').format(DateTime.parse(item.waktuTanggal!)),
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    : const Text("-", style: TextStyle(fontSize: 11)),
                                ),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () => Get.toNamed('/detailPendaftaranBimbinganDsn', arguments: item),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E3475),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                      minimumSize: const Size(60, 30),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    child: const Text("Detail", style: TextStyle(color: Colors.white, fontSize: 10)),
                                  ),
                                ),
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
            ],
          ),
        ),
      );
    });
  }
}
