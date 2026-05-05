import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/koorprodi_controller.dart';
import '../../../models/rubrik_nilai_model.dart';

class EditRubrikNilaiPage extends StatefulWidget {
  final RubrikNilai rubrik;
  const EditRubrikNilaiPage({super.key, required this.rubrik});

  @override
  State<EditRubrikNilaiPage> createState() => _EditRubrikNilaiPageState();
}

class _EditRubrikNilaiPageState extends State<EditRubrikNilaiPage> {
  final KoorProdiController controller = Get.find<KoorProdiController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _kelompokController;
  late TextEditingController _kategoriController;
  late TextEditingController _persentaseController;
  
  String? _selectedJenis;
  final List<String> _jenisOptions = ['pembimbing utama','pembimbing pendamping','penguji utama','penguji pendamping'];

  @override
  void initState() {
    super.initState();
    _kelompokController = TextEditingController(text: widget.rubrik.kelompok);
    _kategoriController = TextEditingController(text: widget.rubrik.kategori);
    _persentaseController = TextEditingController(text: widget.rubrik.presentse?.toString());
    _selectedJenis = widget.rubrik.jenisDosen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Data Rubrik", 
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
              DropdownButtonFormField<String>(
                value: _selectedJenis,
                decoration: const InputDecoration(
                  labelText: "Jenis Dosen",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                items: _jenisOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.capitalizeFirst!),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedJenis = newValue;
                  });
                },
                validator: (v) => v == null ? "Jenis dosen wajib dipilih" : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _kelompokController,
                decoration: const InputDecoration(
                  labelText: "Kelompok", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "Kelompok wajib diisi" : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(
                  labelText: "Kategori", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) => v!.isEmpty ? "Kategori wajib diisi" : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _persentaseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Persentase (%)", 
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Persentase wajib diisi";
                  if (int.tryParse(v) == null) return "Harus berupa angka";
                  return null;
                },
              ),
              const SizedBox(height: 40),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoadingRubrikNilai.value ? null : () {
                  if (_formKey.currentState!.validate()) {
                    final data = {
                      "jenis_dosen": _selectedJenis,
                      "kelompok": _kelompokController.text,
                      "kategori": _kategoriController.text,
                      "presentse": int.parse(_persentaseController.text),
                    };
                    controller.updateRubrikNilai(widget.rubrik.id!, data);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: const Color(0xFF4FA5FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: controller.isLoadingRubrikNilai.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : const Text("Perbarui Data Rubrik", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
