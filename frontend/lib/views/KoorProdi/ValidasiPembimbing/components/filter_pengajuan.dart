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
    const primaryColor = Color(0xFF10A8E5);
    const darkBlue = Color(0xFF2D3142);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter Data",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- Filter Status ---
          const Text(
            "Status Pengajuan",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildFilterChip(
                label: "Semua",
                isSelected: tempSelectedStatus.isEmpty,
                onTap: () => setState(() => tempSelectedStatus.clear()),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: "Menunggu",
                isSelected: tempSelectedStatus.contains("diajukan"),
                onTap: () => _toggleStatus("diajukan"),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: "Disetujui",
                isSelected: tempSelectedStatus.contains("disetujui"),
                onTap: () => _toggleStatus("disetujui"),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // --- Filter Tahun Ajar ---
          const Text(
            "Tahun Ajar",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingMahasiswa.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Pilih Tahun Ajar"),
                  value: tempSelectedTahunAjar.isEmpty ? null : tempSelectedTahunAjar.first,
                  items: [
                    const DropdownMenuItem(
                      value: "",
                      child: Text("Semua Tahun Ajar"),
                    ),
                    ...controller.listTahunAjar.map((tahun) {
                      return DropdownMenuItem(
                        value: tahun.tahunAjar,
                        child: Text(tahun.tahunAjar ?? "-"),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      tempSelectedTahunAjar.clear();
                      if (value != null && value.isNotEmpty) {
                        tempSelectedTahunAjar.add(value);
                      }
                    });
                  },
                ),
              ),
            );
          }),

          const SizedBox(height: 24),

          // --- Filter Dosen ---
          const Text(
            "Dosen Pembimbing",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.availableDosen.map((name) {
                  bool isSelected = tempSelectedDosen.contains(name);
                  return _buildFilterChip(
                    label: name,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        isSelected ? tempSelectedDosen.remove(name) : tempSelectedDosen.add(name);
                      });
                    },
                  );
                }).toList(),
              )),

          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      tempSelectedDosen.clear();
                      tempSelectedTahunAjar.clear();
                      tempSelectedStatus.clear();
                    });
                    controller.resetFilter();
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(color: primaryColor),
                  ),
                  child: const Text(
                    "Reset",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
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
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Terapkan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleStatus(String status) {
    setState(() {
      if (tempSelectedStatus.contains(status)) {
        tempSelectedStatus.remove(status);
      } else {
        tempSelectedStatus.add(status);
      }
    });
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const primaryColor = Color(0xFF10A8E5);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

