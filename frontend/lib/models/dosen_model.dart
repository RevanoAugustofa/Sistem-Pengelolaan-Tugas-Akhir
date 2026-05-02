import 'prodi_model.dart';

class Dosen {
  final int? id;
  final String? nip;
  final String? nidn;
  final String? namaDosen;
  final String? email;
  final String? jabatan;
  final List<Prodi>? prodi;

  Dosen({this.id, this.nip, this.nidn, this.namaDosen, this.email, this.jabatan, this.prodi});

  factory Dosen.fromJson(Map<String, dynamic> json) {
    return Dosen(
      id: json['id'],
      nip: json['nip'],
      nidn: json['nidm'],
      namaDosen: json['nama_dosen'], // Sesuai database Laravel
      email: json['user'] != null ? json['user']['email'] : null,
      jabatan: json['jabatan'],
      prodi: json['prodi'] != null 
        ? (json['prodi'] as List).map((i) => Prodi.fromJson(i)).toList() 
        : null,
      // ttd: json['ttd'],
    );
  }
}
