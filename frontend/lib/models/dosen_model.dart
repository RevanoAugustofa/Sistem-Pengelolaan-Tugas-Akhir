class Dosen {
  final int? id;
  final String? nip;
  final String? nidn;
  final String? namaDosen;
  final String? email;
  final String? jabatan;

  Dosen({this.id, this.nip, this.nidn, this.namaDosen, this.email, this.jabatan});

  factory Dosen.fromJson(Map<String, dynamic> json) {
    return Dosen(
      id: json['id'],
      nip: json['nip'],
      nidn: json['nidm'],
      namaDosen: json['nama_dosen'], // Sesuai database Laravel
      email: json['user'] != null ? json['user']['email'] : null,
      jabatan: json['jabatan'],
      // ttd: json['ttd'],
    );
  }
}
