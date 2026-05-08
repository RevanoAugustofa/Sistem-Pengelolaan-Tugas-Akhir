import 'package:flutter/material.dart';
import 'package:frontend/models/ruangan_model.dart';
import 'package:frontend/models/rubrik_nilai_model.dart';
import 'package:frontend/models/jadwal_model.dart';
import 'package:get/get.dart';
import '../models/pengajuan_pembimbing_model.dart';
import '../models/dosen_model.dart';
import '../models/mahasiswa_model.dart';
import '../models/tahun_ajar_model.dart';
import '../models/prodi_model.dart';
import '../services/koorprodi_service.dart';

class KoorProdiController extends GetxController {
  final KoorProdiService _service = KoorProdiService();

  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var listPengajuan = <PengajuanPembimbingModel>[].obs;
  var listDosen = <Dosen>[].obs;
  
  // Mahasiswa management states
  var listMahasiswa = <Mahasiswa>[].obs;
  var listTahunAjar = <TahunAjar>[].obs;
  var listProdi = <Prodi>[].obs;
  var isLoadingMahasiswa = false.obs;

  // Dosen management states
  var listDosenManajemen = <Dosen>[].obs;
  var isLoadingDosen = false.obs;

  // Ruangan management states
  var listRuangan = <Ruangan>[].obs;
  var isLoadingRuangan = false.obs;

  // Rubrik Nilai management states
  var listRubrikNilai = <RubrikNilai>[].obs;
  var isLoadingRubrikNilai = false.obs;

  // Jadwal states
  var listJadwalProposal = <JadwalModel>[].obs;
  var listJadwalSidang = <JadwalModel>[].obs;
  var isLoadingJadwal = false.obs;

