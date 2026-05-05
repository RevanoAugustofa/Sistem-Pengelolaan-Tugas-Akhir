import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  
  var userName = "Memuat...".obs;
  var userRole = "".obs;
  var userId = "".obs;
  var userEmail = "".obs;
  var idProdi = 0.obs;
  var prodiName = "".obs;
  var isLoading = false.obs;
  var availableRoles = <String>[].obs;
  var availableContexts = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Jika ada argument yang dikirim (misal dari dashboard), gunakan itu
    String? currentRole = Get.arguments?['activeRole'];
    loadUserData(activeRole: currentRole);
  }

  void loadUserData({String? activeRole}) async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('user_name') ?? "User SIPTA";
    
    // Gunakan activeRole jika dikirim, jika tidak ambil dari prefs 'active_role'
    userRole.value = activeRole ?? (prefs.getString('active_role') ?? "");
    
    userId.value = prefs.getString('user_id') ?? "0000000000";
    userEmail.value = prefs.getString('user_email') ?? "user@sipta.com";
    idProdi.value = prefs.getInt('id_prodi') ?? 0;
    prodiName.value = prefs.getString('prodi_name') ?? "";
    
    String contextsJson = prefs.getString('available_contexts') ?? "[]";
    availableContexts.value = jsonDecode(contextsJson);
    availableRoles.value = availableContexts.map((e) => e['role'].toString()).toSet().toList();
  }

  void switchRole(String newRole) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_role', newRole);
    userRole.value = newRole;

    // Navigasi ke dashboard yang sesuai
    if (newRole == 'admin') {
      Get.offAllNamed('/dashboardAdm');
    } else if (newRole == 'koorprodi') {
      Get.offAllNamed('/dashboardKp');
    } else if (newRole == 'dosen') {
      Get.offAllNamed('/dashboardDsn');
    } else if (newRole == 'mahasiswa') {
      Get.offAllNamed('/dashboardMhs');
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/login');
  }

  Future<void> updatePassword(String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Konfirmasi kata sandi tidak cocok',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (newPassword.length < 8) {
      Get.snackbar('Error', 'Kata sandi minimal 8 karakter',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response = await _authService.changePassword(newPassword, confirmPassword);
      Get.snackbar('Sukses', response['message'],
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.back(); // Kembali ke halaman profil
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
