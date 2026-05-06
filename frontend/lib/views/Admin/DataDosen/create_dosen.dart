import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';

class CreateDosenPage extends StatefulWidget {
  const CreateDosenPage({super.key});

  @override
  State<CreateDosenPage> createState() => _CreateDosenPageState();
}

class _CreateDosenPageState extends State<CreateDosenPage> {
  final AdminController controller = Get.find<AdminController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nipController = TextEditingController();
  final TextEditingController nidnController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  
  String? selectedJenisKelamin;

  final List<Map<String, String>> jenisKelaminOptions = [
    {'label': 'Laki-laki', 'value': 'Laki-laki'},
    {'label': 'Perempuan', 'value': 'Perempuan'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Tambah Dosen Baru", 
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
                controller: nidnController,
                decoration: const InputDecoration(
                  labelText: "NIDN", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "NIDN wajib diisi" : null,
              ),
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Jenis Kelamin", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Laki-laki"),
                      value: "Laki-laki",
                      groupValue: selectedJenisKelamin,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (v) => setState(() => selectedJenisKelamin = v),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Perempuan"),
                      value: "Perempuan",
                      groupValue: selectedJenisKelamin,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (v) => setState(() => selectedJenisKelamin = v),
                    ),
                  ),
                ],
              ),
              if (selectedJenisKelamin == null)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("  Jenis kelamin wajib dipilih", style: TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 25),
              TextFormField(
                controller: alamatController,
                decoration: const InputDecoration(
                  labelText: "Alamat", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "Alamat wajib diisi" : null,
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
                  labelText: "Password", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.length < 6 ? "Minimal 6 karakter" : null,
              ),
              const SizedBox(height: 40),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoadingDosen.value ? null : () {
                  if (_formKey.currentState!.validate()) {
                    controller.addDosen({
                      "nama_dosen": namaController.text,
                      "nip": nipController.text,
                      "nidn": nidnController.text,
                      "jenis_kelamin": selectedJenisKelamin,
                      "alamat": alamatController.text,
                      "email": emailController.text,
                      "password": passwordController.text,
                    });
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
                  : const Text("Simpan Data Dosen", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
