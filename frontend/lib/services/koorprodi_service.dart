import 'dart:convert';
import 'package:frontend/models/prodi_model.dart';
import 'package:frontend/models/ruangan_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/constants.dart';
import '../models/pengajuan_pembimbing_model.dart';
import '../models/dosen_model.dart';
import '../models/mahasiswa_model.dart';
import '../models/tahun_ajar_model.dart';
import '../models/rubrik_nilai_model.dart';
import '../models/jadwal_model.dart';
import '../models/daftar_sidang_model.dart';

class KoorProdiService {
  final String baseUrl = AppConstants.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<DaftarSidangModel>> getDaftarSidang() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/koorprodi/daftar-sidang"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => DaftarSidangModel.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data pendaftar sidang");
  }

  Future<bool> deleteDaftarSidang(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/koorprodi/daftar-sidang/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  Future<List<JadwalModel>> getJadwal(String jenisSidang) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/koorprodi/jadwal?jenis_sidang=$jenisSidang"),
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

  Future<bool> storeJadwal(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/koorprodi/jadwal"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateJadwal(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/koorprodi/jadwal/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  // Existing methods ... (will be kept by replace)

  Future<List<Mahasiswa>> getMahasiswa() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/koorprodi/mahasiswa"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Mahasiswa.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data mahasiswa");
  }

  Future<bool> storeMahasiswa(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/koorprodi/mahasiswa"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateMahasiswa(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/koorprodi/mahasiswa/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteMahasiswa(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/koorprodi/mahasiswa/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  Future<List<TahunAjar>> getTahunAjar() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/koorprodi/tahun-ajar"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => TahunAjar.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data tahun ajar");
  }

  Future<List<Prodi>> getProdi() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/koorprodi/prodi"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Prodi.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data prodi");
  }

  Future<List<Dosen>> getDosenManajemen() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/koorprodi/dosen-manajemen"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Dosen.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data dosen");
  }

  Future<bool> storeDosen(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/koorprodi/dosen-manajemen"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateDosen(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/koorprodi/dosen-manajemen/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteDosen(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/koorprodi/dosen-manajemen/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  Future<List<Ruangan>> getRuangan() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/koorprodi/ruangan"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Ruangan.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data ruangan");
  }

  Future<bool> storeRuangan(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/koorprodi/ruangan"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateRuangan(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/koorprodi/ruangan/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteRuangan(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/koorprodi/ruangan/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  Future<List<RubrikNilai>> getRubrikNilai() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/koorprodi/rubrik-nilai"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => RubrikNilai.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data rubrik nilai");
  }

  Future<bool> storeRubrikNilai(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/koorprodi/rubrik-nilai"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateRubrikNilai(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/koorprodi/rubrik-nilai/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteRubrikNilai(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/koorprodi/rubrik-nilai/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> getPengajuanPembimbing({int page = 1, String? search, List<String>? status, List<String>? tahunAjar}) async {
    final token = await _getToken();
    
    Map<String, String> params = {
      'page': page.toString(),
      'per_page': '10',
    };
    
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (status != null && status.isNotEmpty) params['status'] = status.join(',');
    if (tahunAjar != null && tahunAjar.isNotEmpty) params['tahun_ajar'] = tahunAjar.join(',');

    final uri = Uri.parse("$baseUrl/koorprodi/pengajuan-pembimbing").replace(queryParameters: params);
    
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      List data = body['data'];
      return {
        'items': data.map((e) => PengajuanPembimbingModel.fromJson(e)).toList(),
        'last_page': body['last_page'],
        'current_page': body['current_page'],
      };
    }
    throw Exception("Gagal mengambil data pengajuan pembimbing");
  }

  Future<List<Dosen>> getDosen() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/koorprodi/dosen"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Dosen.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data dosen");
  }

  Future<bool> updateSupervisor(int id, int idUtama, int idPendamping) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/koorprodi/pengajuan-pembimbing/$id/update-supervisor"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_pembimbing_utama': idUtama,
        'id_pembimbing_pendamping': idPendamping,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> validasiPengajuan(int id, String status) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/koorprodi/pengajuan-pembimbing/$id/validasi"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );
    return response.statusCode == 200;
  }

  Future<List<dynamic>> getRekap() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/koorprodi/rekap"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    }
    throw Exception("Gagal mengambil data rekap");
  }
}
