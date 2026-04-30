import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/dosen_model.dart';

class EditDosenPage extends StatefulWidget {
  final Dosen dosen;
  const EditDosenPage({super.key, required this.dosen});

  @override
  State<EditDosenPage> createState() => _EditDosenPageState();
}

class _EditDosenPageState extends State<EditDosenPage> {
  final AdminController controller = Get.find<AdminController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController nipController;
  late TextEditingController emailController;
  final TextEditingController passwordController = TextEditingController();
  
  String? selectedJabatan;
  final List<Map<String, String>> jabatanOptions = [
    {'label': 'Koorprodi', 'value': 'koorprodi'},
    {'label': 'Admin', 'value': 'admin'},
    // {'label': 'Dosen Biasa', 'value': ''},
  ];

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.dosen.namaDosen);
    nipController = TextEditingController(text: widget.dosen.nip);
    emailController = TextEditingController(text: widget.dosen.email);
    selectedJabatan = widget.dosen.jabatan?.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Data Dosen", 
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
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: nipController,
                decoration: const InputDecoration(
                  labelText: "NIP", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "NIP wajib diisi" : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? "Email wajib diisi" : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password Baru (Kosongkan jika tidak diubah)", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(height: 25),
              DropdownButtonFormField<String>(
                value: selectedJabatan,
                decoration: InputDecoration(
                  labelText: "Jabatan (Opsional)", 
                  border: const OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: selectedJabatan != null && selectedJabatan!.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () => setState(() => selectedJabatan = null)) 
                    : null,
                ),
                items: jabatanOptions.map((opt) => DropdownMenuItem(value: opt['value'], child: Text(opt['label']!))).toList(),
                onChanged: (v) => setState(() => selectedJabatan = v),
              ),
              const SizedBox(height: 40),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoadingDosen.value ? null : () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> data = {
                      "nama_dosen": namaController.text,
                      "nip": nipController.text,
                      "email": emailController.text,
                      "jabatan": (selectedJabatan == null || selectedJabatan!.isEmpty) ? null : selectedJabatan,
                    };
                    if (passwordController.text.isNotEmpty) {
                      data["password"] = passwordController.text;
                    }
                    controller.updateDosen(widget.dosen.id!, data);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: const Color(0xFF4FA5FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: controller.isLoadingDosen.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : const Text("Perbarui Data Dosen", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
