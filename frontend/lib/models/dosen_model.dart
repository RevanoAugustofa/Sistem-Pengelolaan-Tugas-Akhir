import 'prodi_model.dart';
import 'user_model.dart';

class Dosen {
  final int? id;
  final String? nip;
  final String? nidn;
  final String? namaDosen;
  final String? email;
  final String? jenisKelamin;
  final String? alamat;
  final String? jabatan;
  final List<Prodi>? prodi;
  final User? user;

  Dosen({
    this.id,
    this.nip,
    this.nidn,
    this.namaDosen,
    this.email,
    this.jenisKelamin,
    this.alamat,
    this.jabatan,
    this.prodi,
    this.user,
  });

  factory Dosen.fromJson(Map<String, dynamic> json) {
    return Dosen(
      id: json['id'],
      nip: json['nip'],
      nidn: json['nidn'],
      namaDosen: json['nama_dosen'], // Sesuai database Laravel
      email: json['user'] != null ? json['user']['email'] : null,
      jenisKelamin: json['jenis_kelamin'],
      alamat: json['alamat'],
      jabatan: json['jabatan'],
      prodi: json['prodi'] != null
          ? (json['prodi'] as List).map((i) => Prodi.fromJson(i)).toList()
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
