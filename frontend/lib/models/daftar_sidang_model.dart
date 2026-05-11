import 'mahasiswa_model.dart';

class DaftarSidangModel {
  int? id;
  int? idMahasiswa;
  String? tanggalPendaftaran;
  String? fileTugasAkhir;
  String? fileBebasPinjamanAdministrasi;
  String? fileSlipPembayaranSemesterAkhir;
  String? fileTranskipSementara;
  String? fileBuktiPembayaranSidangTa;
  String? createdAt;
  String? updateAt;
  Mahasiswa? mahasiswa;

  DaftarSidangModel({
    this.id,
    this.idMahasiswa,
    this.tanggalPendaftaran,
    this.fileTugasAkhir,
    this.fileBebasPinjamanAdministrasi,
    this.fileSlipPembayaranSemesterAkhir,
    this.fileTranskipSementara,
    this.fileBuktiPembayaranSidangTa,
    this.createdAt,
    this.updateAt,
    this.mahasiswa,
  });

  factory DaftarSidangModel.fromJson(Map<String, dynamic> json) {
    return DaftarSidangModel(
      id: json['id'],
      idMahasiswa: json['id_mahasiswa'],
      tanggalPendaftaran: json['tanggal_pendaftaran'],
      fileTugasAkhir: json['file_tugas_akhir'],
      fileBebasPinjamanAdministrasi: json['file_bebas_pinjaman_administrasi'],
      fileSlipPembayaranSemesterAkhir: json['file_slip_pembayaran_semester_akhir'],
      fileTranskipSementara: json['file_transkip_sementara'],
      fileBuktiPembayaranSidangTa: json['file_bukti_pembayaran_sidang_ta'],
      createdAt: json['created_at'],
      updateAt: json['update_at'],
      mahasiswa: json['mahasiswa'] != null ? Mahasiswa.fromJson(json['mahasiswa']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_mahasiswa': idMahasiswa,
      'tanggal_pendaftaran': tanggalPendaftaran,
      'file_tugas_akhir': fileTugasAkhir,
      'file_bebas_pinjaman_administrasi': fileBebasPinjamanAdministrasi,
      'file_slip_pembayaran_semester_akhir': fileSlipPembayaranSemesterAkhir,
      'file_transkip_sementara': fileTranskipSementara,
      'file_bukti_pembayaran_sidang_ta': fileBuktiPembayaranSidangTa,
      'created_at': createdAt,
      'update_at': updateAt,
    };
  }
}
