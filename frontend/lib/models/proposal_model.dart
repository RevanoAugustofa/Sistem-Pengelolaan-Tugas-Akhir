import 'mahasiswa_model.dart';

class ProposalWithMahasiswa {
  final int? id;
  final int? idMahasiswa;
  final String? judulProposal;
  final String? fileProposal;
  final String? revisiJudulProposal;
  final String? revisiFileProposal;
  final Mahasiswa? mahasiswa;

  ProposalWithMahasiswa({
    this.id,
    this.idMahasiswa,
    this.judulProposal,
    this.fileProposal,
    this.revisiJudulProposal,
    this.revisiFileProposal,
    this.mahasiswa,
  });

  factory ProposalWithMahasiswa.fromJson(Map<String, dynamic> json) {
    return ProposalWithMahasiswa(
      id: json['id'],
      idMahasiswa: json['id_mahasiswa'],
      judulProposal: json['judul_proposal'],
      fileProposal: json['file_proposal'],
      revisiJudulProposal: json['revisi_judul_proposal'],
      revisiFileProposal: json['revisi_file_proposal'],
      mahasiswa: json['mahasiswa'] != null ? Mahasiswa.fromJson(json['mahasiswa']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_mahasiswa': idMahasiswa,
      'judul_proposal': judulProposal,
      'file_proposal': fileProposal,
      'revisi_judul_proposal': revisiJudulProposal,
      'revisi_file_proposal': revisiFileProposal,
      'mahasiswa': mahasiswa?.toJson(),
    };
  }
}
