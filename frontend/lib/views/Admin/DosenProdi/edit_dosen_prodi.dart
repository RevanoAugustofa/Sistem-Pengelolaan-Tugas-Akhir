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
  Map<int, String?> selectedJabatan = {}; // Untuk menyimpan jabatan per prodi

  @override
  void initState() {
    super.initState();
    controller.fetchProdi();
    if (widget.dosen.prodi != null) {
      selectedProdiIds = widget.dosen.prodi!.map((p) => p.id!).toList();
      for (var p in widget.dosen.prodi!) {
        selectedJabatan[p.id!] = p.jabatan;
      }
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
              "Pilih Program Studi & Jabatan:",
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
                
                return Column(
                  children: [
                    CheckboxListTile(
                      title: Text(prodi.namaProdi ?? "-"),
                      subtitle: Text(prodi.kodeProdi ?? ""),
                      value: isChecked,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            selectedProdiIds.add(prodi.id!);
                          } else {
                            selectedProdiIds.remove(prodi.id);
                            selectedJabatan.remove(prodi.id);
                          }
                        });
                      },
                    ),
                    if (isChecked) 
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: "Jabatan di Prodi ini",
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          value: selectedJabatan[prodi.id],
                          items: const [
                            DropdownMenuItem(value: null, child: Text("Dosen Biasa")),
                            DropdownMenuItem(value: "koorprodi", child: Text("Koorprodi")),
                            DropdownMenuItem(value: "admin", child: Text("Admin")),
                          ],
                          onChanged: (val) {
                            setState(() {
                              selectedJabatan[prodi.id!] = val;
                            });
                          },
                        ),
                      ),
                    const Divider(),
                  ],
                );
              },
            )),

            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoadingDosenProdi.value ? null : () {
                  List<Map<String, dynamic>> prodisData = selectedProdiIds.map((id) => {
                    "id": id,
                    "jabatan": selectedJabatan[id]
                  }).toList();
                  controller.updateDosenProdi(widget.dosen.id!, prodisData);
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
                  : const Text("Perbarui Relasi & Jabatan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
