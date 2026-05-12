import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dosen_model.dart';
import '../models/mahasiswa_model.dart';
import '../models/user_model.dart';
import '../models/prodi_model.dart';
import '../models/ruangan_model.dart';
import '../models/tahun_ajar_model.dart';
import '../models/rubrik_nilai_model.dart';
import '../models/proposal_model.dart';
import '../models/pengajuan_pembimbing_model.dart';
import '../models/jadwal_model.dart';
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

  // --- DOSEN PRODI RELASI ---
  Future<List<Dosen>> getDosenProdi() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/dosen-prodi"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => Dosen.fromJson(e)).toList();
    }
    print("Error fetching DosenProdi: ${response.statusCode} - ${response.body}");
    throw Exception("Gagal mengambil data relasi dosen prodi: ${response.statusCode}");
  }

  Future<bool> storeDosenProdi(int dosenId, int prodiId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/admin/dosen-prodi"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_dosen': dosenId,
        'id_prodi': prodiId,
      }),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateDosenProdi(int dosenId, List<int> prodiIds) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/admin/dosen-prodi/$dosenId"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode({
        'prodi_ids': prodiIds,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteDosenProdi(int dosenId, int prodiId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/admin/dosen-prodi/$dosenId/$prodiId"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200;
  }

  Future<List<dynamic>> getRekap() async {
    final token = await _getToken();
    // Assuming admin can also access this or we will add an admin-specific one
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

  // --- RUBRIK NILAI ---
  Future<List<RubrikNilai>> getRubrikNilai() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/rubrik-nilai"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => RubrikNilai.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data rubrik nilai");
  }

  // --- PROPOSAL ---
  Future<List<ProposalWithMahasiswa>> getProposals() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/proposal"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => ProposalWithMahasiswa.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data proposal");
  }

  // --- PENGAJUAN PEMBIMBING ---
  Future<List<PengajuanPembimbingModel>> getPengajuanPembimbing() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/pengajuan-pembimbing"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => PengajuanPembimbingModel.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data pengajuan pembimbing");
  }

  // --- JADWAL ---
  Future<List<JadwalModel>> getJadwalSempro() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/jadwal-sempro"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => JadwalModel.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data jadwal sempro");
  }

  Future<List<JadwalModel>> getJadwalSidangTA() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/jadwal-sidangta"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => JadwalModel.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data jadwal sidang ta");
  }

  Future<List<JadwalModel>> getJadwalBimbingan() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/jadwal-bimbingan"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      return data.map((e) => JadwalModel.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil data jadwal bimbingan");
  }

  // --- HASIL AKHIR ---
  Future<List<dynamic>> getHasilSempro() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/hasil-sempro"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    }
    throw Exception("Gagal mengambil data hasil sempro");
  }

  Future<List<dynamic>> getHasilSidang() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/hasil-sidang"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    }
    throw Exception("Gagal mengambil data hasil sidang");
  }

  // --- PENDAFTARAN SIDANG ---
  Future<List<dynamic>> getPendaftaranSidang() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse("$baseUrl/admin/pendaftaran-sidang"), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    }
    throw Exception("Gagal mengambil data pendaftaran sidang");
  }
}
