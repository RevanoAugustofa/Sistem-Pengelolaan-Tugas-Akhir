import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/dosen_controller.dart';

class FilterJadwalModal extends StatelessWidget {
  final String selectedTab;
  const FilterJadwalModal({super.key, required this.selectedTab});

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
                "Filter Jadwal",
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
            "Tanggal",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                controller.filterScheduleDate.value = formattedDate;
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.filterScheduleDate.value.isEmpty 
                        ? "Pilih Tanggal" 
                        : controller.filterScheduleDate.value,
                    style: TextStyle(
                      color: controller.filterScheduleDate.value.isEmpty ? Colors.grey : Colors.black,
                    ),
                  ),
                  const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                ],
              ),
            ),
          )),
          
          if (selectedTab != "Bimbingan") ...[
            const SizedBox(height: 24),
            const Text(
              "Ruangan",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isLoadingRuangan.value) {
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
                    hint: const Text("Pilih Ruangan"),
                    value: controller.filterScheduleRuangan.value.isEmpty 
                        ? null 
                        : controller.filterScheduleRuangan.value,
                    items: [
                      const DropdownMenuItem(
                        value: "",
                        child: Text("Semua Ruangan"),
                      ),
                      ...controller.listRuangan.map((ruangan) {
                        return DropdownMenuItem(
                          value: ruangan.namaRuangan,
                          child: Text(ruangan.namaRuangan ?? "-"),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      controller.filterScheduleRuangan.value = value ?? "";
                    },
                  ),
                ),
              );
            }),

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
                    value: controller.filterScheduleTahunAjar.value.isEmpty 
                        ? null 
                        : controller.filterScheduleTahunAjar.value,
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
                      controller.filterScheduleTahunAjar.value = value ?? "";
                    },
                  ),
                ),
              );
            }),
          ],
          
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.resetScheduleFilter();
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
                    controller.applyScheduleFilter();
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
}
