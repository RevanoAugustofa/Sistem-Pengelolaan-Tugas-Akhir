import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';

class RekapPembimbingPengujiAdminPage extends StatefulWidget {
  const RekapPembimbingPengujiAdminPage({super.key});

  @override
  State<RekapPembimbingPengujiAdminPage> createState() => _RekapPembimbingPengujiAdminPageState();
}

class _RekapPembimbingPengujiAdminPageState extends State<RekapPembimbingPengujiAdminPage> {
  final AdminController controller = Get.put(AdminController());
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    controller.fetchRekap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Background abu-abu muda
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Rekap Pembimbing Penguji",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingRekap.value) {
          return const Center(child: CircularProgressIndicator());
        }

        List<dynamic> listRekap = controller.listRekap.toList();

        if (searchQuery.isNotEmpty) {
          listRekap = listRekap.where((item) {
            final nama = item['nama_mahasiswa']?.toString().toLowerCase() ?? "";
            final nim = item['nim']?.toString().toLowerCase() ?? "";
            final query = searchQuery.toLowerCase();
            return nama.contains(query) || nim.contains(query);
          }).toList();
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchRekap(),
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
                      });
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
                const SizedBox(height: 15),
                const Text(
                  "Filter - All",
                  style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),

                // --- Data Table Rekap ---
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
                          "Data Rekap",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3475)),
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 72),
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 110, 110, 110)),
                            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                            columnSpacing: 20,
                            columns: const [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Mahasiswa')),
                              DataColumn(label: Text('Pembimbing')),
                              DataColumn(label: Text('Penguji Sempro')),
                              DataColumn(label: Text('Penguji Sidang')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Aksi')),
                            ],
                            rows: _buildTableRows(listRekap),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // --- Pagination ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Menampilkan ${listRekap.length} data",
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    Row(
                      children: [
                        _buildPageNode("1", isActive: true),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- WIDGET HELPER: Table Rows ---
  List<DataRow> _buildTableRows(List<dynamic> listRekap) {
    return listRekap.asMap().entries.map((entry) {
      int index = entry.key;
      var item = entry.value;

      // Extracting Pembimbing
      String pembimbing = "-";
      if (item['pengajuan_pembimbing'] != null) {
        String p1 = item['pengajuan_pembimbing']['pembimbing_utama']?['nama_dosen'] ?? "-";
        String p2 = item['pengajuan_pembimbing']['pembimbing_pendamping']?['nama_dosen'] ?? "-";
        pembimbing = "1. $p1\n2. $p2";
      }

      // Extracting Penguji Sempro
      String pengujiSempro = "-";
      if (item['jadwal_sempro'] != null) {
        String u1 = item['jadwal_sempro']['penguji_utama']?['nama_dosen'] ?? "-";
        String u2 = item['jadwal_sempro']['penguji_pendamping']?['nama_dosen'] ?? "-";
        pengujiSempro = "1. $u1\n2. $u2";
      }

      // Extracting Penguji Sidang
      String pengujiSidang = "-";
      if (item['jadwal_sidang'] != null) {
        String s1 = item['jadwal_sidang']['penguji_utama']?['nama_dosen'] ?? "-";
        String s2 = item['jadwal_sidang']['penguji_pendamping']?['nama_dosen'] ?? "-";
        pengujiSidang = "1. $s1\n2. $s2";
      }

      String status = item['pengajuan_pembimbing']?['status'] ?? "Menunggu";
      // Capitalize first letter
      status = status[0].toUpperCase() + status.substring(1);

      return DataRow(
        color: WidgetStateProperty.resolveWith<Color?>((states) {
          if (index % 2 != 0) return Colors.grey.withOpacity(0.05);
          return null;
        }),
        cells: [
          DataCell(Text("${index + 1}")),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['nama_mahasiswa'] ?? "-", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(item['nim'] ?? "-", style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          )),
          DataCell(Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(pembimbing, style: const TextStyle(fontSize: 11)),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(pengujiSempro, style: const TextStyle(fontSize: 11)),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(pengujiSidang, style: const TextStyle(fontSize: 11)),
          )),
          DataCell(_buildStatusBadge(status)),
          DataCell(
            SizedBox(
              height: 28,
              child: ElevatedButton(
                onPressed: () {
                  // Aksi validasi
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FA5FF),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  "validasi",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  // --- WIDGET HELPER: Status Badge ---
  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    Color textColor;
    BoxBorder? badgeBorder;

    if (status == "Disetujui") {
      badgeColor = const Color(0xFFD1FADF); // Hijau muda
      textColor = const Color(0xFF12B76A); // Hijau tua
    } else if (status == "Ditolak") {
      badgeColor = const Color(0xFFFEE4E2); // Merah muda
      textColor = const Color(0xFFF04438); // Merah tua
    } else {
      // Menunggu
      badgeColor = Colors.transparent;
      textColor = Colors.grey.shade700;
      badgeBorder = Border.all(color: Colors.grey.shade400);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(4),
        border: badgeBorder,
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // --- WIDGET HELPER: Pagination Node ---
  Widget _buildPageNode(String text, {required bool isActive, bool isGreyBackground = false}) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive 
            ? Colors.grey.shade400 
            : (isGreyBackground ? Colors.grey.shade200 : Colors.transparent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}
