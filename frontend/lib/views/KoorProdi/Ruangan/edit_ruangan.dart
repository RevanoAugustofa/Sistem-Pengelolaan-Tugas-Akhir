import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/koorprodi_controller.dart';
import '../../../models/ruangan_model.dart';

class EditRuanganPage extends StatefulWidget {
  final Ruangan ruangan;
  const EditRuanganPage({super.key, required this.ruangan});

  @override
  State<EditRuanganPage> createState() => _EditRuanganPageState();
}

class _EditRuanganPageState extends State<EditRuanganPage> {
  final KoorProdiController controller = Get.find<KoorProdiController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _gedungController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.ruangan.namaRuangan);
    _gedungController = TextEditingController(text: widget.ruangan.gedung);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Data Ruangan", 
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
                  labelText: "Nama Ruangan", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "Nama ruangan wajib diisi" : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _gedungController,
                decoration: const InputDecoration(
                  labelText: "Gedung", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "Nama gedung wajib diisi" : null,
              ),
              const SizedBox(height: 40),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoadingRuangan.value ? null : () {
                  if (_formKey.currentState!.validate()) {
                    final data = {
                      "nama_ruangan": _namaController.text,
                      "gedung": _gedungController.text,
                    };
                    controller.updateRuangan(widget.ruangan.id!, data);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: const Color(0xFF4FA5FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: controller.isLoadingRuangan.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : const Text("Perbarui Data Ruangan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
