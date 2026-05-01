import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/mhs_controller.dart';
import '../../../models/dosen_model.dart';

class DaftarDosenPembimbingMhsPage extends StatefulWidget {
  const DaftarDosenPembimbingMhsPage({super.key});

  @override
  State<DaftarDosenPembimbingMhsPage> createState() => _DaftarDosenPembimbingMhsPageState();
}

class _DaftarDosenPembimbingMhsPageState extends State<DaftarDosenPembimbingMhsPage> {
  final MhsController controller = Get.put(MhsController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController judulController = TextEditingController();
  int? selectedDosen1;
  int? selectedDosen2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Pendaftaran Pembimbing",
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
      body: Obx(() {
        if (controller.isLoadingDosen.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Silakan isi formulir di bawah ini untuk mengajukan pendaftaran dosen pembimbing Tugas Akhir.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 30),

                // Input Judul TA
                TextFormField(
                  controller: judulController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Judul Tugas Akhir",
                    hintText: "Masukkan rencana judul Tugas Akhir Anda",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (v) => v!.isEmpty ? "Judul wajib diisi" : null,
                ),
                const SizedBox(height: 25),

                // Dropdown Dosen Pembimbing 1
                DropdownButtonFormField<int>(
                  value: selectedDosen1,
                  decoration: const InputDecoration(
                    labelText: "Dosen Pembimbing 1",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  items: controller.listDosen.map((Dosen dosen) {
                    return DropdownMenuItem<int>(
                      value: dosen.id,
                      child: Text(dosen.namaDosen ?? "-"),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedDosen1 = val;
                    });
                  },
                  validator: (val) => val == null ? "Pilih Dosen Pembimbing 1" : null,
                ),
                const SizedBox(height: 25),

                // Dropdown Dosen Pembimbing 2
                DropdownButtonFormField<int>(
                  value: selectedDosen2,
                  decoration: const InputDecoration(
                    labelText: "Dosen Pembimbing 2",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  items: controller.listDosen.map((Dosen dosen) {
                    return DropdownMenuItem<int>(
                      value: dosen.id,
                      child: Text(dosen.namaDosen ?? "-"),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedDosen2 = val;
                    });
                  },
                  validator: (val) => val == null ? "Pilih Dosen Pembimbing 2" : null,
                ),
                const SizedBox(height: 40),

                // Tombol Simpan
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoadingAction.value ? null : () {
                    if (_formKey.currentState!.validate()) {
                      if (selectedDosen1 == selectedDosen2) {
                        Get.snackbar("Peringatan", "Dosen Pembimbing 1 dan 2 tidak boleh sama",
                            backgroundColor: Colors.orange, colorText: Colors.white);
                        return;
                      }
                      controller.submitPendaftaran({
                        "judul": judulController.text,
                        "pembimbing1_id": selectedDosen1,
                        "pembimbing2_id": selectedDosen2,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    backgroundColor: const Color(0xFF4FA5FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isLoadingAction.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text("Daftar Sekarang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                )),
              ],
            ),
          ),
        );
      }),
    );
  }
}
