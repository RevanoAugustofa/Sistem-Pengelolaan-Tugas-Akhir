import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/mhs_controller.dart';
import 'form_daftar_sidang_ta.dart';

class TugasAkhirSidangMhsView extends StatelessWidget {
  const TugasAkhirSidangMhsView({super.key});

  @override
  Widget build(BuildContext context) {
    final MhsController controller = Get.find<MhsController>();

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
                Obx(() {
                  bool isEligible = controller.isEligibleForSidang;
                  
                  return Column(
                    children: [
                      if (!isEligible)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Anda belum mendapatkan rekomendasi sidang dari Pembimbing Utama dan Pendamping.",
                                  style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isEligible
                              ? () => Get.to(() => const FormDaftarSidangView())
                              : () {
                                  Get.snackbar(
                                    "Akses Ditolak",
                                    "Anda harus mendapatkan rekomendasi dari kedua pembimbing di logbook bimbingan terlebih dahulu.",
                                    backgroundColor: Colors.red.withOpacity(0.8),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(20),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEligible ? const Color(0xFF4A89FF) : Colors.grey.shade400,
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
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
