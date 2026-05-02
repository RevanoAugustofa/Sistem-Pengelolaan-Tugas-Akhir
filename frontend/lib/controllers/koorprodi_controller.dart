import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/pengajuan_pembimbing_model.dart';
import '../models/dosen_model.dart';
import '../services/koorprodi_service.dart';

class KoorProdiController extends GetxController {
  final KoorProdiService _service = KoorProdiService();

  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var listPengajuan = <PengajuanPembimbingModel>[].obs;
  var listDosen = <Dosen>[].obs;
  
  // Pagination states
  int currentPage = 1;
  int lastPage = 1;
  bool get hasMore => currentPage < lastPage;

  // Filter states
  var selectedDosen = <String>[].obs;
  var selectedTahunAjar = <String>[].obs;
  var selectedStatus = <String>[].obs;
  String searchQuery = "";

  @override
  void onInit() {
    super.onInit();
    fetchPengajuan();
    fetchDosen();
  }

  void fetchDosen() async {
    try {
      var data = await _service.getDosen();
      listDosen.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data dosen: $e");
    }
  }

  Future<void> updateSupervisor(int id, int idUtama, int idPendamping) async {
    try {
      isLoading(true);
      bool success = await _service.updateSupervisor(id, idUtama, idPendamping);
      if (success) {
        refreshData();
        Get.snackbar("Sukses", "Dosen pembimbing berhasil diperbarui",
            backgroundColor: Colors.green.withOpacity(0.8), colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Gagal memperbarui dosen pembimbing");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Get unique Dosen names from list (Note: with server pagination, this only shows from loaded items)
  List<String> get availableDosen {
    var names = <String>{};
    for (var p in listPengajuan) {
      if (p.pembimbingUtama?.namaDosen != null) names.add(p.pembimbingUtama!.namaDosen!);
      if (p.pembimbingPendamping?.namaDosen != null) names.add(p.pembimbingPendamping!.namaDosen!);
    }
    return names.toList()..sort();
  }

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
    refreshData();
  }

  void resetFilter() {
    selectedDosen.clear();
    selectedTahunAjar.clear();
    selectedStatus.clear();
    refreshData();
  }

  void updateSearch(String query) {
    searchQuery = query;
    // Debounce can be added here if needed, but for now we refresh immediately
    refreshData();
  }

  void refreshData() {
    currentPage = 1;
    listPengajuan.clear();
    fetchPengajuan();
  }

  void fetchPengajuan() async {
    if (isLoading.value) return;
    try {
      isLoading(true);
      var result = await _service.getPengajuanPembimbing(
        page: currentPage,
        search: searchQuery,
        status: selectedStatus,
        tahunAjar: selectedTahunAjar,
      );
      
      listPengajuan.assignAll(result['items']);
      currentPage = result['current_page'];
      lastPage = result['last_page'];
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data pengajuan: $e");
    } finally {
      isLoading(false);
    }
  }

  void loadMore() async {
    if (isMoreLoading.value || !hasMore) return;
    try {
      isMoreLoading(true);
      var result = await _service.getPengajuanPembimbing(
        page: currentPage + 1,
        search: searchQuery,
        status: selectedStatus,
        tahunAjar: selectedTahunAjar,
      );
      
      listPengajuan.addAll(result['items']);
      currentPage = result['current_page'];
      lastPage = result['last_page'];
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data tambahan: $e");
    } finally {
      isMoreLoading(false);
    }
  }

  Future<void> validasi(int id, String status) async {
    try {
      isLoading(true);
      bool success = await _service.validasiPengajuan(id, status);
      if (success) {
        refreshData();
        Get.snackbar("Sukses", "Validasi berhasil diperbarui",
            backgroundColor: Colors.green.withOpacity(0.8), colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Gagal memvalidasi pengajuan");
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
      
      refreshData();
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
