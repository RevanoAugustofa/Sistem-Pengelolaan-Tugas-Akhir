import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/koorprodi_controller.dart';

class ProposalKoorPage extends StatefulWidget {
  const ProposalKoorPage({super.key});

  @override
  State<ProposalKoorPage> createState() => _ProposalKoorPageState();
}

class _ProposalKoorPageState extends State<ProposalKoorPage> {
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
          "Daftar Proposal",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingMahasiswa.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var listMahasiswa = controller.listMahasiswa.where((m) => m.proposal != null).toList();
        
        if (controller.searchQuery.isNotEmpty) {
          listMahasiswa = listMahasiswa.where((m) {
            return m.namaMahasiswa!.toLowerCase().contains(controller.searchQuery.toLowerCase()) ||
                   m.npm!.toLowerCase().contains(controller.searchQuery.toLowerCase());
          }).toList();
        }

        // Pagination logic
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
              // Search Bar
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
                    hintText: "Cari Nama atau NIM",
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
                        "Data Judul Proposal Mahasiswa",
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
                            DataColumn(label: Text('Judul Proposal')),
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
                                DataCell(SizedBox(
                                  width: 250,
                                  child: Text(
                                    mhs.proposal?.judulProposal ?? "-",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // Pagination Footer
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
