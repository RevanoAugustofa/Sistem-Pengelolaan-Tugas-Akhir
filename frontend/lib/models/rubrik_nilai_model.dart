import 'prodi_model.dart';

class RubrikNilai {
  final int? id;
  final int? idProdi;
  final String? jenisDosen;
  final String? kelompok;
  final String? kategori;
  final int? presentse;
  final Prodi? prodi;

  RubrikNilai({
    this.id,
    this.idProdi,
    this.jenisDosen,
    this.kelompok,
    this.kategori,
    this.presentse,
    this.prodi,
  });

  factory RubrikNilai.fromJson(Map<String, dynamic> json) {
    return RubrikNilai(
      id: json['id'],
      idProdi: json['id_prodi'],
      jenisDosen: json['jenis_dosen'],
      kelompok: json['kelompok'],
      kategori: json['kategori'],
      presentse: json['presentse'],
      prodi: json['prodi'] != null ? Prodi.fromJson(json['prodi']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_prodi': idProdi,
      'jenis_dosen': jenisDosen,
      'kelompok': kelompok,
      'kategori': kategori,
      'presentse': presentse,
      'prodi': prodi?.toJson(),
    };
  }
}
