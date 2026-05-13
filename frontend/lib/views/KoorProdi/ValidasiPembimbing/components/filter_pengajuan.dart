import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/koorprodi_controller.dart';

class FilterPengajuan extends StatefulWidget {
  const FilterPengajuan({super.key});

  @override
  State<FilterPengajuan> createState() => _FilterPengajuanState();
}

class _FilterPengajuanState extends State<FilterPengajuan> {
  final KoorProdiController controller = Get.find<KoorProdiController>();

  late List<String> tempSelectedDosen;
  late List<String> tempSelectedTahunAjar;
  late List<String> tempSelectedStatus;

  @override
  void initState() {
    super.initState();
    tempSelectedDosen = List.from(controller.selectedDosen);
    tempSelectedTahunAjar = List.from(controller.selectedTahunAjar);
    tempSelectedStatus = List.from(controller.selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    tempSelectedDosen.clear();
                    tempSelectedTahunAjar.clear();
                    tempSelectedStatus.clear();
                  });
                },
                child: const Text("Reset Filter", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          // --- Filter Dosen ---
          const Text("Dosen Pembimbing", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(() => Wrap(
            spacing: 8,
            children: controller.availableDosen.map((name) {
              bool isSelected = tempSelectedDosen.contains(name);
              return FilterChip(
                label: Text(name, style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    val ? tempSelectedDosen.add(name) : tempSelectedDosen.remove(name);
                  });
                },
                selectedColor: Colors.blue.shade100,
                checkmarkColor: Colors.blue,
              );
            }).toList(),
          )),
          const SizedBox(height: 16),

          // --- Filter Tahun Ajar ---
          const Text("Tahun Ajar", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(() => Wrap(
            spacing: 8,
            children: controller.availableTahunAjar.map((year) {
              bool isSelected = tempSelectedTahunAjar.contains(year);
              return FilterChip(
                label: Text(year, style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    val ? tempSelectedTahunAjar.add(year) : tempSelectedTahunAjar.remove(year);
                  });
                },
                selectedColor: Colors.blue.shade100,
                checkmarkColor: Colors.blue,
              );
            }).toList(),
          )),
          const SizedBox(height: 16),

          // --- Filter Status ---
          const Text("Status Pengajuan", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStatusChip("diajukan", "Menunggu"),
              const SizedBox(width: 8),
              _buildStatusChip("disetujui", "Disetujui"),
            ],
          ),
          const SizedBox(height: 32),

          // --- Action Button ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                controller.applyFilter(
                  dosen: tempSelectedDosen,
                  tahunAjar: tempSelectedTahunAjar,
                  status: tempSelectedStatus,
                );
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Terapkan Filter", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String value, String label) {
    bool isSelected = tempSelectedStatus.contains(value);
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: (val) {
        setState(() {
          val ? tempSelectedStatus.add(value) : tempSelectedStatus.remove(value);
        });
      },
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue,
    );
  }
}
