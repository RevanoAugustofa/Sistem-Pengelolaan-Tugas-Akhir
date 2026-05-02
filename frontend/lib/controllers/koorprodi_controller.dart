import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/pengajuan_pembimbing_model.dart';
import '../services/koorprodi_service.dart';

class KoorProdiController extends GetxController {
  final KoorProdiService _service = KoorProdiService();

  var isLoading = false.obs;
  var listPengajuan = <PengajuanPembimbingModel>[].obs;
  
  // Filter states
  var selectedDosen = <String>[].obs;
  var selectedTahunAjar = <String>[].obs;
  var selectedStatus = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPengajuan();
  }

  // Get unique Dosen names from list
  List<String> get availableDosen {
    var names = <String>{};
    for (var p in listPengajuan) {
      if (p.pembimbingUtama?.namaDosen != null) names.add(p.pembimbingUtama!.namaDosen!);
      if (p.pembimbingPendamping?.namaDosen != null) names.add(p.pembimbingPendamping!.namaDosen!);
    }
    return names.toList()..sort();
  }

  // Get unique Tahun Ajar from list
  List<String> get availableTahunAjar {
    var years = <String>{};
    for (var p in listPengajuan) {
      if (p.mahasiswa?.angkatan != null) years.add(p.mahasiswa!.angkatan!);
    }
    return years.toList()..sort((a, b) => b.compareTo(a));
  }

  void applyFilter({
    required List<String> dosen,
    required List<String> tahunAjar,
    required List<String> status,
  }) {
    selectedDosen.assignAll(dosen);
    selectedTahunAjar.assignAll(tahunAjar);
    selectedStatus.assignAll(status);
  }

  void resetFilter() {
    selectedDosen.clear();
    selectedTahunAjar.clear();
    selectedStatus.clear();
  }

  List<PengajuanPembimbingModel> get filteredPengajuan {
    return listPengajuan.where((p) {
      // Dosen Filter (Utama or Pendamping)
      bool matchDosen = selectedDosen.isEmpty ||
          selectedDosen.contains(p.pembimbingUtama?.namaDosen) ||
          selectedDosen.contains(p.pembimbingPendamping?.namaDosen);

      // Tahun Ajar Filter
      bool matchTahun = selectedTahunAjar.isEmpty ||
          selectedTahunAjar.contains(p.mahasiswa?.angkatan);

      // Status Filter
      bool matchStatus = selectedStatus.isEmpty ||
          selectedStatus.contains(p.status ?? "diajukan");

      return matchDosen && matchTahun && matchStatus;
    }).toList();
  }

  void fetchPengajuan() async {
    try {
      isLoading(true);
      var data = await _service.getPengajuanPembimbing();
      listPengajuan.assignAll(data);
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> validasi(int id, String status) async {
    try {
      isLoading(true);
      bool success = await _service.validasiPengajuan(id, status);
      if (success) {
        fetchPengajuan();
        Get.snackbar("Sukses", "Validasi berhasil diperbarui",
            backgroundColor: Colors.green.withOpacity(0.8), colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> validasiMassal(List<int> ids, String status) async {
    try {
      isLoading(true);
      int successCount = 0;
      for (int id in ids) {
        bool success = await _service.validasiPengajuan(id, status);
        if (success) successCount++;
      }
      
      fetchPengajuan();
      if (successCount > 0) {
        Get.snackbar("Sukses", "$successCount data berhasil diperbarui",
            backgroundColor: Colors.green.withOpacity(0.8), colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
