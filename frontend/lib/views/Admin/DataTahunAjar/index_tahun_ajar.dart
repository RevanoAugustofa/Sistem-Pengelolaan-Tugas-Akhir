import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/tahun_ajar_model.dart';
import 'create_tahun_ajar.dart';
import 'edit_tahun_ajar.dart';

class IndexTahunAjarPage extends StatefulWidget {
  const IndexTahunAjarPage({super.key});

  @override
  State<IndexTahunAjarPage> createState() => _IndexTahunAjarPageState();
}

class _IndexTahunAjarPageState extends State<IndexTahunAjarPage> {
  final AdminController controller = Get.put(AdminController());
  final TextEditingController searchController = TextEditingController();

  int _rowsPerPage = 5;
  int _currentPage = 0;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    controller.fetchTahunAjar();
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
          "Data Tahun Ajar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingTahunAjar.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredList = controller.listTahunAjar.where((tahun) {
          final query = searchQuery.toLowerCase();
          return (tahun.tahunAjar?.toLowerCase().contains(query) ?? false);
        }).toList();

        int startIndex = _currentPage * _rowsPerPage;
        int endIndex = startIndex + _rowsPerPage;
        if (endIndex > filteredList.length) endIndex = filteredList.length;
        if (startIndex >= filteredList.length && filteredList.isNotEmpty) {
           _currentPage = (filteredList.length / _rowsPerPage).floor();
           startIndex = _currentPage * _rowsPerPage;
           endIndex = filteredList.length;
        }
        
        var displayedTahun = filteredList.isEmpty ? [] : filteredList.sublist(startIndex, endIndex);

        return RefreshIndicator(
          onRefresh: () async => controller.fetchTahunAjar(),
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
                      hintText: "Cari Tahun Ajar",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      suffixIcon: Icon(Icons.tune, color: Colors.blue),
                      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // 2. Button Tambah
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Get.to(() => const CreateTahunAjarPage()),
                        icon: const Icon(Icons.post_add, color: Colors.white, size: 20),
                        label: const Text("Tambah", style: TextStyle(color: Colors.white, fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50), // Warna Hijau
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
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
                              "Tabel Tahun Ajar",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E3475)),
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
                                // const Text("entries", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Color.fromARGB(255, 79, 79, 79))),
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
                            headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
                            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            columnSpacing: 20,
                            horizontalMargin: 15,
                            columns: const [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Tahun Ajar')),
                              DataColumn(label: Text('Aksi')),
                            ],
                            rows: List.generate(displayedTahun.length, (index) {
                              var tahun = displayedTahun[index];
                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>((states) {
                                  if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                                  return null;
                                }),
                                cells: [
                                  DataCell(Text((startIndex + index + 1).toString())),
                                  DataCell(Text(tahun.tahunAjar ?? "-")),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                        onPressed: () => Get.to(() => EditTahunAjarPage(tahunAjar: tahun)),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        onPressed: () => _confirmDelete(tahun),
                                      ),
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
                              "Showing ${filteredList.isEmpty ? 0 : startIndex + 1} to $endIndex of ${filteredList.length} entries",
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
                                  onTap: endIndex < filteredList.length ? () => setState(() => _currentPage++) : null,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      color: endIndex < filteredList.length ? Colors.white : Colors.grey.shade100,
                                    ),
                                    child: Text(
                                      " > ",
                                      style: TextStyle(
                                        color: endIndex < filteredList.length ? const Color(0xFF4FA5FF) : Colors.grey,
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

  void _confirmDelete(TahunAjar tahun) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              const Text(
                "Hapus Data",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Apakah Anda yakin ingin menghapus tahun ajar ${tahun.tahunAjar}? Tindakan ini tidak dapat dibatalkan.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text("Batal", style: TextStyle(color: Colors.black87)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.deleteTahunAjar(tahun.id!);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Hapus", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
