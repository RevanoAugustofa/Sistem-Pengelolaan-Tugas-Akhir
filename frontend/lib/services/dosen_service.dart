import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/constants.dart';
import '../models/jadwal_model.dart';

class DosenService {
  final String baseUrl = AppConstants.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<JadwalModel>> getJadwal(String jenisSidang) async {
    final token = await _getToken();
    // Assuming we use the same endpoint but it will be filtered by the backend based on auth user
    // Or we might need a specific dosen endpoint later. 
    // For now, let's use a placeholder endpoint if it's not implemented yet, or reuse koorprodi if allowed.
    final response = await http.get(
      Uri.parse("$baseUrl/dosen/jadwal?jenis_sidang=$jenisSidang"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => JadwalModel.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data jadwal $jenisSidang");
  }
}
