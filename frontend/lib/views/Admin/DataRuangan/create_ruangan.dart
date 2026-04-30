import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';

class CreateRuanganPage extends StatefulWidget {
  const CreateRuanganPage({super.key});

  @override
  State<CreateRuanganPage> createState() => _CreateRuanganPageState();
}

class _CreateRuanganPageState extends State<CreateRuanganPage> {
  final AdminController controller = Get.find<AdminController>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _gedungController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        title: const Text("Tambah Ruangan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  controller.addRuangan(data);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(16, 168, 229, 1)),
                child: const Text("Simpan", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
