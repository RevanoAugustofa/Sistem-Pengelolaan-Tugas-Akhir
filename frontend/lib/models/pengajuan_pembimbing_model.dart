import 'mahasiswa_model.dart';
import 'dosen_model.dart';

class PengajuanPembimbingModel {
  final int? id;
  final int? idMahasiswa;
  final int? idPembimbingUtama;
  final int? idPembimbingPendamping;
  final String? status;
  final Mahasiswa? mahasiswa;
  final Dosen? pembimbingUtama;
  final Dosen? pembimbingPendamping;
  final DateTime? createdAt;

   PengajuanPembimbingModel({
    this.id,
    this.idMahasiswa,
    this.idPembimbingUtama,
    this.idPembimbingPendamping,
    this.status,
    this.mahasiswa,
    this.pembimbingUtama,
    this.pembimbingPendamping,
    this.createdAt,
  });

  factory PengajuanPembimbingModel.fromJson(Map<String, dynamic> json) {
    return PengajuanPembimbingModel(
      id: json['id'],
      idMahasiswa: json['id_mahasiswa'],
      idPembimbingUtama: json['id_pembimbing_utama'],
      idPembimbingPendamping: json['id_pembimbing_pendamping'],
      status: json['status'],
      mahasiswa: json['mahasiswa'] != null ? Mahasiswa.fromJson(json['mahasiswa']) : null,
      pembimbingUtama: json['pembimbing_utama'] != null ? Dosen.fromJson(json['pembimbing_utama']) : null,
      pembimbingPendamping: json['pembimbing_pendamping'] != null ? Dosen.fromJson(json['pembimbing_pendamping']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  get proposal => null;

  get judulTa => null;
}
