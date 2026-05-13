<?php

namespace App\Http\Controllers\Mahasiswa;

use App\Http\Controllers\Controller;
use App\Models\Dosen;
use App\Models\PengajuanPembimbing;
use App\Models\Proposal;
use App\Models\JadwalSempro;
use App\Models\JadwalSidangTA;
use App\Models\JadwalBimbingan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class MhsController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $pengajuan = null;
        $proposal = null;
        
        if ($user->mahasiswa) {
            $pengajuan = PengajuanPembimbing::with([
                'pembimbingUtama.user',
                'pembimbingPendamping.user'
            ])->where('id_mahasiswa', $user->mahasiswa->id)->first();
            
            $proposal = $user->mahasiswa->proposal;
        }

        return response()->json([
            'message' => 'Welcome to Mahasiswa Dashboard',
            'role' => 'mahasiswa',
            'pengajuan' => $pengajuan,
            'proposal' => $proposal,
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

    public function jadwalBimbingan()
    {
        $data = JadwalBimbingan::with(['dosen.user'])->get();
        return response()->json(['data' => $data]);
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
