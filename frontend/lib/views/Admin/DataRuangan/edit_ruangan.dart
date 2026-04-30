import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/ruangan_model.dart';

class EditRuanganPage extends StatefulWidget {
  final Ruangan ruangan;
  const EditRuanganPage({super.key, required this.ruangan});

  @override
  State<EditRuanganPage> createState() => _EditRuanganPageState();
}

class _EditRuanganPageState extends State<EditRuanganPage> {
  final AdminController controller = Get.find<AdminController>();
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
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        title: const Text("Edit Ruangan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: "Nama Ruangan", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _gedungController,
              decoration: const InputDecoration(labelText: "Gedung", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final data = {
                    "nama_ruangan": _namaController.text,
                    "gedung": _gedungController.text,
                  };
                  controller.updateRuangan(widget.ruangan.id!, data);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(16, 168, 229, 1)),
                child: const Text("Perbarui", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
