import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/koorprodi_controller.dart';

class UserKpPage extends StatefulWidget {
  const UserKpPage({super.key});

  @override
  State<UserKpPage> createState() => _UserKpPageState();
}

class _UserKpPageState extends State<UserKpPage> {
  final KoorProdiController controller = Get.put(KoorProdiController());
  final TextEditingController searchController = TextEditingController();
  
  int _rowsPerPage = 5;
  int _currentPage = 0;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 149, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "User",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingMahasiswa.value || controller.isLoadingDosen.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Combine Mahasiswa and Dosen into a unified list
        List<Map<String, String?>> allUsers = [];
        for (var m in controller.listMahasiswa) {
          allUsers.add({
            'name': m.namaMahasiswa,
            'email': m.email,
            'role': 'Mahasiswa',
          });
        }
        for (var d in controller.listDosenManajemen) {
          allUsers.add({
            'name': d.namaDosen,
            'email': d.email,
            'role': 'Dosen',
          });
        }

        var filteredUsers = allUsers.where((user) {
          final query = searchQuery.toLowerCase();
          return (user['name']?.toLowerCase().contains(query) ?? false) ||
                 (user['email']?.toLowerCase().contains(query) ?? false) ||
                 (user['role']?.toLowerCase().contains(query) ?? false);
        }).toList();

        // Logika Pagination Manual
        int startIndex = _currentPage * _rowsPerPage;
        int endIndex = startIndex + _rowsPerPage;
        if (endIndex > filteredUsers.length) endIndex = filteredUsers.length;
        if (startIndex >= filteredUsers.length && filteredUsers.isNotEmpty) {
           _currentPage = (filteredUsers.length / _rowsPerPage).floor();
           startIndex = _currentPage * _rowsPerPage;
           endIndex = filteredUsers.length;
        }

        var displayedUsers = filteredUsers.isEmpty ? [] : filteredUsers.sublist(startIndex, endIndex);

        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchMahasiswa();
            controller.fetchDosenManajemen();
          },
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
                      hintText: "Cari User",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      suffixIcon: Icon(Icons.tune, color: Colors.blue),
                      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // --- Custom Paginated Table ---
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
                              "Data User",
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
                                const Text("entries", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Color.fromARGB(255, 79, 79, 79))),
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
                            columnSpacing: 10,
                            horizontalMargin: 15,
                            columns: const [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Nama')),
                              DataColumn(label: Text('Role')),
                              DataColumn(label: Text('Email')),
                            ],
                            rows: List.generate(displayedUsers.length, (index) {
                              var user = displayedUsers[index];
                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>((states) {
                                  if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                                  return null;
                                }),
                                cells: [
                                  DataCell(Text((startIndex + index + 1).toString())),
                                  DataCell(Text(user['name'] ?? "-")),
                                  DataCell(Text(user['role'] ?? "-")),
                                  DataCell(Text(user['email'] ?? "-")),
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
                              "Showing ${filteredUsers.isEmpty ? 0 : startIndex + 1} to $endIndex of ${filteredUsers.length} entries",
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
                                      "Previous",
                                      style: TextStyle(
                                        color: _currentPage > 0 ? const Color(0xFF4FA5FF) : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: endIndex < filteredUsers.length ? () => setState(() => _currentPage++) : null,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      color: endIndex < filteredUsers.length ? Colors.white : Colors.grey.shade100,
                                    ),
                                    child: Text(
                                      "Next",
                                      style: TextStyle(
                                        color: endIndex < filteredUsers.length ? const Color(0xFF4FA5FF) : Colors.grey,
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
