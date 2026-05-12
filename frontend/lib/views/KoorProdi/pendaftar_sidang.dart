import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/koorprodi_controller.dart';
import '../../models/daftar_sidang_model.dart';

class IndexPendaftarSidangPage extends StatefulWidget {
  const IndexPendaftarSidangPage({super.key});

  @override
  State<IndexPendaftarSidangPage> createState() => _IndexPendaftarSidangPageState();
}

class _IndexPendaftarSidangPageState extends State<IndexPendaftarSidangPage> {
  final KoorProdiController controller = Get.put(KoorProdiController());
  final TextEditingController searchController = TextEditingController();
  
  int _rowsPerPage = 5;
  int _currentPage = 0;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    controller.fetchDaftarSidang();
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
          "Data Pendaftar Sidang",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingDaftarSidang.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredData = controller.listDaftarSidang.where((item) {
          final query = searchQuery.toLowerCase();
          final mhs = item.mahasiswa;
          return (mhs?.namaMahasiswa?.toLowerCase().contains(query) ?? false) ||
                 (mhs?.npm?.toLowerCase().contains(query) ?? false);
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

        return RefreshIndicator(
          onRefresh: () async => controller.fetchDaftarSidang(),
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
                      hintText: "Cari Pendaftar",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      suffixIcon: Icon(Icons.tune, color: Colors.blue),
                      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      border: InputBorder.none,
                    ),
                  ),
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
                              "Tabel Pendaftar",
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
                              DataColumn(label: Text('NPM')),
                              DataColumn(label: Text('Nama')),
                              DataColumn(label: Text('Tgl Daftar')),
                              DataColumn(label: Text('File Tugas Akhir')),
                              DataColumn(label: Text('File Bebas Administrasi')),
                              DataColumn(label: Text('Slip Pembayaran Semester Akhir')),
                              DataColumn(label: Text('Transkip Sementara')),
                              DataColumn(label: Text('Bukti Pembayaran Sidang TA')),
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
                                  DataCell(Text(item.mahasiswa?.npm ?? "-")),
                                  DataCell(Text(item.mahasiswa?.namaMahasiswa ?? "-")),
                                  DataCell(Text(item.tanggalPendaftaran ?? "-")),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility, color: Colors.blue, size: 20),
                                        onPressed: () => _showDetail(item),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        onPressed: () => _confirmDelete(item),
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
                              "Showing ${filteredData.isEmpty ? 0 : startIndex + 1} to $endIndex of ${filteredData.length}",
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
          ),
        );
      }),
    );
  }

  void _showDetail(DaftarSidangModel item) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detail Pendaftaran",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _detailItem("Nama", item.mahasiswa?.namaMahasiswa ?? "-"),
              _detailItem("NPM", item.mahasiswa?.npm ?? "-"),
              _detailItem("Tanggal Daftar", item.tanggalPendaftaran ?? "-"),
              const Divider(),
              const Text("Berkas:", style: TextStyle(fontWeight: FontWeight.bold)),
              _fileItem("File Tugas Akhir", item.fileTugasAkhir),
              _fileItem("Bebas Pinjaman", item.fileBebasPinjamanAdministrasi),
              _fileItem("Slip Pembayaran", item.fileSlipPembayaranSemesterAkhir),
              _fileItem("Transkrip Sementara", item.fileTranskipSementara),
              _fileItem("Bukti Bayar Sidang", item.fileBuktiPembayaranSidangTa),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Tutup"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text("$label:", style: const TextStyle(color: Colors.black54))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _fileItem(String label, String? fileName) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      subtitle: Text(fileName ?? "-", style: const TextStyle(fontSize: 12, color: Colors.blue)),
      trailing: const Icon(Icons.file_present, color: Colors.blue),
      onTap: () {
        // Logika download/view file
      },
    );
  }

  void _confirmDelete(DaftarSidangModel item) {
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
                "Apakah Anda yakin ingin menghapus pendaftaran ${item.mahasiswa?.namaMahasiswa}? Tindakan ini tidak dapat dibatalkan.",
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
                        controller.deleteDaftarSidang(item.id!);
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
