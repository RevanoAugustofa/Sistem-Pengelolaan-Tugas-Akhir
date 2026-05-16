<?php

namespace App\Http\Controllers\Dosen;

use App\Http\Controllers\Controller;
use App\Models\JadwalSempro;
use App\Models\JadwalSidangTA;
use App\Models\JadwalBimbingan;
use App\Models\DaftarBimbingan;
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
        $prodiIds = $dosen->prodi->pluck('id');

        if ($jenisSidang === 'proposal') {
            $data = JadwalSempro::with(['mahasiswa.proposal', 'pengujiUtama', 'pengujiPendamping', 'ruangan'])
                ->whereHas('mahasiswa', function ($query) use ($prodiIds) {
                    $query->whereIn('id_prodi', $prodiIds);
                })
                ->get();
        } elseif ($jenisSidang === 'bimbingan') {
            $data = JadwalBimbingan::where('id_dosen', $dosen->id)->get();
        } else {
            $data = JadwalSidangTA::with(['mahasiswa.proposal', 'pengujiUtama', 'pengujiPendamping', 'pembimbingUtama', 'pembimbingPendamping', 'ruangan'])
                ->whereHas('mahasiswa', function ($query) use ($prodiIds) {
                    $query->whereIn('id_prodi', $prodiIds);
                })
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

    public function pendaftaran($id)
    {
        $jadwal = JadwalBimbingan::with(['pendaftaran.mahasiswa.user'])->find($id);

        if (!$jadwal) {
            return response()->json(['status' => 'error', 'message' => 'Jadwal not found'], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => $jadwal->pendaftaran
        ]);
    }

    public function updateStatusPendaftaran(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:menunggu,diterima,ditolak,dibatalkan'
        ]);

        $pendaftaran = DaftarBimbingan::find($id);

        if (!$pendaftaran) {
            return response()->json(['status' => 'error', 'message' => 'Pendaftaran not found'], 404);
        }

        $pendaftaran->status = $request->status;
        $pendaftaran->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Status pendaftaran berhasil diperbarui',
            'data' => $pendaftaran
        ]);
    }
}
