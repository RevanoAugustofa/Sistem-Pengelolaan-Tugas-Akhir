class NotificationModel {
  final int id;
  final int idUser;
  final String? namaNotif;
  final String? isiNotif;
  final bool isRead;
  final DateTime? tglNotif;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    required this.id,
    required this.idUser,
    this.namaNotif,
    this.isiNotif,
    this.isRead = false,
    this.tglNotif,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      idUser: json['id_user'],
      namaNotif: json['nama_notif'],
      isiNotif: json['isi_notif'],
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      tglNotif: json['tgl_notif'] != null ? DateTime.parse(json['tgl_notif']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': idUser,
      'nama_notif': namaNotif,
      'isi_notif': isiNotif,
      'is_read': isRead,
      'tgl_notif': tglNotif?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
