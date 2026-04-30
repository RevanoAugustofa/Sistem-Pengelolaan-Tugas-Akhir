import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Delay 3 detik (dipercepat dari 5 detik agar tidak terlalu lama)
    await Future.delayed(const Duration(milliseconds: 3000));
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? availableRoles = prefs.getStringList('available_roles');

    if (availableRoles == null || availableRoles.isEmpty) {
      Get.offAllNamed('/login');
      return;
    }

    if (availableRoles.length > 1) {
      // Jika ada lebih dari satu jabatan, arahkan ke login dengan membawa info roles untuk memunculkan BottomSheet
      Get.offAllNamed('/login', arguments: {'showRoles': true, 'roles': availableRoles});
    } else {
      // Jika hanya satu jabatan, langsung masuk dashboard yang sesuai
      String role = availableRoles[0];
      await prefs.setString('active_role', role);
      
      switch (role) {
        case 'mahasiswa':
          Get.offAllNamed('/dashboardMhs');
          break;
        case 'dosen':
          Get.offAllNamed('/dashboardDsn');
          break;
        case 'admin':
          Get.offAllNamed('/dashboardAdm');
          break;
        case 'koorprodi':
          Get.offAllNamed('/dashboardKp');
          break;
        default:
          Get.offAllNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 30, 52, 117), 
                borderRadius: BorderRadius.circular(20), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  "assets/img/logo_putih.png",
                  width: 70, 
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}