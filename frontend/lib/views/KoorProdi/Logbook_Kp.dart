import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/koorprodi_controller.dart';

class LogbookKoorPage extends StatefulWidget {
  const LogbookKoorPage({super.key});

  @override
  State<LogbookKoorPage> createState() => _LogbookKoorPageState();
}

class _LogbookKoorPageState extends State<LogbookKoorPage> {
  final KoorProdiController controller = Get.find<KoorProdiController>();
  final TextEditingController searchController = TextEditingController();
  int _rowsPerPage = 10;
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
          "Logbook Mahasiswa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingMahasiswa.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Filter mahasiswa (asumsi Logbook adalah riwayat bimbingan mahasiswa)
        var listMahasiswa = controller.listMahasiswa.toList();
        
        if (controller.searchQuery.isNotEmpty) {
          listMahasiswa = listMahasiswa.where((m) {
            return m.namaMahasiswa!.toLowerCase().contains(controller.searchQuery.toLowerCase()) ||
                   m.npm!.toLowerCase().contains(controller.searchQuery.toLowerCase());
          }).toList();
        }

        int startIndex = _currentPage * _rowsPerPage;
        int endIndex = startIndex + _rowsPerPage;
        if (endIndex > listMahasiswa.length) endIndex = listMahasiswa.length;
        if (startIndex >= listMahasiswa.length && listMahasiswa.isNotEmpty) {
          startIndex = 0;
          _currentPage = 0;
        }
        
        var displayedList = listMahasiswa.isEmpty ? [] : listMahasiswa.sublist(startIndex, endIndex);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    controller.updateSearch(value);
                    setState(() => _currentPage = 0);
                  },
                  decoration: const InputDecoration(
                    hintText: "Cari Nama atau NIM Mahasiswa",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    suffixIcon: Icon(Icons.search, color: Colors.blue),
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Monitoring Bimbingan Mahasiswa",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3475)),
                      ),
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 72),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
                          headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          columns: const [
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('NIM')),
                            DataColumn(label: Text('Nama')),
                            DataColumn(label: Text('Pembimbing utama')),
                            DataColumn(label: Text('Pembimbing pendamping')),
                            DataColumn(label: Text('Prodi')),
                            DataColumn(label: Text('Aksi')),
                          ],
                          rows: displayedList.asMap().entries.map((entry) {
                            int index = entry.key;
                            var mhs = entry.value;
                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>((states) {
                                if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                                return null;
                              }),
                              cells: [
                                DataCell(Text("${startIndex + index + 1}")),
                                DataCell(Text(mhs.npm ?? "-")),
                                DataCell(Text(mhs.namaMahasiswa ?? "-")),
                                DataCell(Text(mhs.namaMahasiswa ?? "-")),
                                DataCell(Text(mhs.namaMahasiswa ?? "-")),
                                DataCell(Text(mhs.prodi ?? "-")),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () {
                                      // Logika untuk melihat detail logbook mahasiswa tertentu
                                      Get.snackbar("Info", "Fitur Detail Logbook ${mhs.namaMahasiswa} sedang dikembangkan");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text("Detail", style: TextStyle(color: Colors.white, fontSize: 11)),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Showing ${listMahasiswa.isEmpty ? 0 : startIndex + 1} to $endIndex of ${listMahasiswa.length} entries",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                              ),
                              Text("${_currentPage + 1}"),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: endIndex < listMahasiswa.length ? () => setState(() => _currentPage++) : null,
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
