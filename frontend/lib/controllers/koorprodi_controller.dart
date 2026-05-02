import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/pengajuan_pembimbing_model.dart';
import '../services/koorprodi_service.dart';

class KoorProdiController extends GetxController {
  final KoorProdiService _service = KoorProdiService();

  var isLoading = false.obs;
  var listPengajuan = <PengajuanPembimbingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPengajuan();
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
}
