<?php

namespace App\Http\Controllers\KoorProdi;

use App\Http\Controllers\Controller;
use App\Models\PengajuanPembimbing;
use Illuminate\Http\Request;

class KoorProdiController extends Controller
{
    /**
     * Display a listing of supervisor applications for the KoorProdi's department.
     */
    public function index(Request $request)
    {
        $user = $request->user();
        
        // Ensure user is a Dosen and has a prodi (KoorProdi is a Dosen)
        if (!$user->dosen) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // KoorProdi usually manages lecturers in their own prodi.
        // For now, let's fetch all applications and we can filter by prodi if needed.
        // Assuming we want to show applications from students in the same prodi as the KoorProdi.
        
        $idProdi = $user->dosen->prodi()->first()?->id;

        $query = PengajuanPembimbing::with(['mahasiswa.prodi', 'pembimbingUtama', 'pembimbingPendamping']);

        if ($idProdi) {
            $query->whereHas('mahasiswa', function ($q) use ($idProdi) {
                $q->where('id_prodi', $idProdi);
            });
        }

        $data = $query->orderBy('created_at', 'desc')->get();

        return response()->json(['data' => $data]);
    }

    /**
     * Validate (approve/reject) a supervisor application.
     */
    public function validatePengajuan(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:diterima,ditolak',
        ]);

        $pengajuan = PengajuanPembimbing::findOrFail($id);
        $pengajuan->update([
            'status' => $request->status
        ]);

        return response()->json([
            'message' => 'Validasi berhasil diperbarui',
            'data' => $pengajuan->load(['mahasiswa', 'pembimbingUtama', 'pembimbingPendamping'])
        ]);
    }
}
