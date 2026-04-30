import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/prodi_model.dart';

class EditProdiPage extends StatefulWidget {
  final Prodi prodi;
  const EditProdiPage({super.key, required this.prodi});

  @override
  State<EditProdiPage> createState() => _EditProdiPageState();
}

class _EditProdiPageState extends State<EditProdiPage> {
  final AdminController controller = Get.find<AdminController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController kodeController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.prodi.namaProdi);
    kodeController = TextEditingController(text: widget.prodi.kodeProdi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background halaman Putih
      appBar: AppBar(
        title: const Text(
          "Edit Program Studi", 
          style: TextStyle(color: Color(0xFF1E3475), fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white, // Header Putih
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF1E3475), size: 30),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0), // Border tipis di bawah header
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: namaController, 
                decoration: const InputDecoration(
                  labelText: "Nama Program Studi", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ), 
                validator: (v) => v!.isEmpty ? "Nama prodi wajib diisi" : null
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: kodeController, 
                decoration: const InputDecoration(
                  labelText: "Kode Prodi", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ), 
                validator: (v) => v!.isEmpty ? "Kode prodi wajib diisi" : null
              ),
              const SizedBox(height: 40),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoadingProdi.value ? null : () {
                  if (_formKey.currentState!.validate()) {
                    controller.updateProdi(widget.prodi.id!, {
                      "nama_prodi": namaController.text, 
                      "kode_prodi": kodeController.text
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52), 
                  backgroundColor: const Color(0xFF4FA5FF), // Biru filter
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), 
                  ),
                ),
                child: controller.isLoadingProdi.value 
                  ? const SizedBox(
                      height: 20, 
                      width: 20, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    ) 
                  : const Text("Perbarui Program Studi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
