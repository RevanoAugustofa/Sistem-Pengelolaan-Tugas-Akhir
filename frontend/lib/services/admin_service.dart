import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dosen_model.dart';
import '../models/mahasiswa_model.dart';
import '../models/user_model.dart';
import '../models/prodi_model.dart';
import '../models/ruangan_model.dart';
import '../models/tahun_ajar_model.dart';
import '../helpers/constants.dart';

class AdminService {
  final String baseUrl = AppConstants.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // --- DOSEN CRUD ---
  Future<List<Dosen>> getDosen() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/dosen"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Dosen.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data dosen");
  }

  Future<Map<String, dynamic>> storeDosen(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/admin/dosen"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      return {'success': true, 'data': responseData};
    } else {
      return {'success': false, 'message': responseData['message'] ?? "Gagal menyimpan data"};
    }
  }

  Future<Map<String, dynamic>> updateDosen(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/admin/dosen/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return {'success': true, 'data': responseData};
    } else {
      return {'success': false, 'message': responseData['message'] ?? "Gagal memperbarui data"};
    }
  }

  Future<bool> deleteDosen(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/admin/dosen/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200;
  }

  // --- PRODI CRUD ---
  Future<List<Prodi>> getProdi() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/prodi"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Prodi.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data prodi");
  }

  Future<bool> storeProdi(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/admin/prodi"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateProdi(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/admin/prodi/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteProdi(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/admin/prodi/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200;
  }

  // --- RUANGAN CRUD ---
  Future<List<Ruangan>> getRuangan() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/ruangan"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Ruangan.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data ruangan");
  }

  Future<bool> storeRuangan(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/admin/ruangan"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateRuangan(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/admin/ruangan/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteRuangan(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/admin/ruangan/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200;
  }

  // --- TAHUN AJAR CRUD ---
  Future<List<TahunAjar>> getTahunAjar() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/tahun-ajar"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => TahunAjar.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data tahun ajar");
  }

  Future<bool> storeTahunAjar(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/admin/tahun-ajar"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateTahunAjar(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/admin/tahun-ajar/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteTahunAjar(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/admin/tahun-ajar/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200;
  }

  // --- MAHASISWA CRUD ---
  Future<List<Mahasiswa>> getMahasiswa() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/mahasiswa"), headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Mahasiswa.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data mahasiswa");
  }

  Future<Map<String, dynamic>> storeMahasiswa(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/admin/mahasiswa"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      return {'success': true, 'data': responseData};
    } else {
      return {'success': false, 'message': responseData['message'] ?? "Gagal menyimpan data"};
    }
  }

  Future<Map<String, dynamic>> updateMahasiswa(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/admin/mahasiswa/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return {'success': true, 'data': responseData};
    } else {
      return {'success': false, 'message': responseData['message'] ?? "Gagal memperbarui data"};
    }
  }

  Future<bool> deleteMahasiswa(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/admin/mahasiswa/$id"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200;
  }

  Future<List<User>> getUsers() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/users"), headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => User.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data user");
  }
}
