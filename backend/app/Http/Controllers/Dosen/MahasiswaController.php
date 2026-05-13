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

    public function getJadwalSempro($id_mahasiswa)
    {
        $user = Auth::user();
        $dosen = $user->dosen;

        if (!$dosen) {
            return response()->json(['message' => 'Dosen record not found'], 404);
        }

        $jadwal = \App\Models\JadwalSempro::with(['pengujiUtama', 'pengujiPendamping', 'ruangan', 'mahasiswa.proposal'])
            ->where('id_mahasiswa', $id_mahasiswa)
            ->first();

        if (!$jadwal) {
            return response()->json(['message' => 'Jadwal sempro tidak ditemukan'], 404);
        }

        $hasil = \App\Models\HasilSempro::where('id_jadwal_sempro', $jadwal->id)->first();

        $isPenguji = ($jadwal->id_penguji_utama == $dosen->id || $jadwal->id_penguji_pendamping == $dosen->id);

        return response()->json([
            'jadwal' => $jadwal,
            'hasil' => $hasil,
            'is_penguji' => $isPenguji,
            'id_dosen_logged_in' => $dosen->id
        ]);
    }

    public function storeHasilSempro(Request $request)
    {
        $validator = \Illuminate\Support\Facades\Validator::make($request->all(), [
            'id_jadwal_sempro' => 'required|exists:jadwal_sempro,id',
            'id_proposal' => 'required|exists:proposal,id',
            'nilai' => 'required|numeric|min:0|max:100',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = Auth::user();
        $dosen = $user->dosen;

        $jadwal = \App\Models\JadwalSempro::find($request->id_jadwal_sempro);

        $hasil = \App\Models\HasilSempro::firstOrNew(['id_jadwal_sempro' => $jadwal->id]);
        $hasil->id_proposal = $request->id_proposal;

        if ($jadwal->id_penguji_utama == $dosen->id) {
            $hasil->nilai_penguji_utama = $request->nilai;
        } elseif ($jadwal->id_penguji_pendamping == $dosen->id) {
            $hasil->nilai_penguji_pendamping = $request->nilai;
        } else {
            return response()->json(['message' => 'Anda bukan penguji untuk jadwal ini'], 403);
        }

        $v1 = $hasil->nilai_penguji_utama;
        $v2 = $hasil->nilai_penguji_pendamping;
        
        if ($v1 !== null && $v2 !== null) {
            $hasil->nilai_total = ($v1 + $v2) / 2;
        } else {
            $hasil->nilai_total = $v1 ?? $v2;
        }

        // Status enum: ['lulus', 'revisi', 'ditolak']
        if ($hasil->nilai_total >= 75) {
            $hasil->status = 'lulus';
        } elseif ($hasil->nilai_total >= 60) {
            $hasil->status = 'revisi';
        } else {
            $hasil->status = 'ditolak';
        }

        $hasil->update_at = now();
        if (!$hasil->exists) {
            $hasil->created_at = now();
        }
        
        $hasil->save();

        return response()->json(['message' => 'Nilai berhasil disimpan', 'hasil' => $hasil]);
    }
}
