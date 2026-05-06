import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  
  var userName = "Memuat...".obs;
  var userRole = "".obs;
  var userId = "".obs;
  var userEmail = "".obs;
  var idProdi = 0.obs;
  var prodiName = "".obs;
  var userAddress = "".obs;
  var userGender = "".obs;
  var userSignature = "".obs;
  var userNip = "".obs;
  var userNidn = "".obs;
  var selectedImagePath = "".obs;
  var isLoading = false.obs;
  var availableRoles = <String>[].obs;
  var availableContexts = <dynamic>[].obs;

  late TextEditingController emailController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    // Jika ada argument yang dikirim (misal dari dashboard), gunakan itu
    String? currentRole = Get.arguments?['activeRole'];
    loadUserData(activeRole: currentRole);
    fetchProfileFromApi();
  }

  void loadUserData({String? activeRole}) async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('user_name') ?? "User SIPTA";
    userRole.value = activeRole ?? (prefs.getString('active_role') ?? "");
    userId.value = prefs.getString('user_id') ?? "0000000000";
    userNip.value = prefs.getString('user_nip') ?? "";
    userNidn.value = prefs.getString('user_nidn') ?? "";
    userEmail.value = prefs.getString('user_email') ?? "user@sipta.com";
    emailController.text = userEmail.value;
    idProdi.value = prefs.getInt('id_prodi') ?? 0;
    prodiName.value = prefs.getString('prodi_name') ?? "";
    userAddress.value = prefs.getString('user_address') ?? "Alamat belum diatur";
    userGender.value = prefs.getString('user_gender') ?? "Laki-laki";
    userSignature.value = prefs.getString('user_signature') ?? "";
    
    String contextsJson = prefs.getString('available_contexts') ?? "[]";
    availableContexts.value = jsonDecode(contextsJson);
    availableRoles.value = availableContexts.map((e) => e['role'].toString()).toSet().toList();
  }

  Future<void> fetchProfileFromApi() async {
    try {
      isLoading(true);
      final data = await _authService.getProfile();
      print("Profile API Response: $data"); // Debug print
      final user = data['user'];
      
      userEmail.value = user['email'] ?? "";
      emailController.text = userEmail.value;
      
      // Karena role bisa berupa string atau object (enum)
      String role = "";
      if (user['role'] is Map) {
        role = user['role']['value'] ?? "";
      } else {
        role = user['role'].toString();
      }

      if (role == 'mahasiswa') {
        final mhs = user['mahasiswa'];
        if (mhs != null) {
          userName.value = mhs['nama_mahasiswa'] ?? "User SIPTA";
          userId.value = mhs['nim'] ?? "";
          userGender.value = mhs['jenis_kelamin'] ?? "Laki-laki";
          userAddress.value = mhs['alamat'] ?? "Belum diatur";
          userSignature.value = mhs['ttd_mahasiswa'] ?? "";
          prodiName.value = mhs['prodi']?['nama_prodi'] ?? "";
        }
      } else {
        final dsn = user['dosen'];
        if (dsn != null) {
          userName.value = dsn['nama_dosen'] ?? "Dosen SIPTA";
          userNip.value = dsn['nip'] ?? "";
          userNidn.value = dsn['nidn'] ?? "";
          userId.value = userNip.value.isNotEmpty ? userNip.value : userNidn.value;
          userGender.value = dsn['jenis_kelamin'] ?? "Laki-laki";
          userAddress.value = dsn['alamat'] ?? "Belum diatur";
          userSignature.value = dsn['ttd_dosen'] ?? "";
        }
      }

      // Update local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', userName.value);
      await prefs.setString('user_email', userEmail.value);
      await prefs.setString('user_address', userAddress.value);
      await prefs.setString('user_gender', userGender.value);
      await prefs.setString('user_signature', userSignature.value);
      await prefs.setString('user_id', userId.value);
      await prefs.setString('user_nip', userNip.value);
      await prefs.setString('user_nidn', userNidn.value);
      
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading(false);
    }
  }

  var isPickingImage = false.obs;

  Future<void> pickImage() async {
    if (isPickingImage.value) return;
    try {
      isPickingImage.value = true;
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar(
        "Error", 
        "Gagal mengambil gambar: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isPickingImage.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading(true);
      final response = await _authService.updateProfile(
        email: emailController.text,
        ttdPath: selectedImagePath.value,
      );
      
      Get.snackbar("Sukses", response['message'], backgroundColor: Colors.green, colorText: Colors.white);
      fetchProfileFromApi(); // Refresh data
      selectedImagePath.value = ""; // Clear selected image
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
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
