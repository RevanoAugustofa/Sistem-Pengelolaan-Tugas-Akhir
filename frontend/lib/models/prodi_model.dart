class Prodi {
  final int? id;
  final String? namaProdi;
  final String? kodeProdi;
  final String? jabatan; // Tambahan field jabatan dari pivot table

  Prodi({this.id, this.namaProdi, this.kodeProdi, this.jabatan});

  factory Prodi.fromJson(Map<String, dynamic> json) {
    return Prodi(
      id: json['id'],
      namaProdi: json['nama_prodi'],
      kodeProdi: json['kode_prodi'] ?? "-",
      jabatan: json['pivot'] != null ? json['pivot']['jabatan'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_prodi': namaProdi,
      'kode_prodi': kodeProdi,
      'jabatan': jabatan,
    };
  }
}
