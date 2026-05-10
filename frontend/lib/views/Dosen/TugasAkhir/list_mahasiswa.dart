import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListMahasiswaPage extends StatefulWidget {
  const ListMahasiswaPage({super.key});

  @override
  State<ListMahasiswaPage> createState() => _ListMahasiswaPageState();
}

class _ListMahasiswaPageState extends State<ListMahasiswaPage> {
  final TextEditingController searchController = TextEditingController();
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
          "Daftar Mahasiswa",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Cari Mahasiswa...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      suffixIcon: Icon(Icons.tune, color: Color(0xFF10A8E5)),
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Menampilkan Mahasiswa Bimbingan",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // List Area
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 4, // Placeholder
              itemBuilder: (context, index) {
                final names = [
                  "Revano Augustofa",
                  "Arya Awikwok",
                  "Alle Danaralle",
                  "Budi Setiawan"
                ];
                final npms = ["230102078", "230102071", "230102072", "230102080"];
                
                return _buildStudentCard(
                  names[index % names.length],
                  npms[index % npms.length],
                  "TI-3C",
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildStudentCard(String nama, String npm, String kelas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person, color: Color(0xFF2196F3)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$npm • $kelas",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
               Get.toNamed('/logbookDsn');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10A8E5),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Pilih",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF283D70),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      currentIndex: 1,
      onTap: (index) {
        if (index == 0) {
          Get.toNamed('/dashboardDsn');
        } else if (index == 2) {
          Get.toNamed('/jadwalDsn');
        } else if (index == 3) {
          Get.toNamed('/profil', arguments: {'activeRole': 'dosen'});
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "Tugas Akhir"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Jadwal"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
      ],
    );
  }
}
