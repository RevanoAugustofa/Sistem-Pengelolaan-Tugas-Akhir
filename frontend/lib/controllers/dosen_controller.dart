import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/jadwal_model.dart';
import '../services/dosen_service.dart';
import '../models/mahasiswa_model.dart';
import '../models/logbook_model.dart';
import '../models/daftar_bimbingan_model.dart';

class DosenController extends GetxController {
  final DosenService _service = DosenService();

  var listJadwalProposal = <JadwalModel>[].obs;
  var listJadwalSidang = <JadwalModel>[].obs;
  var listJadwalBimbingan = <JadwalModel>[].obs;
  var listPendaftaranBimbingan = <DaftarBimbinganModel>[].obs;
  var listMahasiswa = <Mahasiswa>[].obs;
  var filteredMahasiswa = <Mahasiswa>[].obs;
  var listLogbook = <LogbookBimbingan>[].obs;
  var isLoadingJadwal = false.obs;
  var isLoadingMahasiswa = false.obs;
  var isLoadingLogbook = false.obs;
  var isLoadingPendaftaran = false.obs;

  // Sempro state
  var jadwalSempro = {}.obs;
  var hasilSempro = {}.obs;
  var catatanRevisi = {}.obs;
  var isPengujiSempro = false.obs;
  var isLoadingSempro = false.obs;
  
  // Sidang state
  var jadwalSidangTA = {}.obs;
  var hasilSidangTA = {}.obs;
  var isPengujiSidang = false.obs;
  var isPembimbingSidang = false.obs;
  var isLoadingSidang = false.obs;

