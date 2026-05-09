import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/mhs_controller.dart';
import '../../../models/jadwal_model.dart';

class TugasAkhirBimbinganMhsView extends StatelessWidget {
  const TugasAkhirBimbinganMhsView({super.key});

  @override
  Widget build(BuildContext context) {
    final MhsController controller = Get.put(MhsController());

    return RefreshIndicator(
      onRefresh: () async {
        controller.fetchJadwalBimbingan();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Jadwal Bimbingan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Obx(() {
              if (controller.isLoadingJadwalBimbingan.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.listJadwalBimbingan.isEmpty) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Center(
                    child: Text(
                      "Belum ada jadwal bimbingan tersedia",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return Column(
                children: controller.listJadwalBimbingan.map((jadwal) {
                  return _buildJadwalBimbinganCard(jadwal);
                }).toList(),
              );
            }),
            const SizedBox(height: 24),
            const Text(
              "Logbook Bimbingan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // TAB

            // LIST LOGBOOK
            _buildLogbookCard(isEmpty: true),

            const SizedBox(height: 16),

            _buildLogbookCard(isEmpty: false),
            const SizedBox(height: 16),
            _buildFullBlueButton("Tambah Logbook"),
          ],
        ),
      ),
    );
  }

  Widget _buildJadwalBimbinganCard(JadwalModel jadwal) {
    String formattedDate = "";
    if (jadwal.waktuTanggal != null) {
      try {
        DateTime dt = DateTime.parse(jadwal.waktuTanggal!);
        formattedDate = DateFormat("EEEE dd, MMMM yyyy  HH:mm 'WIB'", 'id_ID').format(dt);
      } catch (e) {
        formattedDate = jadwal.waktuTanggal!;
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jadwal.dosen?.user?.name ?? "Dosen Tidak Diketahui",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 11),
                ),
                Text(
                  "Kuota tersisa (${jadwal.kuota ?? 0})",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF42A5F5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Daftar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogbookCard({bool isEmpty = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Jum’at 23 Juli 2026 \npembimbing utama / pendamping",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),

              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                ),
                child: const Text(
                  "lihat file",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ISI
          if (isEmpty)
            Center(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "tambah catatan",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            )
          else
            const Text(
              "Lorem ipsum dolor sit amet consectetur adipiscing elit. "
              "Consectetur adipiscing elit quisque faucibus ex sapien vitae. "
              "Ex sapien vitae pellentesque sem placerat in id. "
              "Placerat in id cursus mi pretium tellus duis. "
              "Pretium tellus duis convallis tempus leo eu aenean.",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
        ],
      ),
    );
  }

  Widget _buildBlueButton(String text) => ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4A89FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white)),
  );
  Widget _buildFullBlueButton(String text) =>
      SizedBox(width: double.infinity, child: _buildBlueButton(text));
}
