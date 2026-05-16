import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:frontend/views/Admin/DataDosen/index_dosen.dart';
import 'package:frontend/views/Admin/DataMahasiswa/index_mahasiswa.dart';
import 'package:frontend/views/Admin/DataProdi/index_prodi.dart';
import 'package:frontend/views/Admin/DataRuangan/index_ruangan.dart';
import 'package:frontend/views/Admin/DataTahunAjar/index_tahun_ajar.dart';
import 'package:frontend/views/KoorProdi/Jadwal/import_jadwal_sidang.dart';
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
import 'package:frontend/views/Admin/Jadwal/jadwal_Admin.dart';
import 'package:frontend/views/Admin/list_logbook_Adm.dart';
import 'package:frontend/views/Admin/HasilAkhir/hasilAkhir_Adm.dart';
import 'package:frontend/views/Admin/pengajuan_pembimbing_Adm.dart';
import 'package:frontend/views/Admin/Penilaian/rekap_Adm.dart';
import 'package:frontend/views/Admin/Penilaian/rubrik_Adm.dart';
import 'package:frontend/views/Admin/proposal_Adm.dart';
import 'package:frontend/views/Admin/DosenProdi/index_dosen_prodi.dart';
import 'package:frontend/views/Admin/rekapPembimbingPenguji_Adm.dart';
import 'package:frontend/views/Admin/dashboard_Adm.dart';
import 'package:frontend/views/Dosen/dashboard_Dsn.dart';
import 'package:frontend/views/Dosen/detailProposal_Dsn.dart';
import 'package:frontend/views/Dosen/detailTA_Dsn.dart';
import 'package:frontend/views/Dosen/Jadwal/create_jadwal_bimbingan.dart';
import 'package:frontend/views/Dosen/Jadwal/jadwal_Dsn.dart';
import 'package:frontend/views/Dosen/Jadwal/detail_pendaftaran_bimbingan.dart';
import 'package:frontend/views/Dosen/TugasAkhir/tugasAkhir_Dsn.dart';
import 'package:frontend/views/Dosen/TugasAkhir/list_mahasiswa.dart';
import 'package:frontend/views/KoorProdi/HasilAkhir/hasilAkhir_KP.dart';
import 'package:frontend/views/KoorProdi/rekap_nilai_KP.dart';
import 'package:frontend/views/KoorProdi/dashboard_KP.dart';
import 'package:frontend/views/KoorProdi/User_Kp.dart';
import 'package:frontend/views/KoorProdi/ValidasiPembimbing/pengajuanPembimbing.dart';
import 'package:frontend/views/KoorProdi/Mahasiswa/index_mahasiswa.dart' as kp_mhs;
import 'package:frontend/views/KoorProdi/Mahasiswa/import_mahasiswa.dart' as kp_import_mhs;
import 'package:frontend/views/KoorProdi/Dosen/index_dosen.dart' as kp_dsn;
import 'package:frontend/views/KoorProdi/Ruangan/index_ruangan.dart' as kp_ruangan;
import 'package:frontend/views/KoorProdi/RubrikNilai/index_rubrik_nilai.dart' as kp_rubrik;
import 'package:frontend/views/Mahasiswa/Jadwal/jadwal_mhs.dart';
import 'package:frontend/views/Mahasiswa/daftar_dosenPembimbing_Mhs.dart';
import 'package:frontend/views/Mahasiswa/kuota_pembimbing.dart';
import 'package:frontend/views/Mahasiswa/pembimbing.dart';
import 'package:frontend/views/Mahasiswa/proposal_Mhs.dart';
import 'package:frontend/views/Mahasiswa/riwayat_bimbigan.dart';
import 'package:frontend/views/Notification/notifikasi.dart';
import 'package:frontend/views/Profile/dataDiri_page.dart';
import 'package:frontend/views/Profile/profile_page.dart';
import 'package:frontend/views/Profile/ubah_password.dart';
import 'package:frontend/views/Mahasiswa/TugasAkhir/tugas_akhir_mhs.dart';
import 'package:frontend/views/Mahasiswa/TugasAkhir/form_daftar_sidang_ta.dart';
import 'package:frontend/views/Mahasiswa/dashboard_Mhs.dart';
import 'package:frontend/views/login_page.dart';
import 'package:frontend/views/splash_page.dart';
import 'package:frontend/views/KoorProdi/pendaftar_sidang.dart';
import 'package:get/get.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  // runApp(const MainApp());
  runApp(
  DevicePreview(
    enabled: true,
    builder: (context) => const MainApp(),
  ),
);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
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
        GetPage(name: '/hasilAdm', page: () => const HasilAkhirAdminPage() ),
        GetPage(name: '/pengajuanPembimbingAdm', page: () => const PengajuanPembimbingAdminPage() ),
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
        GetPage(name: '/listMahasiswaDsn', page: () => const ListMahasiswaPage() ),
        GetPage(name: '/jadwalDsn', page: () => JadwalDosenPage() ),
        GetPage(name: '/createJadwalBimbinganDsn', page: () => const CreateJadwalBimbinganPage() ),
        GetPage(name: '/detailTugasAkhirDsn', page: () => DetailTugasAkhirDosenPage() ),
        GetPage(name: '/detailProposalDsn', page: () => DetailProposalDosenPage() ),
        GetPage(name: '/detailPendaftaranBimbinganDsn', page: () => const DetailPendaftaranBimbinganView() ),



        //mahasiswa
        GetPage(name: '/login', page: () => LoginPage() ),
        GetPage(name: '/dashboardMhs', page: () => DashboardMhs() ),
        GetPage(name: '/tugasAkhirMhs', page: () => const TugasAkhirMhsPage() ),
        GetPage(name: '/jadwalSemproMhs', page: () => const JadwalMhsPage() ),
        GetPage(name: '/detail_proposal', page: () => ProposalMhs() ),
        GetPage(name: '/riwayat_bimbingan', page: () => RiwayatBimbingan() ),
        GetPage(name: '/kuota_pembimbing', page: () => KuotaPembimbing() ),
        GetPage(name: '/data_pembimbing', page: () => PembimbingPage() ),
        GetPage(name: '/pendaftaranDosen', page: () => const DaftarDosenPembimbingMhsPage() ),
        GetPage(name: '/formDaftarSidangMhs', page: () => const FormDaftarSidangView() ),

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
        GetPage(name: '/importDataMahasiswaKp', page: () => const kp_import_mhs.ImportDataMahasiswaPage()),
        GetPage(name: '/importJadwalProposalKp', page: () => const ImportJadwalProposalPage() ),
        GetPage(name: '/importJadwalSidangKp', page: () => const ImportJadwalSidangPage() ),
        GetPage(name: '/pendaftaranSidangKp', page: () => const IndexPendaftarSidangPage() ),
        GetPage(name: '/hasilKp', page: () => const HasilAkhirKPPage() ),
        GetPage(name: '/rekapNilaiKp', page: () => const RekapNilaiKPPage() ),


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
