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

    public function getLogbook($id_mahasiswa)
    {
        $logbooks = \App\Models\LogbookBimbingan::with(['daftarBimbingan.jadwalBimbingan'])
            ->where('id_mahasiswa', $id_mahasiswa)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($logbooks);
    }

    public function updateLogbook(Request $request, $id_logbook)
    {
        $validator = \Illuminate\Support\Facades\Validator::make($request->all(), [
            'permasalahan' => 'nullable|string',
            'rekom_pembimbing' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = Auth::user();
        $dosen = $user->dosen;

        $logbook = \App\Models\LogbookBimbingan::findOrFail($id_logbook);
        $pengajuan = \App\Models\PengajuanPembimbing::where('id_mahasiswa', $logbook->id_mahasiswa)
            ->where('status', 'disetujui')
            ->first();

        if (!$pengajuan) {
            return response()->json(['message' => 'Mahasiswa tidak memiliki pembimbing'], 403);
        }

        if ($pengajuan->id_pembimbing_utama == $dosen->id) {
            if ($request->has('permasalahan')) $logbook->permasalahan = $request->permasalahan;
            if ($request->has('rekom_pembimbing')) $logbook->rekom_pembimbing_utama = $request->rekom_pembimbing;
        } elseif ($pengajuan->id_pembimbing_pendamping == $dosen->id) {
            if ($request->has('rekom_pembimbing')) $logbook->rekom_pembimbing_pendamping = $request->rekom_pembimbing;
        } else {
            return response()->json(['message' => 'Anda bukan pembimbing mahasiswa ini'], 403);
        }

        $logbook->save();

        return response()->json(['message' => 'Logbook berhasil diperbarui', 'logbook' => $logbook]);
    }

    public function getJadwalSidang($id_mahasiswa)
    {
        $user = Auth::user();
        $dosen = $user->dosen;

        if (!$dosen) {
            return response()->json(['message' => 'Dosen record not found'], 404);
        }

        $jadwal = \App\Models\JadwalSidangTA::with(['pengujiUtama', 'pengujiPendamping', 'ruangan', 'mahasiswa.proposal', 'mahasiswa.daftarSidangTA'])
            ->where('id_mahasiswa', $id_mahasiswa)
            ->first();

        if (!$jadwal) {
            return response()->json([
                'jadwal' => null,
                'hasil' => null,
                'is_penguji' => false,
                'is_pembimbing' => false,
                'id_dosen_logged_in' => $dosen->id
            ]);
        }

        $hasil = \App\Models\HasilAkhirTA::where('id_jadwal_sidangTA', $jadwal->id)->first();

        // Check role: as pembimbing or as penguji
        $isPenguji = ($jadwal->id_penguji_utama == $dosen->id || $jadwal->id_penguji_pendamping == $dosen->id);
        $isPembimbing = ($jadwal->id_pembimbing_utama == $dosen->id || $jadwal->id_pembimbing_pendamping == $dosen->id);

        return response()->json([
            'jadwal' => $jadwal,
            'hasil' => $hasil,
            'is_penguji' => $isPenguji,
            'is_pembimbing' => $isPembimbing,
            'id_dosen_logged_in' => $dosen->id
        ]);
    }

    public function storeHasilSidang(Request $request)
    {
        $validator = \Illuminate\Support\Facades\Validator::make($request->all(), [
            'id_jadwal_sidangTA' => 'required|exists:jadwal_sidangta,id',
            'nilai' => 'required|numeric|min:0|max:100',
            'catatan' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = Auth::user();
        $dosen = $user->dosen;

        $jadwal = \App\Models\JadwalSidangTA::find($request->id_jadwal_sidangTA);

        $hasil = \App\Models\HasilAkhirTA::firstOrNew(['id_jadwal_sidangTA' => $jadwal->id]);
        $hasil->id_mahasiswa = $jadwal->id_mahasiswa;

        if ($jadwal->id_penguji_utama == $dosen->id) {
            $hasil->nilai_penguji_utama = $request->nilai;
        } elseif ($jadwal->id_penguji_pendamping == $dosen->id) {
            $hasil->nilai_penguji_pendamping = $request->nilai;
        } elseif ($jadwal->id_pembimbing_utama == $dosen->id) {
            $hasil->nilai_pembimbing_utama = $request->nilai;
        } elseif ($jadwal->id_pembimbing_pendamping == $dosen->id) {
            $hasil->nilai_pembimbing_pendamping = $request->nilai;
        } else {
            return response()->json(['message' => 'Anda tidak berhak memberi nilai untuk jadwal ini'], 403);
        }

        // Simpan catatan revisi jika ada (mungkin perlu tabel tambahan atau field di hasil_akhirta)
        // Untuk sekarang simpan nilainya dulu.
        
        $v1 = $hasil->nilai_pembimbing_utama;
        $v2 = $hasil->nilai_pembimbing_pendamping;
        $v3 = $hasil->nilai_penguji_utama;
        $v4 = $hasil->nilai_penguji_pendamping;

        $count = 0;
        $total = 0;
        if ($v1 !== null) { $total += $v1; $count++; }
        if ($v2 !== null) { $total += $v2; $count++; }
        if ($v3 !== null) { $total += $v3; $count++; }
        if ($v4 !== null) { $total += $v4; $count++; }

        if ($count > 0) {
            $hasil->nilai_total = $total / $count;
        }

        $hasil->update_at = now();
        if (!$hasil->exists) {
            $hasil->created_at = now();
        }
        $hasil->save();

        return response()->json(['message' => 'Nilai sidang berhasil disimpan', 'hasil' => $hasil]);
    }
}
