import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Modals/form_proposal_modal.dart';
import '../../../controllers/mhs_controller.dart';

class TugasAkhirProposalMhsView extends StatelessWidget {
  const TugasAkhirProposalMhsView({super.key});

  void _showUploadModal() {
    Get.bottomSheet(
      const FormProposalModal(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final MhsController controller = Get.put(MhsController());

    return RefreshIndicator(
      onRefresh: () async {
        controller.fetchDashboardData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CARD PROPOSAL
            Obx(() {
              String judul = controller.proposalTitle.value;
              String file = controller.proposalFile.value;

              bool sudahUpload = file.isNotEmpty;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ISI CARD
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Judul Proposal",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            judul.isNotEmpty
                                ? judul
                                : "Belum ada judul proposal",
                            style: const TextStyle(fontSize: 15, height: 1.5),
                          ),
                        ],
                      ),
                    ),

                    /// FOOTER CARD
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Dokumen :",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),

                              const SizedBox(width: 12),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: sudahUpload
                                      ? Colors.green
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  sudahUpload ? "Sudah Upload" : "Belum Upload",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          ElevatedButton(
                            onPressed: _showUploadModal,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A89FF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              sudahUpload ? "Ganti File" : "Upload File",
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            /// CARD CATATAN REVISI
            Obx(() {
              var listRevisi = controller.listRevisi;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Catatan Revisi",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (listRevisi.isNotEmpty)
                                Builder(
                                  builder: (context) {
                                    String dateStr = listRevisi.first['created_at'] ?? "";
                                    String formattedDate = "";
                                    try {
                                      if (dateStr.isNotEmpty) {
                                        DateTime dt = DateTime.parse(dateStr);
                                        formattedDate = DateFormat('d MMMM yyyy').format(dt);
                                      }
                                    } catch (e) {
                                      formattedDate = dateStr;
                                    }

                                    return Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );
                                  },
                                )
                              else
                                Text(
                                  "Belum ada catatan",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          Divider(color: Colors.grey.shade400),
                          const SizedBox(height: 8),

                          if (listRevisi.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Belum ada catatan revisi dari dosen penguji.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            ...listRevisi.map((revisi) {
                              String namaDosen = revisi['dosen']?['user']?['name'] ?? "Dosen";
                              List<dynamic> poinRevisi = revisi['catatan_revisi'] ?? [];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...poinRevisi.map((poin) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildRevisionItem(
                                      poin.toString(),
                                      namaDosen,
                                    ),
                                  )).toList(),
                                ],
                              );
                            }).toList(),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Dokumen :",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.proposalFile.value.isNotEmpty ? Colors.green : Colors.grey,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  controller.proposalFile.value.isNotEmpty ? "Sudah Upload" : "Belum Upload",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: _showUploadModal,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A89FF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              controller.proposalFile.value.isNotEmpty ? "Ganti File" : "Upload File",
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            /// BERITA ACARA
            const Center(
              child: Text(
                "Berita Acara Seminar Proposal",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 14),

            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  "preview Berita Acara",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A89FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Unduh Berita Acara",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  static Widget _buildRevisionItem(String revisi, String dosen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(revisi, style: const TextStyle(fontSize: 14, height: 1.5)),

        const SizedBox(height: 10),

        Text(
          "Dosen : $dosen",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
