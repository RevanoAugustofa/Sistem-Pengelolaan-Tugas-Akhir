class TahunAjar {
  int? id;
  String? tahunAjar;
  DateTime? createdAt;
  DateTime? updatedAt;

  TahunAjar({
    this.id,
    this.tahunAjar,
    this.createdAt,
    this.updatedAt,
  });

  factory TahunAjar.fromJson(Map<String, dynamic> json) {
    return TahunAjar(
      id: json['id'],
      tahunAjar: json['tahun_ajar'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tahun_ajar': tahunAjar,
    };
  }
}
