import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/dosen_model.dart';

class EditDosenProdiPage extends StatefulWidget {
  final Dosen dosen;
  const EditDosenProdiPage({super.key, required this.dosen});

  @override
  State<EditDosenProdiPage> createState() => _EditDosenProdiPageState();
}

class _EditDosenProdiPageState extends State<EditDosenProdiPage> {
  final AdminController controller = Get.find<AdminController>();
  
  List<int> selectedProdiIds = []; 

  @override
  void initState() {
    super.initState();
    controller.fetchProdi();
    if (widget.dosen.prodi != null) {
      selectedProdiIds = widget.dosen.prodi!.map((p) => p.id!).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Relasi Dosen Prodi", 
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nama Dosen: ${widget.dosen.namaDosen}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3475)),
            ),
            Text(
              "NIP: ${widget.dosen.nip}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const Text(
              "Pilih Program Studi:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            
            Obx(() => controller.isLoadingProdi.value 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.listProdi.length,
              itemBuilder: (context, index) {
                var prodi = controller.listProdi[index];
                bool isChecked = selectedProdiIds.contains(prodi.id);
                return CheckboxListTile(
                  title: Text(prodi.namaProdi ?? "-"),
                  subtitle: Text(prodi.kodeProdi ?? ""),
                  value: isChecked,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selectedProdiIds.add(prodi.id!);
                      } else {
                        selectedProdiIds.remove(prodi.id);
                      }
                    });
                  },
                );
              },
            )),

            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoadingDosenProdi.value ? null : () {
                  controller.updateDosenProdi(widget.dosen.id!, selectedProdiIds);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xFF4FA5FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: controller.isLoadingDosenProdi.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Perbarui Relasi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
