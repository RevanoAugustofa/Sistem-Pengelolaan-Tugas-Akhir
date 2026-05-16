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

            /// CARD HASIL SEMPRO
            Obx(() {
              var hasil = controller.hasilSempro;
              if (hasil.isEmpty) return const SizedBox.shrink();

              String status = hasil['status'] ?? "-";
              String nilaiTotal = hasil['nilai_total']?.toString() ?? "0";
              
              Color statusColor = status.toLowerCase() == 'lulus' 
                  ? Colors.green.shade700 
                  : (status.toLowerCase() == 'tidak lulus' ? Colors.red.shade700 : Colors.orange.shade700);

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
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
                                "Hasil Seminar Proposal",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: statusColor),
                                ),
                                child: Text(
                                  status.toUpperCase(),
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Nilai Total", style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 4),
                                  Text(
                                    "Berdasarkan akumulasi nilai penguji",
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                nilaiTotal,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A89FF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

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

            /// CARD AKSI (DOWNLOAD)
            Obx(() {
              var listRevisi = controller.listRevisi;
              // Check if we have results or revisions to show these buttons
              if (listRevisi.isEmpty && controller.hasilSempro.isEmpty) {
                return const SizedBox.shrink();
              }

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dokumen & Catatan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Button Catatan Revisi Penguji Utama
                    _buildActionButton(
                      label: "Catatan Revisi Penguji Utama",
                      icon: Icons.description_outlined,
                      onPressed: () {
                        // Logic to download/view primary examiner revision
                      },
                    ),
                    const SizedBox(height: 12),
                    
                    // Button Catatan Revisi Penguji Pendamping
                    _buildActionButton(
                      label: "Catatan Revisi Penguji Pendamping",
                      icon: Icons.description_outlined,
                      onPressed: () {
                        // Logic to download/view secondary examiner revision
                      },
                    ),
                    const SizedBox(height: 12),
                    
                    // Button Berita Acara
                    _buildActionButton(
                      label: "Berita Acara Seminar Proposal",
                      icon: Icons.picture_as_pdf_outlined,
                      color: const Color(0xFF4A89FF),
                      isPrimary: true,
                      onPressed: () {
                        // Logic to download/view Berita Acara
                      },
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isPrimary ? (color ?? const Color(0xFF4A89FF)) : Colors.transparent,
          side: BorderSide(color: color ?? (isPrimary ? Colors.transparent : Colors.grey.shade400)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isPrimary ? Colors.white : (color ?? Colors.black87)),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : (color ?? Colors.black87),
                fontWeight: FontWeight.w500, fontSize: 12,
              ),
            ),
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
