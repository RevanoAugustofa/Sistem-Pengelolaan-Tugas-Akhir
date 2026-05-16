<?php

namespace App\Http\Controllers\Mahasiswa;

use App\Http\Controllers\Controller;
use App\Models\Dosen;
use App\Models\PengajuanPembimbing;
use App\Models\Proposal;
use App\Models\JadwalSempro;
use App\Models\HasilSempro;
use App\Models\CatatanRevisiSempro;
use App\Models\JadwalSidangTA;
use App\Models\JadwalBimbingan;
use App\Models\DaftarBimbingan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class MhsController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user()->load('mahasiswa.tahunAjar');
        $pengajuan = null;
        $proposal = null;
        $revisi = [];
        $hasilSempro = null;
        
        if ($user->mahasiswa) {
            $pengajuan = PengajuanPembimbing::with([
                'pembimbingUtama.user',
                'pembimbingPendamping.user'
            ])->where('id_mahasiswa', $user->mahasiswa->id)->first();
            
            $proposal = $user->mahasiswa->proposal;

            // Get Revision Notes
            $jadwalSempro = JadwalSempro::where('id_mahasiswa', $user->mahasiswa->id)->first();
            if ($jadwalSempro) {
                $revisi = CatatanRevisiSempro::with('dosen.user')
                    ->where('id_jadwal_sempro', $jadwalSempro->id)
                    ->get();

                // Get Sempro Result
                $hasilSempro = HasilSempro::where('id_jadwal_sempro', $jadwalSempro->id)->first();
            }
        }

        return response()->json([
            'message' => 'Welcome to Mahasiswa Dashboard',
            'role' => 'mahasiswa',
            'user' => $user,
            'pengajuan' => $pengajuan,
            'proposal' => $proposal,
            'revisi' => $revisi,
            'hasil_sempro' => $hasilSempro,
        ]);
    }

    public function jadwalSempro()
    {
        $data = JadwalSempro::with(['mahasiswa.proposal', 'ruangan', 'pengujiUtama.user', 'pengujiPendamping.user'])->get();
        return response()->json(['data' => $data]);
    }

    public function jadwalSidang()
    {
        $data = JadwalSidangTA::with(['mahasiswa.proposal', 'ruangan', 'pengujiUtama.user', 'pengujiPendamping.user'])->get();
        return response()->json(['data' => $data]);
    }

    public function jadwalBimbingan(Request $request)
    {
        $user = $request->user();
        $idMahasiswa = $user->mahasiswa ? $user->mahasiswa->id : null;

        $data = JadwalBimbingan::with(['dosen.user', 'pendaftaran' => function($query) use ($idMahasiswa) {
            $query->where('id_mahasiswa', $idMahasiswa);
        }])->get();

        return response()->json(['data' => $data]);
    }

    public function storeDaftarBimbingan(Request $request)
    {
        $request->validate([
            'id_jadwal_bimbingan' => 'required|exists:jadwal_bimbingan,id',
        ]);

        $user = $request->user();
        if (!$user->mahasiswa) {
            return response()->json(['message' => 'Data mahasiswa tidak ditemukan'], 404);
        }

        $idMahasiswa = $user->mahasiswa->id;

        // Check if already registered
        $existing = DaftarBimbingan::where('id_mahasiswa', $idMahasiswa)
            ->where('id_jadwal_bimbingan', $request->id_jadwal_bimbingan)
            ->first();

        if ($existing) {
            return response()->json([
                'success' => false,
                'message' => 'Anda sudah mendaftar untuk jadwal ini',
            ], 400);
        }

        // Check quota
        $jadwal = JadwalBimbingan::find($request->id_jadwal_bimbingan);
        if ($jadwal->kuota <= 0) {
            return response()->json([
                'success' => false,
                'message' => 'Kuota bimbingan sudah penuh',
            ], 400);
        }

        try {
            DB::beginTransaction();

            // Create registration
            DaftarBimbingan::create([
                'id_mahasiswa' => $idMahasiswa,
                'id_jadwal_bimbingan' => $request->id_jadwal_bimbingan,
                'status' => 'menunggu',
            ]);

            // Decrease quota
            $jadwal->decrement('kuota');

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Pendaftaran bimbingan berhasil',
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    public function logbook(Request $request)
    {
        $user = $request->user();
        if (!$user->mahasiswa) {
            return response()->json(['message' => 'Data mahasiswa tidak ditemukan'], 404);
        }

        $logbooks = \App\Models\LogbookBimbingan::with(['daftarBimbingan.jadwalBimbingan'])
            ->where('id_mahasiswa', $user->mahasiswa->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json(['data' => $logbooks]);
    }

    public function storeLogbook(Request $request)
    {
        $request->validate([
            'id_daftar_bimbingan' => 'required|exists:daftar_bimbingan,id',
            'permasalahan' => 'nullable|string',
            'file_bimbingan' => 'nullable|file|mimes:pdf|max:2048',
        ]);

        $user = $request->user();
        if (!$user->mahasiswa) {
            return response()->json(['message' => 'Data mahasiswa tidak ditemukan'], 404);
        }

        try {
            $filePath = null;
            if ($request->hasFile('file_bimbingan')) {
                $file = $request->file('file_bimbingan');
                $fileName = time() . '_' . $file->getClientOriginalName();
                $filePath = $file->storeAs('logbooks', $fileName, 'public');
            }

            $logbook = \App\Models\LogbookBimbingan::create([
                'id_mahasiswa' => $user->mahasiswa->id,
                'id_daftar_bimbingan' => $request->id_daftar_bimbingan,
                'permasalahan' => $request->permasalahan,
                'file_bimbingan' => $filePath,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Logbook berhasil ditambahkan',
                'data' => $logbook
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan logbook: ' . $e->getMessage()
            ], 500);
        }
    }

    public function dosenList(Request $request)
    {
        $user = $request->user();
        
        if ($user->isMahasiswa() && $user->mahasiswa) {
            $idProdi = $user->mahasiswa->id_prodi;
            
            // Ambil dosen yang memiliki relasi ke prodi yang sama
            $dosen = Dosen::whereHas('prodi', function ($query) use ($idProdi) {
                $query->where('prodi.id', $idProdi);
            })->with('user')->get();
            
            return response()->json(['data' => $dosen]);
        }

        // Fallback jika bukan mahasiswa atau tidak ada data mahasiswa
        $dosen = Dosen::with('user')->get();
        return response()->json(['data' => $dosen]);
    }

    public function storeDaftarPembimbing(Request $request)
    {
        $request->validate([
            'judul' => 'required|string|max:255',
            'pembimbing1_id' => 'required|exists:dosen,id',
            'pembimbing2_id' => 'required|exists:dosen,id|different:pembimbing1_id',
        ]);

        $user = $request->user();
        if (!$user->mahasiswa) {
            return response()->json(['message' => 'Data mahasiswa tidak ditemukan'], 404);
        }

        $idMahasiswa = $user->mahasiswa->id;

        try {
            DB::beginTransaction();

            // 1. Simpan Judul ke tabel proposal
            Proposal::updateOrCreate(
                ['id_mahasiswa' => $idMahasiswa],
                ['judul_proposal' => $request->judul]
            );

            // 2. Simpan Pengajuan Pembimbing
            PengajuanPembimbing::updateOrCreate(
                ['id_mahasiswa' => $idMahasiswa],
                [
                    'id_pembimbing_utama' => $request->pembimbing1_id,
                    'id_pembimbing_pendamping' => $request->pembimbing2_id,
                    'status' => 'diajukan',
                ]
            );

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Pendaftaran pembimbing berhasil diajukan',
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    public function storeProposal(Request $request)
    {
        $request->validate([
            'judul_proposal' => 'required|string|max:255',
            'file_proposal' => 'required|file|mimes:pdf,doc,docx|max:2048',
        ]);

        $user = $request->user();
        if (!$user->mahasiswa) {
            return response()->json(['message' => 'Data mahasiswa tidak ditemukan'], 404);
        }

        try {
            $file = $request->file('file_proposal');
            $fileName = time() . '_' . $file->getClientOriginalName();
            $filePath = $file->storeAs('proposals', $fileName, 'public');

            $proposal = Proposal::updateOrCreate(
                ['id_mahasiswa' => $user->mahasiswa->id],
                [
                    'judul_proposal' => $request->judul_proposal,
                    'file_proposal' => $filePath,
                ]
            );

            return response()->json([
                'success' => true,
                'message' => 'Proposal berhasil diunggah',
                'data' => $proposal
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengunggah proposal: ' . $e->getMessage()
            ], 500);
        }
    }

    // Tambahkan fungsi manajemen user di sini nanti
}
