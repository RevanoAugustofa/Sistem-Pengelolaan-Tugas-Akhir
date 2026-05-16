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
}
