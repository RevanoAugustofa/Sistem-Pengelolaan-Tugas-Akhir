<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\JadwalSempro;
use App\Models\JadwalSidangTA;
use App\Models\JadwalBimbingan;
use Illuminate\Http\Request;

class JadwalController extends Controller
{
    public function getJadwalSempro()
    {
        $jadwal = JadwalSempro::with(['mahasiswa', 'pengujiUtama', 'pengujiPendamping', 'ruangan'])->get();
        return response()->json(['data' => $jadwal]);
    }

    public function getJadwalSidangTA()
    {
        $jadwal = JadwalSidangTA::with(['mahasiswa', 'pembimbingUtama', 'pembimbingPendamping', 'pengujiUtama', 'pengujiPendamping', 'ruangan'])->get();
        return response()->json(['data' => $jadwal]);
    }

    public function getJadwalBimbingan()
    {
        $jadwal = JadwalBimbingan::with(['dosen'])->get();
        return response()->json(['data' => $jadwal]);
    }
}
