import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/constants.dart';
import '../models/pengajuan_pembimbing_model.dart';
import '../models/dosen_model.dart';

class KoorProdiService {
  final String baseUrl = AppConstants.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
}
