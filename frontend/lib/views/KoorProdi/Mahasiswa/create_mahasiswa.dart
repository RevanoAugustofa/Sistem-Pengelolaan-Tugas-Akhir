import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/koorprodi_controller.dart';

class CreateMahasiswaPage extends StatefulWidget {
  const CreateMahasiswaPage({super.key});

  @override
  State<CreateMahasiswaPage> createState() => _CreateMahasiswaPageState();
}

class _CreateMahasiswaPageState extends State<CreateMahasiswaPage> {
  final KoorProdiController controller = Get.find<KoorProdiController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  String? selectedJenisKelamin;
  int? selectedTahunAjarId;

  @override
  void initState() {
    super.initState();
    controller.fetchTahunAjar();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tglLahirController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
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
                controller: _tglLahirController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  labelText: "Tanggal Lahir", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (v) => v!.isEmpty ? "Tanggal lahir wajib diisi" : null,
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
                controller: _alamatController,
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
                  if (_formKey.currentState!.validate() && selectedJenisKelamin != null) {
                    final data = {
                      "id_tahun_ajar": selectedTahunAjarId,
                      "nim": _nimController.text,
                      "nama_mahasiswa": _namaController.text,
                      "tgl_lahir": _tglLahirController.text,
                      "jenis_kelamin": selectedJenisKelamin,
                      "alamat": _alamatController.text,
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

