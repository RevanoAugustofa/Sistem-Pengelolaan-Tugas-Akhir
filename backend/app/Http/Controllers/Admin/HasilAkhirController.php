<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\HasilSempro;
use App\Models\HasilAkhirTA;
use Illuminate\Http\Request;

class HasilAkhirController extends Controller
{
    public function getHasilSempro()
    {
        $hasil = HasilSempro::with(['proposal.mahasiswa.prodi'])->get();
        
        $data = $hasil->map(function ($item) {
            return [
                'id' => $item->id,
                'mahasiswa' => [
                    'nama' => $item->proposal->mahasiswa->nama_mahasiswa ?? '-',
                    'npm' => $item->proposal->mahasiswa->nim ?? '-',
                ],
                'prodi' => $item->proposal->mahasiswa->prodi->nama_prodi ?? '-',
                'nilai_penguji_utama' => $item->nilai_penguji_utama,
                'nilai_penguji_pendamping' => $item->nilai_penguji_pendamping,
                'nilai_akhir' => $item->nilai_total,
                'status' => ucfirst($item->status),
            ];
        });

        return response()->json(['data' => $data]);
    }

    public function getHasilSidang()
    {
        $hasil = HasilAkhirTA::with(['mahasiswa.prodi'])->get();

        $data = $hasil->map(function ($item) {
            return [
                'id' => $item->id,
                'mahasiswa' => [
                    'nama' => $item->mahasiswa->nama_mahasiswa ?? '-',
                    'npm' => $item->mahasiswa->nim ?? '-',
                ],
                'prodi' => $item->mahasiswa->prodi->nama_prodi ?? '-',
                'nilai_pembimbing_utama' => $item->nilai_pembimbing_utama,
                'nilai_pembimbing_pendamping' => $item->nilai_pembimbing_pendamping,
                'nilai_penguji_utama' => $item->nilai_penguji_utama,
                'nilai_penguji_pendamping' => $item->nilai_penguji_pendamping,
                'nilai_akhir' => $item->nilai_total,
                'status' => $item->nilai_total >= 60 ? 'Lulus' : 'Tidak Lulus', // Example logic
            ];
        });

        return response()->json(['data' => $data]);
    }
}
