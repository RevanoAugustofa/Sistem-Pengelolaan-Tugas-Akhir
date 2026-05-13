<?php

namespace App\Http\Controllers\Dosen;

use App\Http\Controllers\Controller;
use App\Models\PengajuanPembimbing;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class MahasiswaController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $dosen = $user->dosen;

        if (!$dosen) {
            return response()->json([
                'message' => 'Dosen record not found for this user.'
            ], 404);
        }

        $mahasiswaBimbingan = PengajuanPembimbing::with(['mahasiswa.prodi', 'mahasiswa.tahunAjar', 'mahasiswa.user'])
            ->where(function ($query) use ($dosen) {
                $query->where('id_pembimbing_utama', $dosen->id)
                    ->orWhere('id_pembimbing_pendamping', $dosen->id);
            })
            ->where('status', 'disetujui')
            ->get()
            ->map(function ($pengajuan) use ($dosen) {
                $mahasiswa = $pengajuan->mahasiswa;
                $mahasiswa->role_pembimbing = $pengajuan->id_pembimbing_utama == $dosen->id ? 'Utama' : 'Pendamping';
                return $mahasiswa;
            });

        return response()->json($mahasiswaBimbingan);
    }
}
