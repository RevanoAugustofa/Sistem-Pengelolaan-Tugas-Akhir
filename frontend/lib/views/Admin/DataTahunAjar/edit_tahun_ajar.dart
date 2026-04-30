import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/tahun_ajar_model.dart';

class EditTahunAjarPage extends StatefulWidget {
  final TahunAjar tahunAjar;
  const EditTahunAjarPage({super.key, required this.tahunAjar});

  @override
  State<EditTahunAjarPage> createState() => _EditTahunAjarPageState();
}

class _EditTahunAjarPageState extends State<EditTahunAjarPage> {
  final AdminController controller = Get.find<AdminController>();
  late TextEditingController _tahunController;

  @override
  void initState() {
    super.initState();
    _tahunController = TextEditingController(text: widget.tahunAjar.tahunAjar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(16, 168, 229, 1),
        title: const Text("Edit Tahun Ajar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  controller.updateTahunAjar(widget.tahunAjar.id!, data);
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
