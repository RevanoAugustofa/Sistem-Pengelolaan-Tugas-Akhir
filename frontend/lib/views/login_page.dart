import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Gunakan postFrameCallback agar BottomSheet muncul setelah UI render selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments['showRoles'] == true) {
        _showRoleSelectionSheet(List<String>.from(Get.arguments['roles']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/logo1.png',
                  height: 80,
                  semanticLabel: 'logo',
                ),
                const SizedBox(height: 16),
                const Text(
                  "Sistem Informasi\nPengelolaan Tugas Akhir",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 48),
                _buildLabel("Email / NIM"),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: emailController,
                  hint: "Email/NIM",
                  icon: Icons.mail_outline,
                ),
                const SizedBox(height: 24),
                _buildLabel("Password"),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: passwordController,
                  hint: "Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 40),
                _buildLoginButton(),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/img/pnc&jkb.png', height: 40),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jurusan Komputer dan Bisnis",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                          ),
                        ),
                        Text(
                          "Politeknik Negeri Cilacap",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  "Copyright © 2026 SIPTA JKB PNC.\nAll rights reserved.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Color(0xFF334155),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF94A3B8),
                  size: 20,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF94A3B8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () async {
          try {
            final result = await AuthService().login(
              emailController.text,
              passwordController.text,
            );
            String token = result['token'];
            var user = result['user'];
            List<String> availableRoles = List<String>.from(user['available_roles']);
            
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            await prefs.setString('user_data', jsonEncode(user));
            await prefs.setStringList('available_roles', availableRoles);
            
            if (availableRoles.length > 1) {
              _showRoleSelectionSheet(availableRoles);
            } else {
              String role = availableRoles[0];
              await prefs.setString('active_role', role);
              _navigateToDashboard(role);
            }
          } catch (e) {
            Get.snackbar(
              "Login Gagal",
              "Email atau password salah",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: const Text(
          "MASUK",
          style: TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  void _navigateToDashboard(String role) {
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
        Get.offAllNamed('/dashboardDsn');
    }
  }

  void _showRoleSelectionSheet(List<String> roles) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: const BoxDecoration(
          color: Color(0xFF2563EB),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Masuk Sebagai",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Silakan pilih jabatan untuk masuk",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 32),
            ...roles.map((role) => _buildRoleOption(role)).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54, // Ini yang membuat background menggelap sedikit (overlay)
    );
  }

  Widget _buildRoleOption(String role) {
    String title = "";
    IconData iconData = Icons.person;

    switch (role) {
      case 'mahasiswa':
        title = "Mahasiswa";
        iconData = Icons.school;
        break;
      case 'dosen':
        title = "Dosen";
        iconData = Icons.person;
        break;
      case 'admin':
        title = "Admin";
        iconData = Icons.admin_panel_settings;
        break;
      case 'koorprodi':
        title = "Koordinator Prodi";
        iconData = Icons.manage_accounts;
        break;
      default:
        title = role.capitalizeFirst ?? role;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('active_role', role);
          _navigateToDashboard(role);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(iconData, color: const Color(0xFF2563EB)),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}
