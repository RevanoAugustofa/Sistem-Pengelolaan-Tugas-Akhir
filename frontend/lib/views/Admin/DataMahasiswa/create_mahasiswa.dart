import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';

class CreateMahasiswaPage extends StatefulWidget {
  const CreateMahasiswaPage({super.key});

  @override
  State<CreateMahasiswaPage> createState() => _CreateMahasiswaPageState();
}

class _CreateMahasiswaPageState extends State<CreateMahasiswaPage> {
  final AdminController controller = Get.find<AdminController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int? selectedProdiId;
  int? selectedTahunAjarId;

  @override
  void initState() {
    super.initState();
    controller.fetchProdi();
    controller.fetchTahunAjar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Tambah Mahasiswa Baru", 
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
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Mahasiswa", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(
                  labelText: "NPM / NIM", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "NPM wajib diisi" : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _emailController,
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
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.length < 6 ? "Minimal 6 karakter" : null,
              ),
              const SizedBox(height: 25),
              Obx(() => DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Prodi", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                value: selectedProdiId,
                items: controller.listProdi.map((prodi) {
                  return DropdownMenuItem<int>(
                    value: prodi.id,
                    child: Text(prodi.namaProdi ?? "-"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedProdiId = val),
                validator: (v) => v == null ? "Prodi wajib dipilih" : null,
              )),
              const SizedBox(height: 25),
              Obx(() => DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Tahun Ajar / Angkatan", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                value: selectedTahunAjarId,
                items: controller.listTahunAjar.map((tahun) {
                  return DropdownMenuItem<int>(
                    value: tahun.id,
                    child: Text(tahun.tahunAjar ?? "-"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedTahunAjarId = val),
                validator: (v) => v == null ? "Tahun Ajar wajib dipilih" : null,
              )),
              const SizedBox(height: 40),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoadingMahasiswa.value ? null : () {
                  if (_formKey.currentState!.validate()) {
                    final data = {
                      "id_prodi": selectedProdiId,
                      "id_tahun_ajar": selectedTahunAjarId,
                      "nim": _nimController.text,
                      "nama_mahasiswa": _namaController.text,
                      "email": _emailController.text,
                      "password": _passwordController.text,
                    };
                    controller.addMahasiswa(data);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: const Color(0xFF4FA5FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: controller.isLoadingMahasiswa.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : const Text("Simpan Data Mahasiswa", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
