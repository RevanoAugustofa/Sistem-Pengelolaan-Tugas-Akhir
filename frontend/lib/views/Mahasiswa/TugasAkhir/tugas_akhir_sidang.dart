import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'form_daftar_sidang_ta.dart';

class TugasAkhirSidangMhsView extends StatelessWidget {
  const TugasAkhirSidangMhsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.assignment_turned_in_outlined,
                  size: 60,
                  color: Color(0xFF4A89FF),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Pendaftaran Sidang Tugas Akhir",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF283D70),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Silakan lakukan pendaftaran sidang jika Anda telah menyelesaikan bimbingan dan disetujui oleh pembimbing.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const FormDaftarSidangView());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A89FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Daftar Sidang TA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
