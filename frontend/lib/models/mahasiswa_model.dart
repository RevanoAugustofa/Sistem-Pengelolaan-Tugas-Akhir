class Mahasiswa {
  final int? id;
  final int? idUser;
  final int? idProdi;
  final int? idTahunAjar;
  final String? npm;
  final String? namaMahasiswa;
  final String? email;
  final String? angkatan;
  final String? prodi;

  Mahasiswa({
    this.id, 
    this.idUser, 
    this.idProdi, 
    this.idTahunAjar, 
    this.npm, 
    this.namaMahasiswa, 
    this.email, 
    this.angkatan, 
    this.prodi
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id'],
      idUser: json['id_user'],
      idProdi: json['id_prodi'],
      idTahunAjar: json['id_tahun_ajar'],
      npm: json['nim'],
      namaMahasiswa: json['nama_mahasiswa'],
      email: json['user'] != null ? json['user']['email'] : null,
      angkatan: json['tahun_ajar'] != null ? json['tahun_ajar']['tahun_ajar'] : null,
      prodi: json['prodi'] != null ? json['prodi']['nama_prodi'] : null,
    );
  }
}
