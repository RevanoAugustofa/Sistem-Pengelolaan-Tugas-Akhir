import 'package:flutter/material.dart';
import 'package:frontend/views/Admin/DataDosen/index_dosen.dart';
import 'package:frontend/views/Admin/DataMahasiswa/index_mahasiswa.dart';
import 'package:frontend/views/Admin/DataProdi/index_prodi.dart';
import 'package:frontend/views/Admin/DataRuangan/index_ruangan.dart';
import 'package:frontend/views/Admin/DataTahunAjar/index_tahun_ajar.dart';
import 'package:frontend/views/KoorProdi/Jadwal/jadwal_koor.dart';
import 'package:frontend/views/KoorProdi/Proposal_Kp.dart';
import 'package:frontend/views/KoorProdi/Logbook_Kp.dart';
import 'package:frontend/views/KoorProdi/rekap_pembimbing_penguji.dart';
import 'package:frontend/views/KoorProdi/Jadwal/import_jadwal_proposal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/views/Admin/Data/DataUser_Admin.dart';
import 'package:frontend/views/Admin/Data/pendaftaranSidang_Admin.dart';
import 'package:frontend/views/Admin/Import/importdataDosen.dart';
import 'package:frontend/views/Admin/Import/importdataMahasiswa.dart';
import 'package:frontend/views/Admin/jadwal_Admin.dart';
import 'package:frontend/views/Admin/Logbook/logbook_Adm.dart';
import 'package:frontend/views/Admin/Penilaian/hasil_Adm.dart';
import 'package:frontend/views/Admin/Penilaian/rekap_Adm.dart';
import 'package:frontend/views/Admin/Penilaian/rubrik_Adm.dart';
import 'package:frontend/views/Admin/Proposal/proposal_Adm.dart';
import 'package:frontend/views/Admin/DosenProdi/index_dosen_prodi.dart';
import 'package:frontend/views/Admin/rekapPembimbingPenguji_Adm.dart';
import 'package:frontend/views/Admin/dashboard_Adm.dart';
import 'package:frontend/views/Dosen/dashboard_Dsn.dart';
import 'package:frontend/views/Dosen/detailProposal_Dsn.dart';
import 'package:frontend/views/Dosen/detailTA_Dsn.dart';
import 'package:frontend/views/Dosen/jadwal_Dsn.dart';
import 'package:frontend/views/Dosen/logbook_Dsn.dart';
import 'package:frontend/views/Dosen/tugasAkhir_Dsn.dart';
import 'package:frontend/views/KoorProdi/dashboard_KP.dart';
import 'package:frontend/views/KoorProdi/User_Kp.dart';
import 'package:frontend/views/KoorProdi/ValidasiPembimbing/pengajuanPembimbing.dart';
import 'package:frontend/views/KoorProdi/Mahasiswa/index_mahasiswa.dart' as kp_mhs;
import 'package:frontend/views/KoorProdi/Dosen/index_dosen.dart' as kp_dsn;
import 'package:frontend/views/KoorProdi/Ruangan/index_ruangan.dart' as kp_ruangan;
import 'package:frontend/views/KoorProdi/RubrikNilai/index_rubrik_nilai.dart' as kp_rubrik;
import 'package:frontend/views/Mahasiswa/Jadwal/jadwal_Sempro_Mhs.dart';
import 'package:frontend/views/Mahasiswa/daftar_dosenPembimbing_Mhs.dart';
import 'package:frontend/views/Mahasiswa/kuota_pembimbing.dart';
import 'package:frontend/views/Mahasiswa/pembimbing.dart';
import 'package:frontend/views/Mahasiswa/proposal_Mhs.dart';
import 'package:frontend/views/Mahasiswa/riwayat_bimbigan.dart';
import 'package:frontend/views/Notification/notifikasi.dart';
import 'package:frontend/views/Profile/dataDiri_page.dart';
import 'package:frontend/views/Profile/profile_page.dart';
import 'package:frontend/views/Profile/ubah_password.dart';
import 'package:frontend/views/Mahasiswa/TugasAkhir/TA_bimbingan_Mhs.dart';
import 'package:frontend/views/Mahasiswa/dashboard_Mhs.dart';
import 'package:frontend/views/Mahasiswa/TugasAkhir/TA_proposal_Mhs.dart';
import 'package:frontend/views/login_page.dart';
import 'package:frontend/views/splash_page.dart';
import 'package:get/get.dart';



