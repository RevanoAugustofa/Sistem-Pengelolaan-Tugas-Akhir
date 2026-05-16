import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/koorprodi_controller.dart';
import 'hasilAkhir_sempro.dart';
import 'hasilAkhir_sidang.dart';

class HasilAkhirKPPage extends StatefulWidget {
  const HasilAkhirKPPage({super.key});

  @override
  State<HasilAkhirKPPage> createState() => _HasilAkhirKPPageState();
}

class _HasilAkhirKPPageState extends State<HasilAkhirKPPage> {
  final KoorProdiController controller = Get.put(KoorProdiController());
  final TextEditingController searchController = TextEditingController();
  String selectedTab = "Sempro";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    controller.fetchHasilAkhir();
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
          "Hasil Akhir",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // TAB BAR
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 149, 255),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildTabItem("Sempro"),
                _buildTabItem("Sidang"),
              ],
            ),
          ),

          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
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
                  hintText: "Cari Mahasiswa",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  suffixIcon: Icon(Icons.tune, color: Colors.blue),
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hasil Akhir - $selectedTab TA",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),

          // TABLE AREA (SPA)
          Expanded(
            child: buildTable(),
          ),
        ],
      ),
    );
  }

  // TAB BUTTON
  Widget _buildTabItem(String title) {
    bool isActive = selectedTab == title;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Color.fromARGB(74, 0, 0, 0): Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // SWITCH TABLE
  Widget buildTable() {
    if (selectedTab == "Sempro") {
      return HasilSemproKPTable(searchQuery: searchQuery);
    } else {
      return HasilSidangKPTable(searchQuery: searchQuery);
    }
  }
}
