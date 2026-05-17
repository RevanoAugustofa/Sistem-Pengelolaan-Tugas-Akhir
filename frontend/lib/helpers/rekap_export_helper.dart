import 'package:excel/excel.dart' hide Border;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class RekapExportHelper {
  static Future<void> exportToExcel(List<dynamic> dataList) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      // Add Headers
      sheetObject.appendRow([
        TextCellValue('No'),
        TextCellValue('NPM'),
        TextCellValue('Nama Mahasiswa'),
        TextCellValue('Prodi'),
        TextCellValue('Nilai Angka'),
        TextCellValue('Nilai Huruf'),
        TextCellValue('Keterangan'),
      ]);

      // Add Data
      for (int i = 0; i < dataList.length; i++) {
        var item = dataList[i];
        double nilai = double.tryParse(item['hasil_akhir']?['nilai_total']?.toString() ?? '0') ?? 0;
        
        String huruf = '-';
        String keterangan = '-';
        if (item['hasil_akhir'] != null) {
          if (nilai >= 80) { huruf = 'A'; keterangan = 'Sangat Memuaskan'; }
          else if (nilai >= 75) { huruf = 'AB'; keterangan = 'Istimewa'; }
          else if (nilai >= 65) { huruf = 'B'; keterangan = 'Baik'; }
          else if (nilai >= 60) { huruf = 'BC'; keterangan = 'Cukup Baik'; }
          else if (nilai >= 50) { huruf = 'C'; keterangan = 'Cukup'; }
          else if (nilai >= 40) { huruf = 'D'; keterangan = 'Kurang'; }
          else { huruf = 'E'; keterangan = 'Gagal'; }
        }

        sheetObject.appendRow([
          IntCellValue(i + 1),
          TextCellValue(item['nim']?.toString() ?? '-'),
          TextCellValue(item['nama_mahasiswa']?.toString() ?? '-'),
          TextCellValue(item['prodi']?['nama_prodi']?.toString() ?? '-'),
          DoubleCellValue(nilai),
          TextCellValue(huruf),
          TextCellValue(keterangan),
        ]);
      }

      var fileBytes = excel.save();
      if (fileBytes != null) {
        await Printing.sharePdf(bytes: Uint8List.fromList(fileBytes), filename: 'rekap_nilai_ta.xlsx');
      }
    } catch (e) {
      throw Exception("Gagal export excel: $e");
    }
  }

  static Future<void> exportPengajuanPembimbing(List<dynamic> dataList) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      // Add Headers
      sheetObject.appendRow([
        TextCellValue('No'),
        TextCellValue('NPM'),
        TextCellValue('Nama Mahasiswa'),
        TextCellValue('Judul TA'),
        TextCellValue('Pembimbing 1'),
        TextCellValue('Pembimbing 2'),
        TextCellValue('Status'),
      ]);

      // Add Data
      for (int i = 0; i < dataList.length; i++) {
        var item = dataList[i];
        
        String namaMahasiswa = "-";
        String npm = "-";
        String judulTa = "-";
        String p1 = "-";
        String p2 = "-";
        String status = "-";

        if (item is Map<String, dynamic>) {
          namaMahasiswa = item['mahasiswa']?['nama_mahasiswa']?.toString() ?? '-';
          npm = item['mahasiswa']?['nim']?.toString() ?? '-';
          judulTa = item['mahasiswa']?['proposal']?['judul_proposal']?.toString() ?? '-';
          p1 = item['pembimbing_utama']?['nama_dosen']?.toString() ?? '-';
          p2 = item['pembimbing_pendamping']?['nama_dosen']?.toString() ?? '-';
          status = item['status']?.toString() ?? '-';
        } else {
          // Assuming it's the model object
          namaMahasiswa = item.mahasiswa?.namaMahasiswa ?? "-";
          npm = item.mahasiswa?.npm ?? "-";
          judulTa = item.judulTa ?? "-";
          p1 = item.pembimbingUtama?.namaDosen ?? "-";
          p2 = item.pembimbingPendamping?.namaDosen ?? "-";
          status = item.status ?? "-";
        }

        sheetObject.appendRow([
          IntCellValue(i + 1),
          TextCellValue(npm),
          TextCellValue(namaMahasiswa),
          TextCellValue(judulTa),
          TextCellValue(p1),
          TextCellValue(p2),
          TextCellValue(status),
        ]);
      }

      var fileBytes = excel.save();
      if (fileBytes != null) {
        await Printing.sharePdf(bytes: Uint8List.fromList(fileBytes), filename: 'rekap_pengajuan_pembimbing.xlsx');
      }
    } catch (e) {
      throw Exception("Gagal export excel: $e");
    }
  }

  static Future<void> exportJadwalSempro(List<dynamic> dataList) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      // Add Headers
      sheetObject.appendRow([
        TextCellValue('No'),
        TextCellValue('NPM'),
        TextCellValue('Nama Mahasiswa'),
        TextCellValue('Judul Proposal'),
        TextCellValue('Penguji Utama'),
        TextCellValue('Penguji Pendamping'),
      ]);

      // Add Data
      for (int i = 0; i < dataList.length; i++) {
        var item = dataList[i];
        sheetObject.appendRow([
          IntCellValue(i + 1),
          TextCellValue(item.mahasiswa?.npm ?? "-"),
          TextCellValue(item.mahasiswa?.namaMahasiswa ?? "-"),
          TextCellValue(item.mahasiswa?.proposal?.judulProposal ?? "-"),
          TextCellValue(item.pengujiUtama?.namaDosen ?? "-"),
          TextCellValue(item.pengujiPendamping?.namaDosen ?? "-"),
        ]);
      }

      var fileBytes = excel.save();
      if (fileBytes != null) {
        await Printing.sharePdf(bytes: Uint8List.fromList(fileBytes), filename: 'jadwal_sempro.xlsx');
      }
    } catch (e) {
      throw Exception("Gagal export excel: $e");
    }
  }

  static Future<void> exportJadwalSidang(List<dynamic> dataList) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      // Add Headers
      sheetObject.appendRow([
        TextCellValue('No'),
        TextCellValue('NPM'),
        TextCellValue('Nama Mahasiswa'),
        TextCellValue('Judul TA'),
        TextCellValue('Pembimbing Utama'),
        TextCellValue('Pembimbing Pendamping'),
        TextCellValue('Penguji Utama'),
        TextCellValue('Penguji Pendamping'),
      ]);

      // Add Data
      for (int i = 0; i < dataList.length; i++) {
        var item = dataList[i];
        sheetObject.appendRow([
          IntCellValue(i + 1),
          TextCellValue(item.mahasiswa?.npm ?? "-"),
          TextCellValue(item.mahasiswa?.namaMahasiswa ?? "-"),
          TextCellValue(item.mahasiswa?.proposal?.judulProposal ?? "-"),
          TextCellValue(item.pembimbingUtama?.namaDosen ?? "-"),
          TextCellValue(item.pembimbingPendamping?.namaDosen ?? "-"),
          TextCellValue(item.pengujiUtama?.namaDosen ?? "-"),
          TextCellValue(item.pengujiPendamping?.namaDosen ?? "-"),
        ]);
      }

      var fileBytes = excel.save();
      if (fileBytes != null) {
        await Printing.sharePdf(bytes: Uint8List.fromList(fileBytes), filename: 'jadwal_sidang_ta.xlsx');
      }
    } catch (e) {
      throw Exception("Gagal export excel: $e");
    }
  }
}
