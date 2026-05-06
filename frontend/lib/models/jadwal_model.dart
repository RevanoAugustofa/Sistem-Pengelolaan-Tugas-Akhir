import 'mahasiswa_model.dart';
import 'dosen_model.dart';
import 'ruangan_model.dart';

class JadwalModel {
  final int? id;
  final int? idMahasiswa;
  final String? jenisSidang;
  final int? idPengujiUtama;
  final int? idPengujiPendamping;
  final String? tanggal;
  final String? waktuMulai;
  final String? waktuSelesai;
  final int? idRuangSidang;
  final Mahasiswa? mahasiswa;
  final Dosen? pengujiUtama;
  final Dosen? pengujiPendamping;
  final Ruangan? ruangan;

  JadwalModel({
    this.id,
    this.idMahasiswa,
    this.jenisSidang,
    this.idPengujiUtama,
    this.idPengujiPendamping,
    this.tanggal,
    this.waktuMulai,
    this.waktuSelesai,
    this.idRuangSidang,
    this.mahasiswa,
    this.pengujiUtama,
    this.pengujiPendamping,
    this.ruangan,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      id: json['id'],
      idMahasiswa: json['id_mahasiswa'],
      jenisSidang: json['jenis_sidang'],
      idPengujiUtama: json['id_penguji_utama'],
      idPengujiPendamping: json['id_penguji_pendamping'],
      tanggal: json['tanggal'],
      waktuMulai: json['waktu_mulai'],
      waktuSelesai: json['waktu_selesai'],
      idRuangSidang: json['id_ruang_sidang'],
      mahasiswa: json['mahasiswa'] != null ? Mahasiswa.fromJson(json['mahasiswa']) : null,
      pengujiUtama: json['penguji_utama'] != null ? Dosen.fromJson(json['penguji_utama']) : null,
      pengujiPendamping: json['penguji_pendamping'] != null ? Dosen.fromJson(json['penguji_pendamping']) : null,
      ruangan: json['ruangan'] != null ? Ruangan.fromJson(json['ruangan']) : null,
    );
  }
}
