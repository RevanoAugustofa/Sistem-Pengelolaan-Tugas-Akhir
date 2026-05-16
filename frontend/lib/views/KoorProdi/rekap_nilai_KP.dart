import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/koorprodi_controller.dart';
import '../../helpers/rekap_export_helper.dart';

class RekapNilaiKPPage extends StatefulWidget {
  const RekapNilaiKPPage({super.key});

  @override
  State<RekapNilaiKPPage> createState() => _RekapNilaiKPPageState();
}

class _RekapNilaiKPPageState extends State<RekapNilaiKPPage> {
  final KoorProdiController controller = Get.find<KoorProdiController>();
  final TextEditingController searchController = TextEditingController();
  int _rowsPerPage = 5;
  int _currentPage = 0;
  String searchQuery = "";

  Future<void> _exportToExcel() async {
    try {
      await RekapExportHelper.exportToExcel(controller.listRekap);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    controller.fetchRekap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 149, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Rekap Nilai Tugas Akhir",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingRekap.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredData = controller.listRekap.where((item) {
          final query = searchQuery.toLowerCase();
          return (item['nama_mahasiswa']?.toLowerCase().contains(query) ?? false) ||
                 (item['nim']?.toLowerCase().contains(query) ?? false) ||
                 (item['prodi']?['nama_prodi']?.toLowerCase().contains(query) ?? false);
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
                    hintText: "Cari Mahasiswa",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    suffixIcon: Icon(Icons.tune, color: Colors.blue),
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text("Filter - All (Total: ${filteredData.length})", style: const TextStyle(color: Colors.grey, fontSize: 13)),
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
                            "Data Rekap",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1E3475)),
                          ),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _exportToExcel,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.file_download, size: 18),
                                label: const Text("Export Excel", style: TextStyle(fontSize: 12)),
                              ),
                              const SizedBox(width: 10),
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
                            ],
                          ),
                        ],
                      ),
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 72),
                        child: DataTable(
                          headingRowHeight: 60,
                          headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
                          headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          columnSpacing: 20,
                          horizontalMargin: 15,
                          columns: [
                            DataColumn(label: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('', style: TextStyle(fontSize: 10)),
                                const Text('No'),
                              ],
                            )),
                            DataColumn(label: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('', style: TextStyle(fontSize: 10)),
                                const Text('NPM'),
                              ],
                            )),
                            DataColumn(label: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('', style: TextStyle(fontSize: 10)),
                                const Text('Nama'),
                              ],
                            )),
                            DataColumn(label: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('', style: TextStyle(fontSize: 10)),
                                const Text('Prodi'),
                              ],
                            )),
                            DataColumn(label: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('', style: TextStyle(fontSize: 10)),
                                const Text('Angka'),
                              ],
                            )),
                            DataColumn(label: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Nilai', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                const Text('Huruf'),
                              ],
                            )),
                            DataColumn(label: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('', style: TextStyle(fontSize: 10)),
                                const Text('Keterangan'),
                              ],
                            )),
                          ],
                          rows: List.generate(displayedData.length, (index) {
                            var item = displayedData[index];
                            double nilai = double.tryParse(item['hasil_akhir']?['nilai_total']?.toString() ?? '0') ?? 0;
                            
                            String huruf = '-';
                            String keterangan = '-';
                            Color color = Colors.grey;

                            if (item['hasil_akhir'] != null) {
                              if (nilai >= 80) {
                                huruf = 'A';
                                keterangan = 'Sangat Memuaskan';
                                color = Colors.green;
                              } else if (nilai >= 75) {
                                huruf = 'AB';
                                keterangan = 'Istimewa';
                                color = Colors.lightGreen;
                              } else if (nilai >= 65) {
                                huruf = 'B';
                                keterangan = 'Baik';
                                color = Colors.blue;
                              } else if (nilai >= 60) {
                                huruf = 'BC';
                                keterangan = 'Cukup Baik';
                                color = Colors.cyan;
                              } else if (nilai >= 50) {
                                huruf = 'C';
                                keterangan = 'Cukup';
                                color = Colors.orange;
                              } else if (nilai >= 40) {
                                huruf = 'D';
                                keterangan = 'Kurang';
                                color = Colors.deepOrange;
                              } else {
                                huruf = 'E';
                                keterangan = 'Gagal';
                                color = Colors.red;
                              }
                            }

                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>((states) {
                                if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                                return null;
                              }),
                              cells: [
                                DataCell(Text((startIndex + index + 1).toString())),
                                DataCell(Text(item['nim'] ?? "-")),
                                DataCell(Text(item['nama_mahasiswa'] ?? "-")),
                                DataCell(Text(item['prodi']?['nama_prodi'] ?? "-")),
                                DataCell(Text(item['hasil_akhir'] != null ? nilai.toStringAsFixed(1) : "-")),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      huruf,
                                      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    keterangan,
                                    style: TextStyle(
                                      color: color.withOpacity(0.8),
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
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
                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 13, color: Color.fromARGB(255, 79, 79, 79)),
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
                                    " < ",
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
                                    " > ",
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
        );
      }),
    );
  }
}
