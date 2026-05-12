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
  final String? tglLahir;
  final String? jenisKelamin;
  final String? alamat;
  final Proposal? proposal;

  Mahasiswa({
    this.id, 
    this.idUser, 
    this.idProdi, 
    this.idTahunAjar, 
    this.npm, 
    this.namaMahasiswa, 
    this.email, 
    this.angkatan, 
    this.prodi,
    this.tglLahir,
    this.jenisKelamin,
    this.alamat,
    this.proposal,
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
      tglLahir: json['tgl_lahir'],
      jenisKelamin: json['jenis_kelamin'],
      alamat: json['alamat'],
      proposal: json['proposal'] != null ? Proposal.fromJson(json['proposal']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': idUser,
      'id_prodi': idProdi,
      'id_tahun_ajar': idTahunAjar,
      'nim': npm,
      'nama_mahasiswa': namaMahasiswa,
      'tgl_lahir': tglLahir,
      'jenis_kelamin': jenisKelamin,
      'alamat': alamat,
      'proposal': proposal?.toJson(),
    };
  }
}

class Proposal {
  final int? id;
  final String? judulProposal;
  final String? fileProposal;
  final String? revisiJudulProposal;
  final String? revisiFileProposal;

  Proposal({
    this.id,
    this.judulProposal,
    this.fileProposal,
    this.revisiJudulProposal,
    this.revisiFileProposal,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json['id'],
      judulProposal: json['judul_proposal'],
      fileProposal: json['file_proposal'],
      revisiJudulProposal: json['revisi_judul_proposal'],
      revisiFileProposal: json['revisi_file_proposal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul_proposal': judulProposal,
      'file_proposal': fileProposal,
      'revisi_judul_proposal': revisiJudulProposal,
      'revisi_file_proposal': revisiFileProposal,
    };
  }
}
