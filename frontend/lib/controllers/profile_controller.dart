import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var userName = "Memuat...".obs;
  var userRole = "Admin".obs;
  var userId = "-".obs; // Ini bisa diisi NIP/NIDN jika ada

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('user_name') ?? "Admin SIPTA";
    userRole.value = prefs.getString('user_role') ?? "Admin";
    // Untuk ID/NIP, jika belum disimpan saat login, kita bisa buat default atau ambil dari data lain
    userId.value = "ID: ${prefs.getString('user_id') ?? '883928383'}";
  }
}
