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
      if (data.containsKey('permasalahan')) {
        request.fields['permasalahan'] = data['permasalahan'];
      }
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

  Future<Map<String, dynamic>> storeDaftarSidang(Map<String, Uint8List?> fileBytes, Map<String, String?> fileNames) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}/mahasiswa/daftar-sidang'),
    );

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // Add files
    if (fileBytes['tugas_akhir'] != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file_tugas_akhir',
        fileBytes['tugas_akhir']!,
        filename: fileNames['tugas_akhir'],
      ));
    }
    if (fileBytes['bebas_pinjaman'] != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file_bebas_pinjaman_administrasi',
        fileBytes['bebas_pinjaman']!,
        filename: fileNames['bebas_pinjaman'],
      ));
    }
    if (fileBytes['slip_pembayaran'] != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file_slip_pembayaran_semester_akhir',
        fileBytes['slip_pembayaran']!,
        filename: fileNames['slip_pembayaran'],
      ));
    }
    if (fileBytes['transkip'] != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file_transkip_sementara',
        fileBytes['transkip']!,
        filename: fileNames['transkip'],
      ));
    }
    if (fileBytes['pembayaran_sidang'] != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file_bukti_pembayaran_sidang_ta',
        fileBytes['pembayaran_sidang']!,
        filename: fileNames['pembayaran_sidang'],
      ));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    return jsonDecode(responseData);
  }
}
