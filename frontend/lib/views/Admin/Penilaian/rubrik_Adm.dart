import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/rubrik_nilai_model.dart';

class RubrikAdminPage extends StatefulWidget {
  const RubrikAdminPage({super.key});

  @override
  State<RubrikAdminPage> createState() => _RubrikAdminPageState();
}

class _RubrikAdminPageState extends State<RubrikAdminPage> {
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
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Rubrik",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingRubrikNilai.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredRubrik = controller.listRubrikNilai.where((rubrik) {
          final query = searchQuery.toLowerCase();
          return (rubrik.kelompok?.toLowerCase().contains(query) ?? false) ||
                 (rubrik.kategori?.toLowerCase().contains(query) ?? false) ||
                 (rubrik.jenisDosen?.toLowerCase().contains(query) ?? false);
        }).toList();

        // Logika Pagination Manual
        int startIndex = _currentPage * _rowsPerPage;
        int endIndex = startIndex + _rowsPerPage;
        if (endIndex > filteredRubrik.length) endIndex = filteredRubrik.length;
        if (startIndex >= filteredRubrik.length && filteredRubrik.isNotEmpty) {
          _currentPage = (filteredRubrik.length / _rowsPerPage).floor();
          startIndex = _currentPage * _rowsPerPage;
          endIndex = filteredRubrik.length;
        }

        List<RubrikNilai> displayedRubriks = filteredRubrik.isEmpty ? [] : filteredRubrik.sublist(startIndex, endIndex);

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
                    hintText: "Cari Rubrik",
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
                            "Data Rubrik",
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
                            ],
                          ),
                        ],
                      ),
                    ),

                    // --- Table Area ---
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
                            DataColumn(label: Text('Prodi')),
                            DataColumn(label: Text('Jenis Dosen')),
                            DataColumn(label: Text('Kelompok')),
                            DataColumn(label: Text('Kategori')),
                            DataColumn(label: Text('Persentase')),
                          ],
                          rows: displayedRubriks.asMap().entries.map((entry) {
                            int index = entry.key;
                            var rubrik = entry.value;
                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>((states) {
                                if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                                return null;
                              }),
                              cells: [
                                DataCell(Text((startIndex + index + 1).toString())),
                                DataCell(Text(rubrik.prodi?.namaProdi ?? '-')),
                                DataCell(Text(rubrik.jenisDosen ?? '-')),
                                DataCell(Text(rubrik.kelompok ?? '-')),
                                DataCell(Text(rubrik.kategori ?? '-')),
                                DataCell(Text("${rubrik.presentse ?? 0}%")),
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
                            "Showing ${filteredRubrik.isEmpty ? 0 : startIndex + 1} to $endIndex of ${filteredRubrik.length} entries",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color.fromARGB(255, 79, 79, 79)),
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
                                onTap: endIndex < filteredRubrik.length ? () => setState(() => _currentPage++) : null,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                    color: endIndex < filteredRubrik.length ? Colors.white : Colors.grey.shade100,
                                  ),
                                  child: Text(
                                    " > ",
                                    style: TextStyle(
                                      color: endIndex < filteredRubrik.length ? const Color(0xFF4FA5FF) : Colors.grey,
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
