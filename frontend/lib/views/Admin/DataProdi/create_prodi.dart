import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';

class CreateProdiPage extends StatefulWidget {
  const CreateProdiPage({super.key});

  @override
  State<CreateProdiPage> createState() => _CreateProdiPageState();
}

class _CreateProdiPageState extends State<CreateProdiPage> {
  final AdminController controller = Get.find<AdminController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController kodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text(
          "Tambah Program Studi", 
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
                    controller.addProdi({
                      "nama_prodi": namaController.text, 
                      "kode_prodi": kodeController.text
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
                child: controller.isLoadingProdi.value 
                  ? const SizedBox(
                      height: 20, 
                      width: 20, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    ) 
                  : const Text("Simpan Program Studi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
