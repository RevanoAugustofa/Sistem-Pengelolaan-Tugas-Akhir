<?php

namespace App\Http\Controllers\KoorProdi;

use App\Http\Controllers\Controller;
use App\Models\JadwalSempro;
use App\Models\JadwalSidangTA;
use App\Models\JadwalBimbingan;
use Illuminate\Http\Request;

class JadwalController extends Controller
{
    public function index(Request $request)
    {
        $jenisSidang = $request->query('jenis_sidang');

        if ($jenisSidang === 'proposal') {
            $data = JadwalSempro::with(['mahasiswa.proposal', 'pengujiUtama', 'pengujiPendamping', 'ruangan'])->get();
        } elseif ($jenisSidang === 'bimbingan') {
            $data = JadwalBimbingan::with(['dosen'])->get();
        } else {
            $data = JadwalSidangTA::with(['mahasiswa.proposal', 'pengujiUtama', 'pengujiPendamping', 'pembimbingUtama', 'pembimbingPendamping', 'ruangan'])->get();
        }

        return response()->json([
            'status' => 'success',
            'data' => $data
        ]);
    }

    public function store(Request $request)
    {
        $jenisSidang = $request->input('jenis_sidang');

        if ($jenisSidang === 'proposal') {
            $jadwal = JadwalSempro::create($request->all());
        } elseif ($jenisSidang === 'bimbingan') {
            $jadwal = JadwalBimbingan::create($request->all());
        } else {
            $jadwal = JadwalSidangTA::create($request->all());
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Jadwal berhasil ditambahkan',
            'data' => $jadwal
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $jenisSidang = $request->input('jenis_sidang');

        if ($jenisSidang === 'proposal') {
            $jadwal = JadwalSempro::findOrFail($id);
        } elseif ($jenisSidang === 'bimbingan') {
            $jadwal = JadwalBimbingan::findOrFail($id);
        } elseif (in_array($jenisSidang, ['sidang', 'sidang_reguler', 'ulang'])) {
            $jadwal = JadwalSidangTA::findOrFail($id);
        } else {
            // Fallback attempt to find in both if type is unclear
            $jadwal = JadwalSempro::find($id);
            if (!$jadwal) {
                $jadwal = JadwalSidangTA::find($id);
            }
            
            if (!$jadwal) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Jadwal tidak ditemukan atau jenis tidak valid'
                ], 404);
            }
        }

        $jadwal->update($request->all());

        return response()->json([
            'status' => 'success',
            'message' => 'Jadwal berhasil diperbarui',
            'data' => $jadwal
        ]);
    }
}
