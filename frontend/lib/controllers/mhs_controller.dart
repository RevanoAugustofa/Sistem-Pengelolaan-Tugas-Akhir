import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/dosen_model.dart';
import '../models/jadwal_model.dart';
import '../models/logbook_model.dart';
import '../services/mhs_service.dart';

class MhsController extends GetxController {
  final MhsService _service = MhsService();

  var isLoadingDosen = false.obs;
  var listDosen = <Dosen>[].obs;
  var isLoadingAction = false.obs;
  var isLoadingDashboard = false.obs;
  var isLoadingJadwalSempro = false.obs;
  var listJadwalSempro = <JadwalModel>[].obs;
  var isLoadingJadwalSidang = false.obs;
  var listJadwalSidang = <JadwalModel>[].obs;
  var isLoadingJadwalBimbingan = false.obs;
  var listJadwalBimbingan = <JadwalModel>[].obs;
  var listLogbook = <LogbookBimbingan>[].obs;
  var isLoadingLogbook = false.obs;
  var pengajuanStatus = "".obs;
  var pembimbingUtama = "".obs;
  var nipUtama = "".obs;
  var pembimbingPendamping = "".obs;
  var nipPendamping = "".obs;
  var proposalTitle = "".obs;
  var proposalFile = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchDosen();
    fetchDashboardData();
    fetchJadwalSempro();
    fetchJadwalSidang();
    fetchJadwalBimbingan();
    fetchLogbook();
  }

  void fetchLogbook() async {
    try {
      isLoadingLogbook(true);
      var data = await _service.getLogbook();
      listLogbook.assignAll(data);
    } catch (e) {
      print(e);
    } finally {
      isLoadingLogbook(false);
    }
  }

  Future<void> submitLogbook(Map<String, dynamic> data, {Uint8List? fileBytes, String? fileName}) async {
    try {
      isLoadingAction(true);
      final result = await _service.storeLogbook(data, fileBytes: fileBytes, fileName: fileName);
      if (result['success'] == true) {
        fetchLogbook();
        Get.back();
        Get.snackbar("Sukses", result['message'] ?? "Logbook berhasil ditambahkan");
      } else {
        Get.snackbar("Gagal", result['message'] ?? "Gagal menambahkan logbook",
            backgroundColor: Colors.orange.withOpacity(0.8), colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: ${e.toString()}");
    } finally {
      isLoadingAction(false);
    }
  }

  void fetchJadwalBimbingan() async {
    try {
      isLoadingJadwalBimbingan(true);
      var data = await _service.getJadwalBimbingan();
      listJadwalBimbingan.assignAll(data);
    } catch (e) {
      print(e);
    } finally {
      isLoadingJadwalBimbingan(false);
    }
  }

  void fetchJadwalSempro() async {
    try {
      isLoadingJadwalSempro(true);
      var data = await _service.getJadwalSempro();
      listJadwalSempro.assignAll(data);
    } catch (e) {
      print(e);
    } finally {
      isLoadingJadwalSempro(false);
    }
  }

  void fetchJadwalSidang() async {
    try {
      isLoadingJadwalSidang(true);
      var data = await _service.getJadwalSidang();
      listJadwalSidang.assignAll(data);
    } catch (e) {
      print(e);
    } finally {
      isLoadingJadwalSidang(false);
    }
  }

  void fetchDashboardData() async {
    try {
      isLoadingDashboard(true);
      var data = await _service.getDashboardData();
      
      // Update Pengajuan Data
      if (data['pengajuan'] != null) {
        if (data['pengajuan']['pembimbing_utama'] != null) {
          pembimbingUtama.value = data['pengajuan']['pembimbing_utama']['user']['name'] ?? "";
          nipUtama.value = data['pengajuan']['pembimbing_utama']['nip'] ?? "";
        }
        
        if (data['pengajuan']['pembimbing_pendamping'] != null) {
          pembimbingPendamping.value = data['pengajuan']['pembimbing_pendamping']['user']['name'] ?? "";
          nipPendamping.value = data['pengajuan']['pembimbing_pendamping']['nip'] ?? "";
        }

        pengajuanStatus.value = data['pengajuan']['status'] ?? "";
      } else {
        pengajuanStatus.value = "";
      }

      // Update Proposal Data
      if (data['proposal'] != null) {
        proposalTitle.value = data['proposal']['judul_proposal'] ?? "";
        proposalFile.value = data['proposal']['file_proposal'] ?? "";
      } else {
        proposalTitle.value = "";
        proposalFile.value = "";
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingDashboard(false);
    }
  }

  void fetchDosen() async {
    try {
      isLoadingDosen(true);
      var data = await _service.getDosen();
      listDosen.assignAll(data);
    } catch (e) {
      print(e);
    } finally {
      isLoadingDosen(false);
    }
  }

  Future<void> submitPendaftaran(Map<String, dynamic> data) async {
    try {
      isLoadingAction(true);
      final result = await _service.daftarPembimbing(data);
      if (result['success'] == true) {
        fetchDashboardData(); // Refresh status after submission
        Get.back();
        Get.snackbar("Sukses", result['message'] ?? "Pendaftaran berhasil");
      } else {
        Get.snackbar("Gagal", result['message'] ?? "Gagal melakukan pendaftaran",
            backgroundColor: Colors.orange.withOpacity(0.8), colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: ${e.toString()}");
    } finally {
      isLoadingAction(false);
    }
  }

  Future<void> daftarBimbingan(int idJadwal) async {
    try {
      isLoadingAction(true);
      final result = await _service.daftarBimbingan(idJadwal);
      if (result['success'] == true) {
        fetchJadwalBimbingan();
        Get.snackbar("Sukses", result['message'] ?? "Berhasil mendaftar bimbingan");
      } else {
        Get.snackbar("Gagal", result['message'] ?? "Gagal mendaftar bimbingan",
            backgroundColor: Colors.orange.withOpacity(0.8), colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: ${e.toString()}");
    } finally {
      isLoadingAction(false);
    }
  }

  Future<void> uploadProposal(String judul, Uint8List fileBytes, String fileName) async {
    try {
      isLoadingAction(true);
      final result = await _service.uploadProposal(judul, fileBytes, fileName);
      if (result['success'] == true) {
        fetchDashboardData();
        Get.back();
        Get.snackbar("Sukses", result['message'] ?? "Proposal berhasil diunggah");
      } else {
        Get.snackbar("Gagal", result['message'] ?? "Gagal mengunggah proposal",
            backgroundColor: Colors.orange.withOpacity(0.8), colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: ${e.toString()}");
    } finally {
      isLoadingAction(false);
    }
  }
}
