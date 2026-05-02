<?php

namespace App\Http\Controllers\KoorProdi;

use App\Http\Controllers\Controller;
use App\Models\PengajuanPembimbing;
use App\Models\Dosen;
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

        $query = PengajuanPembimbing::with(['mahasiswa.prodi', 'mahasiswa.proposal', 'pembimbingUtama', 'pembimbingPendamping']);

        if ($idProdi) {
            $query->whereHas('mahasiswa', function ($q) use ($idProdi) {
                $q->where('id_prodi', $idProdi);
            });
        }

        $data = $query->orderBy('created_at', 'desc')->get();

        return response()->json(['data' => $data]);
    }

    /**
     * List all lecturers in the KoorProdi's department.
     */
    public function dosenList(Request $request)
    {
        $user = $request->user();
        if (!$user->dosen) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $idProdi = $user->dosen->prodi()->first()?->id;

        $query = Dosen::query();
        if ($idProdi) {
            $query->whereHas('prodi', function ($q) use ($idProdi) {
                $q->where('prodi.id', $idProdi);
            });
        }

        $data = $query->get();
        return response()->json(['data' => $data]);
    }

    /**
     * Update supervisors for an application.
     */
    public function updateSupervisor(Request $request, $id)
    {
        $request->validate([
            'id_pembimbing_utama' => 'required|exists:dosen,id',
            'id_pembimbing_pendamping' => 'required|exists:dosen,id|different:id_pembimbing_utama',
        ]);

        $pengajuan = PengajuanPembimbing::findOrFail($id);
        $pengajuan->update([
            'id_pembimbing_utama' => $request->id_pembimbing_utama,
            'id_pembimbing_pendamping' => $request->id_pembimbing_pendamping,
            'status' => 'diajukan' // Reset to diajukan if reassigned
        ]);

        return response()->json([
            'message' => 'Dosen pembimbing berhasil diperbarui',
            'data' => $pengajuan->load(['mahasiswa.proposal', 'pembimbingUtama', 'pembimbingPendamping'])
        ]);
    }

    public function validatePengajuan(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:disetujui,diajukan',
        ]);

        $pengajuan = PengajuanPembimbing::findOrFail($id);
        $pengajuan->update([
            'status' => $request->status
        ]);

        return response()->json([
            'message' => 'Validasi berhasil diperbarui',
            'data' => $pengajuan->load(['mahasiswa.proposal', 'pembimbingUtama', 'pembimbingPendamping'])
        ]);
    }
}
