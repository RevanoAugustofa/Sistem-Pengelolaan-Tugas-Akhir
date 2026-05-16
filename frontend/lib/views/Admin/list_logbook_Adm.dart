import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/mahasiswa_model.dart';
import 'detail_logbook_Adm.dart';

class LogbookAdminPage extends StatefulWidget {
  const LogbookAdminPage({super.key});

  @override
  State<LogbookAdminPage> createState() => _LogbookAdminPageState();
}

class _LogbookAdminPageState extends State<LogbookAdminPage> {
  final AdminController controller = Get.put(AdminController());
  final TextEditingController searchController = TextEditingController();
  int _rowsPerPage = 5;
  int _currentPage = 0;
  String searchQuery = "";

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
          "Logbook",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingMahasiswa.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredMahasiswa = controller.listMahasiswa.where((mhs) {
          final query = searchQuery.toLowerCase();
          return (mhs.namaMahasiswa?.toLowerCase().contains(query) ?? false) ||
                 (mhs.npm?.toLowerCase().contains(query) ?? false) ||
                 (mhs.prodi?.toLowerCase().contains(query) ?? false);
        }).toList();

        // Logika Pagination Manual
        int startIndex = _currentPage * _rowsPerPage;
        int endIndex = startIndex + _rowsPerPage;
        if (endIndex > filteredMahasiswa.length) endIndex = filteredMahasiswa.length;
        if (startIndex >= filteredMahasiswa.length && filteredMahasiswa.isNotEmpty) {
           _currentPage = (filteredMahasiswa.length / _rowsPerPage).floor();
           startIndex = _currentPage * _rowsPerPage;
           endIndex = filteredMahasiswa.length;
        }
        
        List<Mahasiswa> displayedUsers = filteredMahasiswa.isEmpty ? [] : filteredMahasiswa.sublist(startIndex, endIndex);

        return RefreshIndicator(
          onRefresh: () async => controller.fetchMahasiswa(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                      hintText: "Cari Logbook",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      suffixIcon: Icon(Icons.tune, color: Colors.blue),
                      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text("Filter - All", style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 20),

                // --- Custom Paginated Table ---
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Header: Judul & Show Entries ---
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Data Logbook",
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
                                          _currentPage = 0; // Reset ke hal 1
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

                      // --- Table Area ---
                      if (filteredMahasiswa.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Data mahasiswa tidak ditemukan", style: TextStyle(color: Colors.grey)),
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
                                DataColumn(label: Text('NPM')),
                                DataColumn(label: Text('Nama')),
                                DataColumn(label: Text('Prodi')),
                                DataColumn(label: Text('Tahun Ajar')),
                                DataColumn(label: Text('Aksi')),
                              ],
                              rows: displayedUsers.asMap().entries.map((entry) {
                                int index = entry.key;
                                var mhs = entry.value;
                                return DataRow(
                                  color: WidgetStateProperty.resolveWith<Color?>((states) {
                                    if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                                    return null;
                                  }),
                                  cells: [
                                    DataCell(Text((startIndex + index + 1).toString())),
                                    DataCell(Text(mhs.npm ?? "-")),
                                    DataCell(Text(mhs.namaMahasiswa ?? "-")),
                                    DataCell(Text(mhs.prodi ?? "-")),
                                    DataCell(Text(mhs.angkatan ?? "-")),
                                    DataCell(
                                      ElevatedButton(
                                        onPressed: () => Get.to(() => DetailLogbookAdminPage(mahasiswa: mhs)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          minimumSize: const Size(70, 30),
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        child: const Text("Detail", style: TextStyle(color: Colors.white, fontSize: 12)),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                      // --- Footer: Info & Tombol Next/Prev ---
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Showing ${filteredMahasiswa.isEmpty ? 0 : startIndex + 1} to $endIndex of ${filteredMahasiswa.length} entries",
                              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 13, color: Color.fromARGB(255, 79, 79, 79)),
                            ),
                            Row(
                              children: [
                                // Button Previous
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
                                // Button Next
                                InkWell(
                                  onTap: endIndex < filteredMahasiswa.length ? () => setState(() => _currentPage++) : null,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      color: endIndex < filteredMahasiswa.length ? Colors.white : Colors.grey.shade100,
                                    ),
                                    child: Text(
                                      " > ",
                                      style: TextStyle(
                                        color: endIndex < filteredMahasiswa.length ? const Color(0xFF4FA5FF) : Colors.grey,
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
      }),
    );
  }
}