void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      title: "sistem Informasi Pengelolaan Tugas Akhir",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: LoginPage(),
      // home: DashboardAdm(),
       getPages: [

        //admin
        GetPage(name: '/dashboardAdm', page: () => DashboardAdm() ),
        GetPage(name: '/dataUserAdm', page: () => DatauserAdminPage() ),
        GetPage(name: '/dataMahasiswaAdm', page: () => const IndexMahasiswaPage() ),
        GetPage(name: '/dataDosenAdm', page: () => const IndexDosenPage() ),
        GetPage(name: '/dataProdiAdm', page: () => const IndexProdiPage() ),
        GetPage(name: '/dataRuanganAdm', page: () => const IndexRuanganPage() ),
        GetPage(name: '/proposalAdm', page: () => ProposalAdminPage() ),
        GetPage(name: '/logbookAdm', page: () => LogbookAdminPage() ),
        GetPage(name: '/hasilAdm', page: () => HasilAdminPage() ),
        GetPage(name: '/rekapAdm', page: () => RekapAdminPage() ),
        GetPage(name: '/rubrikAdm', page: () => RubrikAdminPage() ),
        GetPage(name: '/pendaftaranSidangAdm', page: () => PendaftaranSidangAdminPage() ),
        GetPage(name: '/importDataMahasiswaAdm', page: () => ImportDataMahasiswaPage()),
        GetPage(name: '/importDataDosenAdm', page: () => ImportDataDosenPage()),
        GetPage(name: '/rekapPembimbingPengujiAdm', page: () => const RekapPembimbingPengujiAdminPage()),
        GetPage(name: '/jadwalAdm', page: () => JadwalAdminPage()),
        GetPage(name: '/tahunAjaranAdm', page: () => const IndexTahunAjarPage() ),
        GetPage(name: '/dosenProdiAdm', page: () => const IndexDosenProdiPage() ),

        //Dosen
        GetPage(name: '/dashboardDsn', page: () => DashboardDsn() ),
        GetPage(name: '/tugasAkhirDsn', page: () => TugasAkhirDosenPage() ),
        GetPage(name: '/jadwalDsn', page: () => JadwalDosenPage() ),
        GetPage(name: '/logbookDsn', page: () => LogbookDosenPage() ),
        GetPage(name: '/detailTugasAkhirDsn', page: () => DetailTugasAkhirDosenPage() ),
        GetPage(name: '/detailProposalDsn', page: () => DetailProposalDosenPage() ),



        //mahasiswa
        GetPage(name: '/login', page: () => LoginPage() ),
        GetPage(name: '/dashboardMhs', page: () => DashboardMhs() ),
        GetPage(name: '/proposalMhs', page: () => TaProposalMhs() ),
        GetPage(name: '/bimbinganMhs', page: () => TaBimbinganMhs() ),
        GetPage(name: '/jadwalSemproMhs', page: () => JadwalSemproMhs() ),
        GetPage(name: '/detail_proposal', page: () => ProposalMhs() ),
        GetPage(name: '/riwayat_bimbingan', page: () => RiwayatBimbingan() ),
        GetPage(name: '/kuota_pembimbing', page: () => KuotaPembimbing() ),
        GetPage(name: '/data_pembimbing', page: () => PembimbingPage() ),
        GetPage(name: '/pendaftaranDosen', page: () => const DaftarDosenPembimbingMhsPage() ),

        //koordinator prodi
        GetPage(name: '/dashboardKp', page: () => DashboardKp() ),
        GetPage(name: '/pengajuanpembimbing_KP', page: () => PengajuanPembimbing() ),
        GetPage(name: '/dataMahasiswaKp', page: () => const kp_mhs.IndexMahasiswaPage() ),
        GetPage(name: '/dataDosenKp', page: () => const kp_dsn.IndexDosenPage() ),
        GetPage(name: '/dataRuanganKp', page: () => const kp_ruangan.IndexRuanganPage() ),
        GetPage(name: '/dataRubrikNilaiKp', page: () => const kp_rubrik.IndexRubrikNilaiPage() ),
        GetPage(name: '/dataUserKp', page: () => const UserKpPage() ),
        GetPage(name: '/jadwalKp', page: () => const JadwalKoorPage() ),
        GetPage(name: '/proposalKp', page: () => const ProposalKoorPage() ),
        GetPage(name: '/logbookKp', page: () => const LogbookKoorPage() ),
        GetPage(name: '/rekapPembimbingPengujiKp', page: () => const RekapPembimbingPengujiPage() ),
        GetPage(name: '/importJadwalProposalKp', page: () => const ImportJadwalProposalPage() ),


        //umum
        GetPage(name: '/profil', page: () => ProfilPage() ),
        GetPage(name: '/datadiri', page: () => DataDiriPage() ),
        GetPage(name: '/ubah_password', page: () => UbahPasswordPage() ),
        GetPage(name: '/notifikasi', page: () => NotifikasiPage() ),
        GetPage(name: '/splash1', page: () => SplashPage() ),
        
      ]
    );
  }
} 
