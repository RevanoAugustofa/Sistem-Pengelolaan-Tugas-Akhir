import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';

class CreateTahunAjarPage extends StatefulWidget {
  const CreateTahunAjarPage({super.key});

  @override
  State<CreateTahunAjarPage> createState() => _CreateTahunAjarPageState();
}

class _CreateTahunAjarPageState extends State<CreateTahunAjarPage> {
  final AdminController controller = Get.find<AdminController>();
  final TextEditingController _tahunController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        title: const Text("Tambah Tahun Ajar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              controller: _tahunController,
              decoration: const InputDecoration(
                labelText: "Tahun Ajar (contoh: 2023/2024)",
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final data = {
                    "tahun_ajar": _tahunController.text,
                  };
                  controller.addTahunAjar(data);
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
