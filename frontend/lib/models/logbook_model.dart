class LogbookBimbingan {
  final int? id;
  final int? idMahasiswa;
  final int? idDaftarBimbingan;
  final String? permasalahan;
  final String? fileBimbingan;
  final String? rekomPembimbingUtama;
  final String? rekomPembimbingPendamping;
  final String? createdAt;
  final String? updatedAt;
  final DaftarBimbingan? daftarBimbingan;

  LogbookBimbingan({
    this.id,
    this.idMahasiswa,
    this.idDaftarBimbingan,
    this.permasalahan,
    this.fileBimbingan,
    this.rekomPembimbingUtama,
    this.rekomPembimbingPendamping,
    this.createdAt,
    this.updatedAt,
    this.daftarBimbingan,
  });

  factory LogbookBimbingan.fromJson(Map<String, dynamic> json) {
    return LogbookBimbingan(
      id: json['id'],
      idMahasiswa: json['id_mahasiswa'],
      idDaftarBimbingan: json['id_daftar_bimbingan'],
      permasalahan: json['permasalahan'],
      fileBimbingan: json['file_bimbingan'],
      rekomPembimbingUtama: json['rekom_pembimbing_utama'],
      rekomPembimbingPendamping: json['rekom_pembimbing_pendamping'],
      createdAt: json['created_at'],
      updatedAt: json['update_at'],
      daftarBimbingan: json['daftar_bimbingan'] != null
          ? DaftarBimbingan.fromJson(json['daftar_bimbingan'])
          : null,
    );
  }
}

class DaftarBimbingan {
  final int? id;
  final String? status;
  final JadwalBimbinganDetail? jadwalBimbingan;

  DaftarBimbingan({this.id, this.status, this.jadwalBimbingan});

  factory DaftarBimbingan.fromJson(Map<String, dynamic> json) {
    return DaftarBimbingan(
      id: json['id'],
      status: json['status'],
      jadwalBimbingan: json['jadwal_bimbingan'] != null
          ? JadwalBimbinganDetail.fromJson(json['jadwal_bimbingan'])
          : null,
    );
  }
}

class JadwalBimbinganDetail {
  final int? id;
  final String? waktuTanggal;

  JadwalBimbinganDetail({this.id, this.waktuTanggal});

  factory JadwalBimbinganDetail.fromJson(Map<String, dynamic> json) {
    return JadwalBimbinganDetail(
      id: json['id'],
      waktuTanggal: json['waktu_tanggal'],
    );
  }
}
