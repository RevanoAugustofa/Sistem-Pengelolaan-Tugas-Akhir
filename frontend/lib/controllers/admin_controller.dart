import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/dosen_model.dart';
import '../models/mahasiswa_model.dart';
import '../models/user_model.dart';
import '../models/prodi_model.dart';
import '../models/ruangan_model.dart';
import '../models/tahun_ajar_model.dart';
import '../models/rubrik_nilai_model.dart';
import '../models/proposal_model.dart';
import '../models/pengajuan_pembimbing_model.dart';
import '../models/jadwal_model.dart';
import '../services/admin_service.dart';

class AdminController extends GetxController {
  final AdminService _service = AdminService();

  var isLoadingDosen = false.obs;
  var listDosen = <Dosen>[].obs;

  var isLoadingMahasiswa = false.obs;
  var listMahasiswa = <Mahasiswa>[].obs;

  var isLoadingUser = false.obs;
  var listUser = <User>[].obs;

  var isLoadingProdi = false.obs;
  var listProdi = <Prodi>[].obs;

  var isLoadingRuangan = false.obs;
  var listRuangan = <Ruangan>[].obs;

  var isLoadingTahunAjar = false.obs;
  var listTahunAjar = <TahunAjar>[].obs;

  var isLoadingRubrikNilai = false.obs;
  var listRubrikNilai = <RubrikNilai>[].obs;

  var isLoadingProposal = false.obs;
  var listProposal = <ProposalWithMahasiswa>[].obs;

  // --- REKAP ---
  var isLoadingRekap = false.obs;
  var listRekap = <dynamic>[].obs;

  // --- JADWAL ---
  var isLoadingJadwal = false.obs;
  var listJadwalProposal = <JadwalModel>[].obs;
  var listJadwalBimbingan = <JadwalModel>[].obs;
  var listJadwalSidang = <JadwalModel>[].obs;

  // --- HASIL AKHIR ---
  var isLoadingHasilAkhir = false.obs;
  var listHasilSempro = <dynamic>[].obs;
  var listHasilSidang = <dynamic>[].obs;

