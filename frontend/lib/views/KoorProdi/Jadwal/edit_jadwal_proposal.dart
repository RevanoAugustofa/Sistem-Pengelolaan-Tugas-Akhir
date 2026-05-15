import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/koorprodi_controller.dart';
import '../../../models/jadwal_model.dart';
import 'package:intl/intl.dart';

class EditJadwalProposalPage extends StatefulWidget {
  final JadwalModel jadwal;
  const EditJadwalProposalPage({super.key, required this.jadwal});

  @override
  State<EditJadwalProposalPage> createState() => _EditJadwalProposalPageState();
}

class _EditJadwalProposalPageState extends State<EditJadwalProposalPage> {
  final KoorProdiController controller = Get.find<KoorProdiController>();
  final _formKey = GlobalKey<FormState>();

  int? _selectedPengujiUtama;
  int? _selectedPengujiPendamping;
  int? _selectedRuangan;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedPengujiUtama = widget.jadwal.idPengujiUtama;
    _selectedPengujiPendamping = widget.jadwal.idPengujiPendamping;
    _selectedRuangan = widget.jadwal.idRuangSidang;
    
    if (widget.jadwal.tanggal != null) {
      _selectedDate = DateFormat("yyyy-MM-dd").parse(widget.jadwal.tanggal!);
      _dateController.text = widget.jadwal.tanggal!;
    }
    
    if (widget.jadwal.waktuMulai != null) {
      final parts = widget.jadwal.waktuMulai!.split(':');
      _startTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      _startTimeController.text = widget.jadwal.waktuMulai!;
    }

    if (widget.jadwal.waktuSelesai != null) {
      final parts = widget.jadwal.waktuSelesai!.split(':');
      _endTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      _endTimeController.text = widget.jadwal.waktuSelesai!;
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat("yyyy-MM-dd").format(picked);
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _startTime : _endTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final timeStr = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
        if (isStart) {
          _startTime = picked;
          _startTimeController.text = timeStr;
        } else {
          _endTime = picked;
          _endTimeController.text = timeStr;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Jadwal Proposal", 
          style: TextStyle(color: Color(0xFF1E3475), fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF1E3475), size: 30),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mahasiswa: ${widget.jadwal.mahasiswa?.namaMahasiswa ?? '-'}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              Text(
                "NPM: ${widget.jadwal.mahasiswa?.npm ?? '-'}",
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
              const SizedBox(height: 25),
              
              DropdownButtonFormField<int>(
                value: _selectedPengujiUtama,
                decoration: const InputDecoration(
                  labelText: "Penguji Utama",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                items: controller.listDosen.map((d) {
                  return DropdownMenuItem<int>(
                    value: d.id,
                    child: Text(d.namaDosen ?? "-"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedPengujiUtama = val),
                validator: (v) => v == null ? "Penguji utama wajib dipilih" : null,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<int>(
                value: _selectedPengujiPendamping,
                decoration: const InputDecoration(
                  labelText: "Penguji Pendamping",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                items: controller.listDosen.map((d) {
                  return DropdownMenuItem<int>(
                    value: d.id,
                    child: Text(d.namaDosen ?? "-"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedPengujiPendamping = val),
                validator: (v) => v == null ? "Penguji pendamping wajib dipilih" : null,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<int>(
                value: _selectedRuangan,
                decoration: const InputDecoration(
                  labelText: "Ruangan",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                items: controller.listRuangan.map((r) {
                  return DropdownMenuItem<int>(
                    value: r.id,
                    child: Text(r.namaRuangan ?? "-"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedRuangan = val),
                validator: (v) => v == null ? "Ruangan wajib dipilih" : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: "Tanggal",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "Tanggal wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startTimeController,
                      readOnly: true,
                      onTap: () => _pickTime(true),
                      decoration: const InputDecoration(
                        labelText: "Waktu Mulai",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _endTimeController,
                      readOnly: true,
                      onTap: () => _pickTime(false),
                      decoration: const InputDecoration(
                        labelText: "Waktu Selesai",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoadingJadwal.value ? null : () {
                  if (_formKey.currentState!.validate()) {
                    final data = {
                      "id_mahasiswa": widget.jadwal.idMahasiswa,
                      "jenis_sidang": "proposal",
                      "id_penguji_utama": _selectedPengujiUtama,
                      "id_penguji_pendamping": _selectedPengujiPendamping,
                      "id_ruang_sidang": _selectedRuangan,
                      "tanggal": _dateController.text,
                      "waktu_mulai": _startTimeController.text,
                      "waktu_selesai": _endTimeController.text,
                    };
                    controller.updateJadwal(widget.jadwal.id!, data);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: const Color(0xFF4FA5FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: controller.isLoadingJadwal.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : const Text("Perbarui Jadwal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
