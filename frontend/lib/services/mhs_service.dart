import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/constants.dart';
import '../models/dosen_model.dart';
import '../models/jadwal_model.dart';

class MhsService {
  Future<Map<String, dynamic>> getDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/mahasiswa/dashboard'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat data dashboard');
    }
  }

  Future<List<Dosen>> getDosen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/mahasiswa/dosen'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      return data.map((item) => Dosen.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data dosen');
    }
  }

  Future<List<JadwalModel>> getJadwalSempro() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/mahasiswa/jadwal-sempro'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      return data.map((item) => JadwalModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data jadwal sempro');
    }
  }

  Future<List<JadwalModel>> getJadwalSidang() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/mahasiswa/jadwal-sidang'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      return data.map((item) => JadwalModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data jadwal sidang');
    }
  }

  Future<Map<String, dynamic>> daftarPembimbing(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Endpoint ini diasumsikan akan ada di backend
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/mahasiswa/daftar-pembimbing'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }
}
