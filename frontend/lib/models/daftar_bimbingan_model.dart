import 'mahasiswa_model.dart';

class DaftarBimbinganModel {
  final int? id;
  final int? idMahasiswa;
  final int? idJadwalBimbingan;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final Mahasiswa? mahasiswa;

  DaftarBimbinganModel({
    this.id,
    this.idMahasiswa,
    this.idJadwalBimbingan,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.mahasiswa,
  });

  factory DaftarBimbinganModel.fromJson(Map<String, dynamic> json) {
    return DaftarBimbinganModel(
      id: json['id'],
      idMahasiswa: json['id_mahasiswa'],
      idJadwalBimbingan: json['id_jadwal_bimbingan'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      mahasiswa: json['mahasiswa'] != null ? Mahasiswa.fromJson(json['mahasiswa']) : null,
    );
  }
}
