class Prodi {
  final int? id;
  final String? namaProdi;
  final String? kodeProdi;

  Prodi({this.id, this.namaProdi, this.kodeProdi});

  factory Prodi.fromJson(Map<String, dynamic> json) {
    return Prodi(
      id: json['id'],
      namaProdi: json['nama_prodi'], // Sesuai database Laravel
      kodeProdi: json['kode_prodi'] ?? "-",
    );
  }
}
