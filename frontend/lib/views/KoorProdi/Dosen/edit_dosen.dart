import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/koorprodi_controller.dart';
import '../../../models/dosen_model.dart';

class EditDosenPage extends StatefulWidget {
  final Dosen dosen;
  const EditDosenPage({super.key, required this.dosen});

  @override
  State<EditDosenPage> createState() => _EditDosenPageState();
}

class _EditDosenPageState extends State<EditDosenPage> {
  final KoorProdiController controller = Get.find<KoorProdiController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nipController;
  late TextEditingController _nidnController;
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _alamatController;
  final TextEditingController _passwordController = TextEditingController();

  String? selectedJenisKelamin;

  final List<Map<String, String>> jenisKelaminOptions = [
    {'label': 'Laki-laki', 'value': 'Laki-laki'},
    {'label': 'Perempuan', 'value': 'Perempuan'},
  ];

  @override
  void initState() {
    super.initState();
    _nipController = TextEditingController(text: widget.dosen.nip);
    _nidnController = TextEditingController(text: widget.dosen.nidn);
    _namaController = TextEditingController(text: widget.dosen.namaDosen);
    _emailController = TextEditingController(text: widget.dosen.email);
    _alamatController = TextEditingController(text: widget.dosen.alamat);
    selectedJenisKelamin = widget.dosen.jenisKelamin;
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
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Dosen", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _nipController,
                decoration: const InputDecoration(
                  labelText: "NIP", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "NIP wajib diisi" : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _nidnController,
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
                  labelText: "Password Baru (Kosongkan jika tidak diubah)", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(height: 40),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoadingDosen.value ? null : () {
                  if (_formKey.currentState!.validate()) {
                    final Map<String, dynamic> data = {
                      "nip": _nipController.text,
                      "nidn": _nidnController.text,
                      "nama_dosen": _namaController.text,
                      "jenis_kelamin": selectedJenisKelamin,
                      "alamat": _alamatController.text,
                      "email": _emailController.text,
                    };
                    if (_passwordController.text.isNotEmpty) {
                      data["password"] = _passwordController.text;
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