  var idDosenLoggedIn = 0.obs;
  var currentGrade = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchJadwalProposal();
    fetchJadwalSidang();
    fetchJadwalBimbingan();
    fetchMahasiswa();
  }

  void fetchJadwalSempro(int idMahasiswa) async {
    try {
      isLoadingSempro(true);
      var data = await _service.getJadwalSempro(idMahasiswa);
      jadwalSempro.value = data['jadwal'] ?? {};
      hasilSempro.value = data['hasil'] ?? {};
      catatanRevisi.value = data['catatan'] ?? {};
      isPengujiSempro.value = data['is_penguji'] ?? false;
      idDosenLoggedIn.value = data['id_dosen_logged_in'] ?? 0;

      if (isPengujiSempro.value) {
        if (jadwalSempro['id_penguji_utama'] == idDosenLoggedIn.value) {
          currentGrade.value = hasilSempro['nilai_penguji_utama']?.toString() ?? "";
        } else {
          currentGrade.value = hasilSempro['nilai_penguji_pendamping']?.toString() ?? "";
        }
      } else {
        currentGrade.value = "";
      }
    } catch (e) {
      print("Error fetching sempro: $e");
    } finally {
      isLoadingSempro(false);
    }
  }

  Future<void> submitHasilSempro(Map<String, dynamic> data) async {
    try {
      isLoadingSempro(true);
      bool success = await _service.storeHasilSempro(data);
      if (success) {
        fetchJadwalSempro(data['id_mahasiswa_temp']); // Refresh
        Get.snackbar("Sukses", "Nilai proposal berhasil disimpan",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingSempro(false);
    }
  }

  Future<bool> submitCatatanRevisi(Map<String, dynamic> data) async {
    try {
      isLoadingSempro(true);
      bool success = await _service.storeCatatanRevisi(data);
      if (success) {
        fetchJadwalSempro(data['id_mahasiswa_temp']); // Refresh
        Get.snackbar("Sukses", "Catatan revisi berhasil disimpan",
            backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoadingSempro(false);
    }
  }

  void fetchJadwalSidangTA(int idMahasiswa) async {
    try {
      isLoadingSidang(true);
      var data = await _service.getJadwalSidang(idMahasiswa);
      jadwalSidangTA.value = data['jadwal'] ?? {};
      hasilSidangTA.value = data['hasil'] ?? {};
      isPengujiSidang.value = data['is_penguji'] ?? false;
      isPembimbingSidang.value = data['is_pembimbing'] ?? false;
      idDosenLoggedIn.value = data['id_dosen_logged_in'] ?? 0;

      if (isPengujiSidang.value || isPembimbingSidang.value) {
        if (jadwalSidangTA['id_penguji_utama'] == idDosenLoggedIn.value) {
          currentGrade.value = hasilSidangTA['nilai_penguji_utama']?.toString() ?? "";
        } else if (jadwalSidangTA['id_penguji_pendamping'] == idDosenLoggedIn.value) {
          currentGrade.value = hasilSidangTA['nilai_penguji_pendamping']?.toString() ?? "";
        } else if (jadwalSidangTA['id_pembimbing_utama'] == idDosenLoggedIn.value) {
          currentGrade.value = hasilSidangTA['nilai_pembimbing_utama']?.toString() ?? "";
        } else if (jadwalSidangTA['id_pembimbing_pendamping'] == idDosenLoggedIn.value) {
          currentGrade.value = hasilSidangTA['nilai_pembimbing_pendamping']?.toString() ?? "";
        }
      } else {
        currentGrade.value = "";
      }
    } catch (e) {
      print("Error fetching sidang TA: $e");
    } finally {
      isLoadingSidang(false);
    }
  }

  Future<void> submitHasilSidang(Map<String, dynamic> data) async {
    try {
      isLoadingSidang(true);
      bool success = await _service.storeHasilSidang(data);
      if (success) {
        fetchJadwalSidangTA(data['id_mahasiswa_temp']); // Refresh
        Get.snackbar("Sukses", "Nilai sidang berhasil disimpan",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingSidang(false);
    }
  }

  void fetchMahasiswa() async {
    try {
      isLoadingMahasiswa(true);
      var data = await _service.getMahasiswaBimbingan();
      listMahasiswa.assignAll(data);
      filteredMahasiswa.assignAll(data);
    } catch (e) {
      print("Error fetching mahasiswa: $e");
    } finally {
      isLoadingMahasiswa(false);
    }
  }

  void searchMahasiswa(String query) {
    if (query.isEmpty) {
      filteredMahasiswa.assignAll(listMahasiswa);
    } else {
      filteredMahasiswa.assignAll(listMahasiswa.where((m) =>
          m.namaMahasiswa!.toLowerCase().contains(query.toLowerCase()) ||
          m.npm!.toLowerCase().contains(query.toLowerCase())));
    }
  }

  void fetchJadwalProposal() async {
    try {
      isLoadingJadwal(true);
      var data = await _service.getJadwal('proposal');
      listJadwalProposal.assignAll(data);
    } catch (e) {
      print("Error fetching jadwal proposal: $e");
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
      print("Error fetching jadwal sidang: $e");
    } finally {
      isLoadingJadwal(false);
    }
  }

  void fetchJadwalBimbingan() async {
    try {
      isLoadingJadwal(true);
      var data = await _service.getJadwal('bimbingan');
      listJadwalBimbingan.assignAll(data);
    } catch (e) {
      print("Error fetching jadwal bimbingan: $e");
    } finally {
      isLoadingJadwal(false);
    }
  }

  Future<void> addJadwalBimbingan(Map<String, dynamic> data) async {
    try {
      isLoadingJadwal(true);
      bool success = await _service.storeJadwalBimbingan(data);
      if (success) {
        fetchJadwalBimbingan();
        Get.back();
        Get.snackbar("Sukses", "Jadwal bimbingan berhasil ditambahkan",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingJadwal(false);
    }
  }

  void fetchLogbook(int idMahasiswa) async {
    try {
      isLoadingLogbook(true);
      var data = await _service.getLogbookMahasiswa(idMahasiswa);
      listLogbook.assignAll(data);
    } catch (e) {
      print("Error fetching logbook: $e");
    } finally {
      isLoadingLogbook(false);
    }
  }

  Future<void> updateLogbook(int idLogbook, int idMahasiswa, Map<String, dynamic> data) async {
    try {
      isLoadingLogbook(true);
      bool success = await _service.updateLogbook(idLogbook, data);
      if (success) {
        fetchLogbook(idMahasiswa);
        Get.snackbar("Sukses", "Logbook berhasil diperbarui",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingLogbook(false);
    }
  }

  void fetchPendaftaranBimbingan(int idJadwal) async {
    try {
      isLoadingPendaftaran(true);
      var data = await _service.getPendaftaranBimbingan(idJadwal);
      listPendaftaranBimbingan.assignAll(data);
    } catch (e) {
      print("Error fetching pendaftaran bimbingan: $e");
    } finally {
      isLoadingPendaftaran(false);
    }
  }

  Future<void> updateStatusPendaftaran(int idPendaftaran, int idJadwal, String status) async {
    try {
      isLoadingPendaftaran(true);
      bool success = await _service.updateStatusPendaftaran(idPendaftaran, status);
      if (success) {
        fetchPendaftaranBimbingan(idJadwal);
        Get.snackbar("Sukses", "Status pendaftaran berhasil diperbarui",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingPendaftaran(false);
    }
  }
}
