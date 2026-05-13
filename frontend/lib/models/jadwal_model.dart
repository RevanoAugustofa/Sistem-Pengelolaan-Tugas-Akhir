import 'mahasiswa_model.dart';
import 'dosen_model.dart';
import 'ruangan_model.dart';

class JadwalModel {
  final int? id;
  final int? idMahasiswa;
  final String? jenisSidang;
  final int? idPengujiUtama;
  final int? idPengujiPendamping;
  final int? idPembimbingUtama;
  final int? idPembimbingPendamping;
  final String? tanggal;
  final String? waktuMulai;
  final String? waktuSelesai;
  final int? idRuangSidang;
  final Mahasiswa? mahasiswa;
  final Dosen? pengujiUtama;
  final Dosen? pengujiPendamping;
  final Dosen? pembimbingUtama;
  final Dosen? pembimbingPendamping;
  final Ruangan? ruangan;

  // Jadwal Bimbingan specific fields
  final int? idDosen;
  final Dosen? dosen;
  final String? waktuTanggal;
  final int? kuota;
  final String? metodeBimbingan;
  final String? tempatLink;

  JadwalModel({
    this.id,
    this.idMahasiswa,
    this.jenisSidang,
    this.idPengujiUtama,
    this.idPengujiPendamping,
    this.idPembimbingUtama,
    this.idPembimbingPendamping,
    this.tanggal,
    this.waktuMulai,
    this.waktuSelesai,
    this.idRuangSidang,
    this.mahasiswa,
    this.pengujiUtama,
    this.pengujiPendamping,
    this.pembimbingUtama,
    this.pembimbingPendamping,
    this.ruangan,
    this.idDosen,
    this.dosen,
    this.waktuTanggal,
    this.kuota,
    this.metodeBimbingan,
    this.tempatLink,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      id: json['id'],
      idMahasiswa: json['id_mahasiswa'],
      jenisSidang: json['jenis_sidang'],
      idPengujiUtama: json['id_penguji_utama'],
      idPengujiPendamping: json['id_penguji_pendamping'],
      idPembimbingUtama: json['id_pembimbing_utama'],
      idPembimbingPendamping: json['id_pembimbing_pendamping'],
      tanggal: json['tanggal'],
      waktuMulai: json['waktu_mulai'],
      waktuSelesai: json['waktu_selesai'],
      idRuangSidang: json['id_ruang_sidang'],
      mahasiswa: json['mahasiswa'] != null ? Mahasiswa.fromJson(json['mahasiswa']) : null,
      pengujiUtama: json['penguji_utama'] != null ? Dosen.fromJson(json['penguji_utama']) : null,
      pengujiPendamping: json['penguji_pendamping'] != null ? Dosen.fromJson(json['penguji_pendamping']) : null,
      pembimbingUtama: json['pembimbing_utama'] != null ? Dosen.fromJson(json['pembimbing_utama']) : null,
      pembimbingPendamping: json['pembimbing_pendamping'] != null ? Dosen.fromJson(json['pembimbing_pendamping']) : null,
      ruangan: json['ruangan'] != null ? Ruangan.fromJson(json['ruangan']) : null,
      idDosen: json['id_dosen'],
      dosen: json['dosen'] != null ? Dosen.fromJson(json['dosen']) : null,
      waktuTanggal: json['waktu_tanggal'],
      kuota: json['kuota'],
      metodeBimbingan: json['metode_bimbingan'],
      tempatLink: json['tempat_link'],
    );
  }
}
