import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/dosen_controller.dart';

class FilterMahasiswaModal extends StatelessWidget {
  const FilterMahasiswaModal({super.key});

  @override
  Widget build(BuildContext context) {
    final DosenController controller = Get.find<DosenController>();

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
                  color: Color(0xFF2D3142),
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          const Text(
            "Kategori",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Row(
            children: [
              _buildFilterChip(
                label: "Semua",
                isSelected: controller.selectedKategori.value == "",
                onTap: () => controller.selectedKategori.value = "",
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: "Bimbingan",
                isSelected: controller.selectedKategori.value == "bimbingan",
                onTap: () => controller.selectedKategori.value = "bimbingan",
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: "Diuji",
                isSelected: controller.selectedKategori.value == "diuji",
                onTap: () => controller.selectedKategori.value = "diuji",
              ),
            ],
          )),
          
          const SizedBox(height: 24),
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
            if (controller.isLoadingTahunAjar.value) {
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
                  value: controller.selectedTahunAjar.value.isEmpty 
                      ? null 
                      : controller.selectedTahunAjar.value,
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
                    controller.selectedTahunAjar.value = value ?? "";
                  },
                ),
              ),
            );
          }),
          
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.resetFilter();
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(color: Color(0xFF10A8E5)),
                  ),
                  child: const Text(
                    "Reset",
                    style: TextStyle(
                      color: Color(0xFF10A8E5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilter();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10A8E5),
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

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10A8E5).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF10A8E5) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF10A8E5) : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
