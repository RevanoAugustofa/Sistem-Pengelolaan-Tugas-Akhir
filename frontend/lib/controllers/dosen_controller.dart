import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/jadwal_model.dart';
import '../services/dosen_service.dart';

class DosenController extends GetxController {
  final DosenService _service = DosenService();

  var listJadwalProposal = <JadwalModel>[].obs;
  var listJadwalSidang = <JadwalModel>[].obs;
  var listJadwalBimbingan = <JadwalModel>[].obs;
  var isLoadingJadwal = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJadwalProposal();
    fetchJadwalSidang();
    fetchJadwalBimbingan();
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
}
