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
            $data = JadwalSidangTA::with(['mahasiswa.proposal', 'pengujiUtama', 'pengujiPendamping', 'ruangan'])->get();
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
}
