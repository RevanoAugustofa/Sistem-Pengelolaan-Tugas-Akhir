import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/constants.dart';

class NotificationService {
  Future<Map<String, dynamic>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/notifications'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Gagal mengambil data notifikasi');
    }
  }

  Future<Map<String, dynamic>> markAsRead(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('${AppConstants.baseUrl}/notifications/$id/read'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Gagal menandai notifikasi sudah dibaca');
    }
  }

  Future<Map<String, dynamic>> markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('${AppConstants.baseUrl}/notifications/read-all'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Gagal menandai semua notifikasi sudah dibaca');
    }
  }

  Future<Map<String, dynamic>> deleteNotification(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('${AppConstants.baseUrl}/notifications/$id'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Gagal menghapus notifikasi');
    }
  }
}
