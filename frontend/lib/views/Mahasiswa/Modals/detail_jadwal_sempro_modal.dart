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

    // Logika pemilihan judul
    String? judulAsli = jadwal.mahasiswa?.proposal?.judulProposal;
    String? judulRevisi = jadwal.mahasiswa?.proposal?.revisiJudulProposal;
    String judulFinal = (judulRevisi != null && judulRevisi.isNotEmpty) ? judulRevisi : (judulAsli ?? 'Belum ada judul');

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER SECTION
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A89FF).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.event_note_rounded,
                            color: Color(0xFF4A89FF),
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Detail Jadwal Sempro",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF283D70),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // MAHASISWA CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mahasiswa",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF283D70),
                          ),
                        ),
                        Text(
                          "NPM: $npm",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // JUDUL PROPOSAL
                  const Text(
                    "Judul Proposal",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF283D70),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      judulFinal,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // WAKTU & TEMPAT
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoBox(
                          "Tanggal",
                          tanggal,
                          Icons.calendar_today_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoBox(
                          "Waktu",
                          jam,
                          Icons.access_time_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _buildInfoBox(
                    "Ruangan",
                    ruangan,
                    Icons.location_on_rounded,
                    width: double.infinity,
                  ),

                  const SizedBox(height: 24),

                  // DOSEN PENGUJI
                  const Text(
                    "Dosen Penguji",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF283D70),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDosenItem("Penguji Utama", jadwal.pengujiUtama?.namaDosen ?? "-"),
                  const SizedBox(height: 8),
                  _buildDosenItem("Penguji Pendamping", jadwal.pengujiPendamping?.namaDosen ?? "-"),

                  const SizedBox(height: 32),
                  ],
                  ),
                  ),
                  ),
          // ACTION BUTTON
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF283D70),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Tutup",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, IconData icon, {double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF4A89FF)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF283D70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosenItem(String role, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF4A89FF).withOpacity(0.1),
            child: const Icon(Icons.person_outline, size: 20, color: Color(0xFF4A89FF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF283D70),
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