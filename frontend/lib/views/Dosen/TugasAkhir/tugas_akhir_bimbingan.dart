import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TugasAkhirBimbinganTable extends StatelessWidget {
  final String searchQuery;
  const TugasAkhirBimbinganTable({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentCard("Revano Augustofa", "230102071", "TI-C"),
          _buildStudentCard("Arya Awikwok", "230102071", "TI-C"),
          _buildStudentCard("Arya Awikwok", "230102071", "TI-C"),
          _buildStudentCard("Alle Danaralle", "230102071", "TI-C"),
          
          const SizedBox(height: 10),
          const Text(
            "Menampilkan 4 dari 10 data",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStudentCard(String nama, String npm, String kelas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  "$npm    $kelas",
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                 Get.toNamed('/logbookDsn');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FA5FF),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text("Pilih", style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
