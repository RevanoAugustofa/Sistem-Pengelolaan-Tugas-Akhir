import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/constants.dart';
import '../models/dosen_model.dart';
import '../models/jadwal_model.dart';
import '../models/logbook_model.dart';

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

  Future<List<JadwalModel>> getJadwalBimbingan() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/mahasiswa/jadwal-bimbingan'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      return data.map((item) => JadwalModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data jadwal bimbingan');
    }
  }

  Future<List<LogbookBimbingan>> getLogbook() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/mahasiswa/logbook'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      return data.map((item) => LogbookBimbingan.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data logbook');
    }
  }

  Future<Map<String, dynamic>> storeLogbook(Map<String, dynamic> data, {Uint8List? fileBytes, String? fileName}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (fileBytes != null && fileName != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}/mahasiswa/logbook'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['id_daftar_bimbingan'] = data['id_daftar_bimbingan'].toString();
      request.fields['permasalahan'] = data['permasalahan'];
      request.files.add(http.MultipartFile.fromBytes(
        'file_bimbingan',
        fileBytes,
        filename: fileName,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } else {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/mahasiswa/logbook'),
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

  Future<Map<String, dynamic>> daftarBimbingan(int idJadwalBimbingan) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/mahasiswa/daftar-bimbingan'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id_jadwal_bimbingan': idJadwalBimbingan,
      }),
    );

    return jsonDecode(response.body);
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

  Future<Map<String, dynamic>> uploadProposal(String judul, Uint8List fileBytes, String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}/mahasiswa/upload-proposal'),
    );

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields['judul_proposal'] = judul;
    request.files.add(http.MultipartFile.fromBytes(
      'file_proposal',
      fileBytes,
      filename: fileName,
    ));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body);
  }
}
