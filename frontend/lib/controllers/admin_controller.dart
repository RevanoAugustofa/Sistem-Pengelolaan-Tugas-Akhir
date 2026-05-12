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
  var listJadwalProposal = <dynamic>[].obs;
  var listJadwalBimbingan = <dynamic>[].obs;
  var listJadwalSidang = <dynamic>[].obs;

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

  void fetchJadwal() {
    // Sementara dummy data karena service belum ada
    listJadwalProposal.assignAll([
      {'mahasiswa': {'nama': 'Mahasiswa 1', 'npm': '123'}, 'ruangan': 'Lab Komputer', 'tanggal': '2026-05-15', 'waktu': '08:00 - 10:00', 'penguji1': 'Dosen A', 'penguji2': 'Dosen B'},
      {'mahasiswa': {'nama': 'Mahasiswa 2', 'npm': '124'}, 'ruangan': 'Ruang 101', 'tanggal': '2026-05-16', 'waktu': '10:00 - 12:00', 'penguji1': 'Dosen C', 'penguji2': 'Dosen D'},
    ]);

    listJadwalBimbingan.assignAll([
      {'metode': 'Online', 'tempat': 'Zoom Meeting', 'kuota': 5, 'waktu': '2026-05-12 09:00', 'status': 'tersedia'},
      {'metode': 'Offline', 'tempat': 'Ruang Dosen', 'kuota': 3, 'waktu': '2026-05-13 14:00', 'status': 'tersedia'},
    ]);

    listJadwalSidang.assignAll([
      {'mahasiswa': {'nama': 'Mahasiswa 3', 'npm': '125'}, 'jenis': 'Sidang Akhir', 'ruangan': 'Aula', 'tanggal': '2026-05-20', 'waktu': '13:00 - 15:00'},
    ]);
  }

  void fetchHasilAkhir() {
    // Sementara dummy data
    listHasilSempro.assignAll([
      {'mahasiswa': {'nama': 'Arya Dirham', 'npm': '203992'}, 'prodi': 'TI', 'nilai_akhir': 85.5, 'status': 'Lulus'},
      {'mahasiswa': {'nama': 'Reva Dina', 'npm': '203922'}, 'prodi': 'TI', 'nilai_akhir': 78.0, 'status': 'Lulus'},
    ]);

    listHasilSidang.assignAll([
      {'mahasiswa': {'nama': 'Aulia Fitri', 'npm': '205392'}, 'prodi': 'TI', 'nilai_akhir': 88.0, 'status': 'Lulus'},
      {'mahasiswa': {'nama': 'Budi Santoso', 'npm': '203332'}, 'prodi': 'TI', 'nilai_akhir': 65.0, 'status': 'Tidak Lulus'},
    ]);
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
