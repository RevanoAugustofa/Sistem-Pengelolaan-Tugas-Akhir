import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/dosen_model.dart';
import '../services/mhs_service.dart';

class MhsController extends GetxController {
  final MhsService _service = MhsService();

  var isLoadingDosen = false.obs;
  var listDosen = <Dosen>[].obs;
  var isLoadingAction = false.obs;
  var isLoadingDashboard = false.obs;
  var pengajuanStatus = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchDosen();
    fetchDashboardData();
  }

  void fetchDashboardData() async {
    try {
      isLoadingDashboard(true);
      var data = await _service.getDashboardData();
      if (data['pengajuan'] != null) {
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
