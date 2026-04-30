class Ruangan {
  int? id;
  String? namaRuangan;
  String? gedung;
  DateTime? createdAt;
  DateTime? updatedAt;

  Ruangan({
    this.id,
    this.namaRuangan,
    this.gedung,
    this.createdAt,
    this.updatedAt,
  });

  factory Ruangan.fromJson(Map<String, dynamic> json) {
    return Ruangan(
      id: json['id'],
      namaRuangan: json['nama_ruangan'],
      gedung: json['gedung'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_ruangan': namaRuangan,
      'gedung': gedung,
    };
  }
}
