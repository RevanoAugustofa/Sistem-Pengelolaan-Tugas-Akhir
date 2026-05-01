import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class DataDiriPage extends StatelessWidget {
  DataDiriPage({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Data Diri",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), 
          fontWeight: FontWeight.bold, 
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 149, 255),
        centerTitle: true,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF283D70)),
        //   onPressed: () => Get.back(),
        // ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
    
            Image.asset('assets/img/ubah_profil.png', width: 160, height: 160,),

            const SizedBox(height: 10),

            // 2. Form Data Diri Dinamis
            Obx(() => _buildDataField(
              controller.userRole.value == 'Mahasiswa' ? "Nama Mahasiswa" : "Nama", 
              controller.userName.value
            )),
            
            Obx(() => _buildDataField(
              controller.userRole.value == 'Mahasiswa' ? "NIM" : 
              (controller.userRole.value == 'Dosen' || controller.userRole.value == 'KoorProdi') ? "NIP/NIDN" : "ID", 
              controller.userId.value
            )),

            _buildDataField("Email", controller.userEmail.value),

            // Tambahan Field Berdasarkan Role
            Obx(() {
              if (controller.userRole.value == 'Mahasiswa') {
                return Column(
                  children: [
                    _buildDataField("Program Studi", "D3 Teknik Informatika"), // Mockup
                    _buildDataField("Tahun Ajaran", "2023/2024"), // Mockup
                  ],
                );
              } else if (controller.userRole.value == 'Dosen') {
                return Column(
                  children: [
                    _buildDataField("Jabatan", "Lektor"), // Mockup
                    _buildDataField("Bidang Keahlian", "Rekayasa Perangkat Lunak"), // Mockup
                  ],
                );
              }
              return const SizedBox();
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat input field statis (Read-only)
  Widget _buildDataField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
