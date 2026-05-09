<?php

namespace App\Http\Controllers\Dosen;

use App\Http\Controllers\Controller;
use App\Models\JadwalSempro;
use App\Models\JadwalSidangTA;
use App\Models\JadwalBimbingan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class JadwalController extends Controller
{
    public function index(Request $request)
    {
        $user = Auth::user();
        $dosen = $user->dosen;

        if (!$dosen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Dosen profile not found'
            ], 404);
        }

        $jenisSidang = $request->query('jenis_sidang');

        if ($jenisSidang === 'proposal') {
            $data = JadwalSempro::with(['mahasiswa.proposal', 'pengujiUtama', 'pengujiPendamping', 'ruangan'])
                ->where('id_penguji_utama', $dosen->id)
                ->orWhere('id_penguji_pendamping', $dosen->id)
                ->get();
        } elseif ($jenisSidang === 'bimbingan') {
            $data = JadwalBimbingan::where('id_dosen', $dosen->id)->get();
        } else {
            $data = JadwalSidangTA::with(['mahasiswa.proposal', 'pengujiUtama', 'pengujiPendamping', 'ruangan'])
                ->where('id_penguji_utama', $dosen->id)
                ->orWhere('id_penguji_pendamping', $dosen->id)
                ->orWhere('id_pembimbing_utama', $dosen->id)
                ->orWhere('id_pembimbing_pendamping', $dosen->id)
                ->get();
        }

        return response()->json([
            'status' => 'success',
            'data' => $data
        ]);
    }

    public function store(Request $request)
    {
        $user = Auth::user();
        $dosen = $user->dosen;

        if (!$dosen) {
            return response()->json(['status' => 'error', 'message' => 'Dosen profile not found'], 404);
        }

        $data = $request->all();
        $data['id_dosen'] = $dosen->id;

        $jadwal = JadwalBimbingan::create($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Jadwal bimbingan berhasil ditambahkan',
            'data' => $jadwal
        ], 201);
    }
}
