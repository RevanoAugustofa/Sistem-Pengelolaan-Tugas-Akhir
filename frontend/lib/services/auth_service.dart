import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/constants.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      // SIMPAN TOKEN KE SHAREDPREFERENCES
      if (responseData['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);
        
        // Simpan data user lain jika diperlukan (optional)
        if (responseData['user'] != null) {
          String userRole = responseData['user']['role'] ?? '';
          
          // Jika user punya available_roles, kita simpan role pertama sebagai default jika perlu
          if (responseData['user']['available_roles'] != null) {
            List<String> roles = List<String>.from(responseData['user']['available_roles']);
            await prefs.setStringList('available_roles', roles);
            
            // PAKSA: Jika punya lebih dari 1 role, gunakan role pertama (Jabatan) sebagai default
            if (roles.length > 1) {
              userRole = roles.first;
            }
          }

          await prefs.setString('active_role', userRole);
          await prefs.setString('user_name', responseData['user']['name'] ?? '');
        }
      }
      
      return responseData;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to login');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('active_role');
    await prefs.remove('user_name');
  }

  Future<Map<String, dynamic>> changePassword(String newPassword, String confirmPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/update-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      }),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Gagal mengubah kata sandi');
    }
  }
}