  var isLoadingPengajuanPembimbing = false.obs;
  var listPengajuanPembimbing = <PengajuanPembimbingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
    fetchJadwal();
    fetchHasilAkhir();
    fetchPengajuanPembimbing();
  }

  void fetchAllData() {
    fetchDosen();
    fetchMahasiswa();
    fetchUser();
    fetchProdi();
    fetchRuangan();
    fetchTahunAjar();
    fetchRubrikNilai();
    fetchProposal();
    fetchPengajuanPembimbing();
  }

  void fetchJadwal() async {
    try {
      isLoadingJadwal(true);
      var sempro = await _service.getJadwalSempro();
      listJadwalProposal.assignAll(sempro);

      var sidangta = await _service.getJadwalSidangTA();
      listJadwalSidang.assignAll(sidangta);

      var bimbingan = await _service.getJadwalBimbingan();
      listJadwalBimbingan.assignAll(bimbingan);
    } catch (e) {
      print("Error fetchJadwal: $e");
    } finally {
      isLoadingJadwal(false);
    }
  }

  void fetchHasilAkhir() async {
    try {
      isLoadingHasilAkhir(true);
      var sempro = await _service.getHasilSempro();
      listHasilSempro.assignAll(sempro);

      var sidang = await _service.getHasilSidang();
      listHasilSidang.assignAll(sidang);
    } catch (e) {
      print("Error fetchHasilAkhir: $e");
    } finally {
      isLoadingHasilAkhir(false);
    }
  }

  void fetchPengajuanPembimbing() async {
    try {
      isLoadingPengajuanPembimbing(true);
      var data = await _service.getPengajuanPembimbing();
      listPengajuanPembimbing.assignAll(data);
    } catch (e) {
      print("Error fetchPengajuanPembimbing: $e");
    } finally {
      isLoadingPengajuanPembimbing(false);
    }
  }

  // --- HELPER UNTUK ERROR ---
  void _handleError(dynamic e) {
    String message = e.toString();
    if (e is Map && e.containsKey('message')) {
      message = e['message'];
    }
    Get.snackbar("Terjadi Kesalahan", message, 
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white
    );
  }

  // --- DOSEN CRUD ---
  void fetchDosen() async {
    try {
      isLoadingDosen(true);
      var data = await _service.getDosen();
      listDosen.assignAll(data);
    } catch (e) { print(e); } finally { isLoadingDosen(false); }
  }

  Future<void> addDosen(Map<String, dynamic> data) async {
    try {
      isLoadingDosen(true);
      final result = await _service.storeDosen(data);
      if (result['success']) {
        fetchDosen();
        Get.back();
        Get.snackbar("Sukses", "Dosen berhasil ditambahkan");
      } else {
        Get.snackbar("Gagal", result['message'] ?? "Terjadi kesalahan saat menyimpan data",
          backgroundColor: Colors.orange.withOpacity(0.8), colorText: Colors.white);
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
      final result = await _service.updateDosen(id, data);
      if (result['success']) {
        fetchDosen();
        Get.back();
        Get.snackbar("Sukses", "Dosen berhasil diperbarui");
      } else {
        Get.snackbar("Gagal", result['message'] ?? "Terjadi kesalahan saat memperbarui data");
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
      if (await _service.deleteDosen(id)) { fetchDosen(); Get.snackbar("Sukses", "Dosen dihapus"); }
    } catch (e) { Get.snackbar("Error", e.toString()); } finally { isLoadingDosen(false); }
  }

  // --- PRODI CRUD ---
  void fetchProdi() async {
    try {
      isLoadingProdi(true);
      var data = await _service.getProdi();
      listProdi.assignAll(data);
    } catch (e) { print(e); } finally { isLoadingProdi(false); }
  }

  Future<void> addProdi(Map<String, dynamic> data) async {
    try {
      isLoadingProdi(true);
      if (await _service.storeProdi(data)) { fetchProdi(); Get.back(); Get.snackbar("Sukses", "Prodi ditambahkan"); }
    } catch (e) { Get.snackbar("Error", e.toString()); } finally { isLoadingProdi(false); }
  }

  Future<void> updateProdi(int id, Map<String, dynamic> data) async {
    try {
      isLoadingProdi(true);
      if (await _service.updateProdi(id, data)) { fetchProdi(); Get.back(); Get.snackbar("Sukses", "Prodi diperbarui"); }
    } catch (e) { Get.snackbar("Error", e.toString()); } finally { isLoadingProdi(false); }
  }

  Future<void> deleteProdi(int id) async {
    try {
      isLoadingProdi(true);
      if (await _service.deleteProdi(id)) { fetchProdi(); Get.snackbar("Sukses", "Prodi dihapus"); }
    } catch (e) { Get.snackbar("Error", e.toString()); } finally { isLoadingProdi(false); }
  }

  // --- RUANGAN CRUD ---
  void fetchRuangan() async {
    try {
      isLoadingRuangan(true);
      var data = await _service.getRuangan();
      listRuangan.assignAll(data);
    } catch (e) { print(e); } finally { isLoadingRuangan(false); }
  }

  Future<void> addRuangan(Map<String, dynamic> data) async {
    try {
      isLoadingRuangan(true);
      if (await _service.storeRuangan(data)) { fetchRuangan(); Get.back(); Get.snackbar("Sukses", "Ruangan ditambahkan"); }
    } catch (e) { Get.snackbar("Error", e.toString()); } finally { isLoadingRuangan(false); }
  }

  Future<void> updateRuangan(int id, Map<String, dynamic> data) async {
    try {
      isLoadingRuangan(true);
      if (await _service.updateRuangan(id, data)) { fetchRuangan(); Get.back(); Get.snackbar("Sukses", "Ruangan diperbarui"); }
    } catch (e) { Get.snackbar("Error", e.toString()); } finally { isLoadingRuangan(false); }
  }

  Future<void> deleteRuangan(int id) async {
    try {
      isLoadingRuangan(true);
      if (await _service.deleteRuangan(id)) { fetchRuangan(); Get.snackbar("Sukses", "Ruangan dihapus"); }
    } catch (e) { Get.snackbar("Error", e.toString()); } finally { isLoadingRuangan(false); }
  }

  // --- TAHUN AJAR CRUD ---
  void fetchTahunAjar() async {
    try {
      isLoadingTahunAjar(true);
      var data = await _service.getTahunAjar();
      listTahunAjar.assignAll(data);
    } catch (e) { print(e); } finally { isLoadingTahunAjar(false); }
  }

  Future<void> addTahunAjar(Map<String, dynamic> data) async {
    try {
      isLoadingTahunAjar(true);
      if (await _service.storeTahunAjar(data)) { fetchTahunAjar(); Get.back(); Get.snackbar("Sukses", "Tahun Ajar ditambahkan"); }
    } catch (e) { Get.snackbar("Error", e.toString()); } finally { isLoadingTahunAjar(false); }
  }

  Future<void> updateTahunAjar(int id, Map<String, dynamic> data) async {
    try {
      isLoadingTahunAjar(true);
      if (await _service.updateTahunAjar(id, data)) { fetchTahunAjar(); Get.back(); Get.snackbar("Sukses", "Tahun Ajar diperbarui"); }
    } catch (e) { Get.snackbar("Error", e.toString()); } finally { isLoadingTahunAjar(false); }
  }

  Future<void> deleteTahunAjar(int id) async {
    try {
      isLoadingTahunAjar(true);
      if (await _service.deleteTahunAjar(id)) { fetchTahunAjar(); Get.snackbar("Sukses", "Tahun Ajar dihapus"); }
    } catch (e) { Get.snackbar("Error", e.toString()); } finally { isLoadingTahunAjar(false); }
  }

  // --- MAHASISWA CRUD ---
  void fetchMahasiswa() async {
    try {
      isLoadingMahasiswa(true);
      var data = await _service.getMahasiswa();
      listMahasiswa.assignAll(data);
    } catch (e) { print(e); } finally { isLoadingMahasiswa(false); }
  }

  Future<void> addMahasiswa(Map<String, dynamic> data) async {
    try {
      isLoadingMahasiswa(true);
      final result = await _service.storeMahasiswa(data);
      if (result['success']) {
        fetchMahasiswa();
        Get.back();
        Get.snackbar("Sukses", "Mahasiswa berhasil ditambahkan");
      } else {
        Get.snackbar("Gagal", result['message'] ?? "Terjadi kesalahan saat menyimpan data",
          backgroundColor: Colors.orange.withOpacity(0.8), colorText: Colors.white);
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
      final result = await _service.updateMahasiswa(id, data);
      if (result['success']) {
        fetchMahasiswa();
        Get.back();
        Get.snackbar("Sukses", "Mahasiswa berhasil diperbarui");
      } else {
        Get.snackbar("Gagal", result['message'] ?? "Terjadi kesalahan saat memperbarui data");
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
      if (await _service.deleteMahasiswa(id)) { fetchMahasiswa(); Get.snackbar("Sukses", "Mahasiswa dihapus"); }
    } catch (e) { Get.snackbar("Error", e.toString()); } finally { isLoadingMahasiswa(false); }
  }

  void fetchUser() async {
    try {
      isLoadingUser(true);
      var data = await _service.getUsers();
      listUser.assignAll(data);
    } catch (e) { print(e); } finally { isLoadingUser(false); }
  }

  // --- DOSEN PRODI RELASI ---
  var isLoadingDosenProdi = false.obs;

  void fetchDosenProdi() async {
    try {
      isLoadingDosenProdi(true);
      var data = await _service.getDosenProdi();
      listDosen.assignAll(data);
    } catch (e) { print(e); } finally { isLoadingDosenProdi(false); }
  }

  Future<void> addDosenProdi(int dosenId, int prodiId) async {
    try {
      isLoadingDosenProdi(true);
      if (await _service.storeDosenProdi(dosenId, prodiId)) {
        fetchDosenProdi();
        Get.back();
        Get.snackbar("Sukses", "Relasi Dosen & Prodi berhasil ditambahkan");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingDosenProdi(false);
    }
  }

  Future<void> updateDosenProdi(int dosenId, List<int> prodiIds) async {
    try {
      isLoadingDosenProdi(true);
      if (await _service.updateDosenProdi(dosenId, prodiIds)) {
        fetchDosenProdi();
        Get.back();
        Get.snackbar("Sukses", "Relasi Dosen & Prodi berhasil diperbarui");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingDosenProdi(false);
    }
  }

  Future<void> deleteDosenProdi(int dosenId, int prodiId) async {
    try {
      isLoadingDosenProdi(true);
      if (await _service.deleteDosenProdi(dosenId, prodiId)) {
        fetchDosenProdi();
        Get.snackbar("Sukses", "Relasi Dosen & Prodi dihapus");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingDosenProdi(false);
    }
  }

  // --- REKAP ---
  Future<void> fetchRekap() async {
    try {
      isLoadingRekap(true);
      var data = await _service.getRekap();
      listRekap.assignAll(data);
    } catch (e) {
      print("Error fetchRekap: $e");
    } finally {
      isLoadingRekap(false);
    }
  }

  // --- RUBRIK NILAI ---
  void fetchRubrikNilai() async {
    try {
      isLoadingRubrikNilai(true);
      var data = await _service.getRubrikNilai();
      listRubrikNilai.assignAll(data);
    } catch (e) {
      print("Error fetchRubrikNilai: $e");
    } finally {
      isLoadingRubrikNilai(false);
    }
  }

  // --- PROPOSAL ---
  void fetchProposal() async {
    try {
      isLoadingProposal(true);
      var data = await _service.getProposals();
      listProposal.assignAll(data);
    } catch (e) {
      print("Error fetchProposal: $e");
    } finally {
      isLoadingProposal(false);
    }
  }
}
