import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/constants.dart';
import '../models/jadwal_model.dart';
import '../models/mahasiswa_model.dart';
import '../models/logbook_model.dart';
import '../models/daftar_bimbingan_model.dart';

class DosenService {
  final String baseUrl = AppConstants.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Mahasiswa>> getMahasiswaBimbingan() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/dosen/mahasiswa"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Mahasiswa.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data mahasiswa bimbingan");
  }

  Future<Map<String, dynamic>> getJadwalSempro(int idMahasiswa) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/dosen/mahasiswa/$idMahasiswa/jadwal-sempro"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Gagal mengambil data jadwal sempro");
  }

  Future<bool> storeHasilSempro(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/dosen/hasil-sempro"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? "Gagal menyimpan nilai");
    }
  }

  Future<bool> storeCatatanRevisi(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/dosen/catatan-revisi-sempro"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? "Gagal menyimpan catatan revisi");
    }
  }

  Future<List<LogbookBimbingan>> getLogbookMahasiswa(int idMahasiswa) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/dosen/mahasiswa/$idMahasiswa/logbook"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => LogbookBimbingan.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data logbook");
  }

  Future<bool> updateLogbook(int idLogbook, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/dosen/logbook/$idLogbook"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? "Gagal memperbarui logbook");
    }
  }

  Future<Map<String, dynamic>> getJadwalSidang(int idMahasiswa) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/dosen/mahasiswa/$idMahasiswa/jadwal-sidang"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Gagal mengambil data jadwal sidang");
  }

  Future<bool> storeHasilSidang(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/dosen/hasil-sidang"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? "Gagal menyimpan nilai sidang");
    }
  }

  Future<List<JadwalModel>> getJadwal(String jenisSidang) async {
    final token = await _getToken();
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

  Future<bool> storeJadwalBimbingan(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/dosen/jadwal"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  Future<List<DaftarBimbinganModel>> getPendaftaranBimbingan(int idJadwal) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/dosen/jadwal-bimbingan/$idJadwal/pendaftaran"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => DaftarBimbinganModel.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data pendaftaran bimbingan");
  }

  Future<bool> updateStatusPendaftaran(int idPendaftaran, String status) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/dosen/pendaftaran-bimbingan/$idPendaftaran/status"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );

    return response.statusCode == 200;
  }
}
