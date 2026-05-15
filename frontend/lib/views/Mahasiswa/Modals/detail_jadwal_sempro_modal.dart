import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/jadwal_model.dart';

class DetailJadwalSemproModal extends StatelessWidget {
  final JadwalModel jadwal;
  const DetailJadwalSemproModal({super.key, required this.jadwal});

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "-";
    List<String> parts = time.split(':');
    if (parts.length >= 2) {
      return "${parts[0]}.${parts[1]}";
    }
    return time;
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";
    try {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    String nama = jadwal.mahasiswa?.namaMahasiswa ?? "Tidak ada nama";
    String npm = jadwal.mahasiswa?.npm ?? "-";
    String tanggal = _formatDate(jadwal.tanggal);
    String jam = "${_formatTime(jadwal.waktuMulai)} - ${_formatTime(jadwal.waktuSelesai)} WIB";
    String ruangan = jadwal.ruangan?.namaRuangan ?? "-";
    String penguji = "Penguji\n${jadwal.pengujiUtama?.namaDosen ?? '-'} \n${jadwal.pengujiPendamping?.namaDosen ?? '-'}";
    
    // Logika pemilihan judul: prioritas revisi_judul_proposal
    String? judulAsli = jadwal.mahasiswa?.proposal?.judulProposal;
    String? judulRevisi = jadwal.mahasiswa?.proposal?.revisiJudulProposal;
    String judulFinal = (judulRevisi != null && judulRevisi.isNotEmpty) ? judulRevisi : (judulAsli ?? 'Belum ada judul');
    
    String judul = "Judul proposal\n$judulFinal";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar for bottom sheet
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // TITLE
            const Text(
              "Detail Jadwal",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF283D70),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              nama,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              "NPM: $npm",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            // DETAIL ITEM
            _buildDetailItem(
              Icons.calendar_today_outlined,
              tanggal,
            ),

            const SizedBox(height: 20),

            _buildDetailItem(
              Icons.access_time_outlined,
              jam,
            ),

            const SizedBox(height: 20),

            _buildDetailItem(
              Icons.location_on_outlined,
              ruangan,
            ),

            const SizedBox(height: 20),

            _buildDetailItem(
              Icons.edit_square,
              penguji,
            ),

            const SizedBox(height: 20),

            _buildDetailItem(
              Icons.article_outlined,
              judul,
            ),

            const SizedBox(height: 35),

            // BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Tutup",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 26,
          color: Colors.grey.shade700,
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.3,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}