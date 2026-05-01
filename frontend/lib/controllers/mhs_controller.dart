import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/dosen_model.dart';
import '../services/mhs_service.dart';

class MhsController extends GetxController {
  final MhsService _service = MhsService();

  var isLoadingDosen = false.obs;
  var listDosen = <Dosen>[].obs;
  var isLoadingAction = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDosen();
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
