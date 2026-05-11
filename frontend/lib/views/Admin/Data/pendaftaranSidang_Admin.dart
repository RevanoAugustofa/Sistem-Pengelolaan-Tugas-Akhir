import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendaftaranSidangAdminPage extends StatefulWidget {
  const PendaftaranSidangAdminPage({super.key});

  @override
  State<PendaftaranSidangAdminPage> createState() => _PendaftaranSidangAdminPageState();
}

class _PendaftaranSidangAdminPageState extends State<PendaftaranSidangAdminPage> {
  final TextEditingController searchController = TextEditingController();
  int _rowsPerPage = 5;
  int _currentPage = 0;
  String searchQuery = "";

  // Data dummy user
  final List<Map<String, dynamic>> _allMahasiswas = [
    {"no": 1, "npm": 203992, "nama": "Arya Dirham...", "prodi": "TI", "tahunMasuk": "2021"},
    {"no": 2, "npm": 203922, "nama": "Reva Dina", "prodi": "TI", "tahunMasuk": "2021"},
    {"no": 3, "npm": 201292, "nama": "Reva Dina", "prodi": "TI", "tahunMasuk": "2021"},
    {"no": 4, "npm": 205392, "nama": "Aulia Fitri", "prodi": "TI", "tahunMasuk": "2021"},
    {"no": 5, "npm": 203944, "nama": "Alle danara", "prodi": "TI", "tahunMasuk": "2021"},
    {"no": 6, "npm": 203332, "nama": "Budi Santoso", "prodi": "TI", "tahunMasuk": "2021"},
    {"no": 7, "npm": 202322, "nama": "Citra Kirana", "prodi": "TI", "tahunMasuk": "2021"},
    {"no": 8, "npm": 203992, "nama": "Citra Kirana", "prodi": "TI", "tahunMasuk": "2021"},
    {"no": 9, "npm": 203112, "nama": "Citra Kirana", "prodi": "TI", "tahunMasuk": "2021"},
    {"no": 10, "npm": 201192, "nama": "Citra Kirana", "prodi": "TI", "tahunMasuk": "2021"},
    {"no": 11, "npm": 203912, "nama": "-", "prodi": "-", "tahunMasuk": "-"},
  ];

  @override
  Widget build(BuildContext context) {
    var filteredMahasiswa = _allMahasiswas.where((mhs) {
      final query = searchQuery.toLowerCase();
      return (mhs["nama"]?.toString().toLowerCase().contains(query) ?? false) ||
             (mhs["npm"]?.toString().toLowerCase().contains(query) ?? false) ||
             (mhs["prodi"]?.toString().toLowerCase().contains(query) ?? false);
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
    
    List<Map<String, dynamic>> displayedUsers = filteredMahasiswa.isEmpty ? [] : filteredMahasiswa.sublist(startIndex, endIndex);

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
          "Pendaftaran Sidang",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                  hintText: "Cari Pendaftaran Sidang",
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
                          "Pendaftaran Sidang",
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
                            // const Text("entries", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Color.fromARGB(255, 79, 79, 79))),
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
                          DataColumn(label: Text('NPM')),
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Prodi')),
                          DataColumn(label: Text('Tahun Masuk')),
                        ],
                        rows: displayedUsers.asMap().entries.map((entry) {
                          int index = entry.key;
                          var user = entry.value;
                          return DataRow(
                            color: WidgetStateProperty.resolveWith<Color?>((states) {
                              if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
                              return null;
                            }),
                            cells: [
                              DataCell(Text(user["no"].toString())),
                              DataCell(Text(user["npm"].toString())),
                              DataCell(Text(user["nama"])),
                              DataCell(Text(user["prodi"])),
                              DataCell(Text(user["tahunMasuk"])),
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
  }
}
