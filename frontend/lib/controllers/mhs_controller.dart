import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/dosen_model.dart';
import '../models/jadwal_model.dart';
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
  var pengajuanStatus = "".obs;
  var pembimbingUtama = "".obs;
  var nipUtama = "".obs;
  var pembimbingPendamping = "".obs;
  var nipPendamping = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchDosen();
    fetchDashboardData();
    fetchJadwalSempro();
    fetchJadwalSidang();
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
      if (data['pengajuan'] != null) {
        // Update data pendukung dulu
        if (data['pengajuan']['pembimbing_utama'] != null) {
          pembimbingUtama.value = data['pengajuan']['pembimbing_utama']['user']['name'] ?? "";
          nipUtama.value = data['pengajuan']['pembimbing_utama']['nip'] ?? "";
        }
        
        if (data['pengajuan']['pembimbing_pendamping'] != null) {
          pembimbingPendamping.value = data['pengajuan']['pembimbing_pendamping']['user']['name'] ?? "";
          nipPendamping.value = data['pengajuan']['pembimbing_pendamping']['nip'] ?? "";
        }

        // Baru update status di akhir untuk mentrigger UI
        pengajuanStatus.value = data['pengajuan']['status'] ?? "";
      } else {
        pengajuanStatus.value = "";
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
}