  // Rekap states
  var listRekap = <dynamic>[].obs;
  var isLoadingRekap = false.obs;

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
    fetchMahasiswa();
    fetchTahunAjar();
    fetchProdi();
    fetchDosenManajemen();
    fetchRuangan();
    fetchRubrikNilai();
    fetchJadwalProposal();
    fetchJadwalSidang();
  }

  Future<void> fetchProdi() async {
    try {
      var data = await _service.getProdi();
      listProdi.assignAll(data);
      print("Prodi fetched: ${listProdi.length}");
    } catch (e) {
      print("Error fetching prodi: $e");
      Get.snackbar("Error", "Gagal memuat data Prodi. Silakan coba lagi.", 
        backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void fetchJadwalProposal() async {
    try {
      isLoadingJadwal(true);
      var data = await _service.getJadwal('proposal');
      listJadwalProposal.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data jadwal proposal: $e");
    } finally {
      isLoadingJadwal(false);
    }
  }

  void fetchJadwalSidang() async {
    try {
      isLoadingJadwal(true);
      var data = await _service.getJadwal('sidang');
      listJadwalSidang.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data jadwal sidang: $e");
    } finally {
      isLoadingJadwal(false);
    }
  }

  Future<void> saveJadwal(Map<String, dynamic> data) async {
    try {
      bool success = await _service.storeJadwal(data);
      if (!success) {
        throw Exception("Gagal menyimpan ke database");
      }
    } catch (e) {
      throw e;
    }
  }

  void fetchRubrikNilai() async {
    try {
      isLoadingRubrikNilai(true);
      var data = await _service.getRubrikNilai();
      listRubrikNilai.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data rubrik nilai: $e");
    } finally {
      isLoadingRubrikNilai(false);
    }
  }

  Future<void> addRubrikNilai(Map<String, dynamic> data) async {
    try {
      isLoadingRubrikNilai(true);
      bool success = await _service.storeRubrikNilai(data);
      if (success) {
        fetchRubrikNilai();
        Get.back();
        Get.snackbar("Sukses", "Data Rubrik Nilai berhasil ditambahkan",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingRubrikNilai(false);
    }
  }

  Future<void> updateRubrikNilai(int id, Map<String, dynamic> data) async {
    try {
      isLoadingRubrikNilai(true);
      bool success = await _service.updateRubrikNilai(id, data);
      if (success) {
        fetchRubrikNilai();
        Get.back();
        Get.snackbar("Sukses", "Data Rubrik Nilai berhasil diperbarui",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingRubrikNilai(false);
    }
  }

  Future<void> deleteRubrikNilai(int id) async {
    try {
      isLoadingRubrikNilai(true);
      bool success = await _service.deleteRubrikNilai(id);
      if (success) {
        fetchRubrikNilai();
        Get.snackbar("Sukses", "Data Rubrik Nilai berhasil dihapus",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingRubrikNilai(false);
    }
  }

  void fetchRuangan() async {
    try {
      isLoadingRuangan(true);
      var data = await _service.getRuangan();
      listRuangan.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data ruangan: $e");
    } finally {
      isLoadingRuangan(false);
    }
  }

  Future<void> addRuangan(Map<String, dynamic> data) async {
    try {
      isLoadingRuangan(true);
      bool success = await _service.storeRuangan(data);
      if (success) {
        fetchRuangan();
        Get.back();
        Get.snackbar("Sukses", "Data Ruangan berhasil ditambahkan",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingRuangan(false);
    }
  }

  Future<void> updateRuangan(int id, Map<String, dynamic> data) async {
    try {
      isLoadingRuangan(true);
      bool success = await _service.updateRuangan(id, data);
      if (success) {
        fetchRuangan();
        Get.back();
        Get.snackbar("Sukses", "Data Ruangan berhasil diperbarui",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingRuangan(false);
    }
  }

  Future<void> deleteRuangan(int id) async {
    try {
      isLoadingRuangan(true);
      bool success = await _service.deleteRuangan(id);
      if (success) {
        fetchRuangan();
        Get.snackbar("Sukses", "Data Ruangan berhasil dihapus",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingRuangan(false);
    }
  }

  void fetchDosenManajemen() async {
    try {
      isLoadingDosen(true);
      var data = await _service.getDosenManajemen();
      listDosenManajemen.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data dosen: $e");
    } finally {
      isLoadingDosen(false);
    }
  }

  Future<void> addDosen(Map<String, dynamic> data) async {
    try {
      isLoadingDosen(true);
      bool success = await _service.storeDosen(data);
      if (success) {
        fetchDosenManajemen();
        Get.back();
        Get.snackbar("Sukses", "Data Dosen berhasil ditambahkan",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingDosen(false);
    }
  }

  Future<void> updateDosen(int id, Map<String, dynamic> data) async {
    try {
      isLoadingDosen(true);
      bool success = await _service.updateDosen(id, data);
      if (success) {
        fetchDosenManajemen();
        Get.back();
        Get.snackbar("Sukses", "Data Dosen berhasil diperbarui",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingDosen(false);
    }
  }

  Future<void> deleteDosen(int id) async {
    try {
      isLoadingDosen(true);
      bool success = await _service.deleteDosen(id);
      if (success) {
        fetchDosenManajemen();
        Get.snackbar("Sukses", "Data Dosen berhasil dihapus",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingDosen(false);
    }
  }

  void fetchMahasiswa() async {
    try {
      isLoadingMahasiswa(true);
      var data = await _service.getMahasiswa();
      listMahasiswa.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data mahasiswa: $e");
    } finally {
      isLoadingMahasiswa(false);
    }
  }

  void fetchTahunAjar() async {
    try {
      var data = await _service.getTahunAjar();
      listTahunAjar.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data tahun ajar: $e");
    }
  }

  Future<void> addMahasiswa(Map<String, dynamic> data) async {
    try {
      isLoadingMahasiswa(true);
      bool success = await _service.storeMahasiswa(data);
      if (success) {
        fetchMahasiswa();
        Get.back();
        Get.snackbar("Sukses", "Data Mahasiswa berhasil ditambahkan",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingMahasiswa(false);
    }
  }

  Future<void> updateMahasiswa(int id, Map<String, dynamic> data) async {
    try {
      isLoadingMahasiswa(true);
      bool success = await _service.updateMahasiswa(id, data);
      if (success) {
        fetchMahasiswa();
        Get.back();
        Get.snackbar("Sukses", "Data Mahasiswa berhasil diperbarui",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingMahasiswa(false);
    }
  }

  Future<void> deleteMahasiswa(int id) async {
    try {
      isLoadingMahasiswa(true);
      bool success = await _service.deleteMahasiswa(id);
      if (success) {
        fetchMahasiswa();
        Get.snackbar("Sukses", "Data Mahasiswa berhasil dihapus",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingMahasiswa(false);
    }
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

  void fetchRekap() async {
    try {
      isLoadingRekap(true);
      var data = await _service.getRekap();
      listRekap.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data rekap: $e");
    } finally {
      isLoadingRekap(false);
    }
  }
}
