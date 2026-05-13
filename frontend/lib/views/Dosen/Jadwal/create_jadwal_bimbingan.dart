import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/dosen_controller.dart';

class CreateJadwalBimbinganPage extends StatefulWidget {
  const CreateJadwalBimbinganPage({super.key});

  @override
  State<CreateJadwalBimbinganPage> createState() => _CreateJadwalBimbinganPageState();
}

class _CreateJadwalBimbinganPageState extends State<CreateJadwalBimbinganPage> {
  final DosenController controller = Get.find<DosenController>();
  final _formKey = GlobalKey<FormState>();
  
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedMetode = 'offline';
  final TextEditingController kuotaController = TextEditingController(text: '1');
  final TextEditingController tempatLinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Tambah Jadwal Bimbingan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tanggal",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd-MM-yyyy').format(selectedDate)),
                      const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Waktu",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    setState(() {
                      selectedTime = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedTime.format(context)),
                      const Icon(Icons.access_time, color: Colors.blue, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Metode Bimbingan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Offline"),
                      value: 'offline',
                      groupValue: selectedMetode,
                      onChanged: (value) => setState(() => selectedMetode = value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Online"),
                      value: 'online',
                      groupValue: selectedMetode,
                      onChanged: (value) => setState(() => selectedMetode = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                selectedMetode == 'offline' ? "Tempat" : "Link (GMeet/Zoom)",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: tempatLinkController,
                decoration: InputDecoration(
                  hintText: selectedMetode == 'offline' ? "Contoh: Ruang Dosen" : "Contoh: https://meet.google.com/...",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value == null || value.isEmpty ? "Harus diisi" : null,
              ),
              const SizedBox(height: 20),

              const Text(
                "Kuota (Jumlah Mahasiswa)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: kuotaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Contoh: 5",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Harus diisi";
                  if (int.tryParse(value) == null) return "Harus berupa angka";
                  return null;
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoadingJadwal.value ? null : () {
                    if (_formKey.currentState!.validate()) {
                      final timeStr = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00";
                      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
                      
                      final Map<String, dynamic> data = {
                        'waktu_tanggal': "$dateStr $timeStr",
                        'kuota': int.parse(kuotaController.text),
                        'metode_bimbingan': selectedMetode,
                        'tempat_link': tempatLinkController.text,
                      };
                      
                      controller.addJadwalBimbingan(data);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3475),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: controller.isLoadingJadwal.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Simpan Jadwal",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
