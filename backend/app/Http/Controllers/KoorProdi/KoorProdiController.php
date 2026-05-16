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

        $idProdi = $user->dosen->prodi()->first()?->id;

        $query = PengajuanPembimbing::with(['mahasiswa.prodi', 'mahasiswa.proposal', 'pembimbingUtama', 'pembimbingPendamping']);

        if ($idProdi) {
            $query->whereHas('mahasiswa', function ($q) use ($idProdi) {
                $q->where('id_prodi', $idProdi);
            });
        }

        // Search Filter (Optional, but good for performance if done in backend)
        if ($request->has('search')) {
            $search = $request->query('search');
            $query->whereHas('mahasiswa', function($q) use ($search) {
                $q->where('nama_mahasiswa', 'like', "%$search%")
                  ->orWhere('nim', 'like', "%$search%");
            });
        }

        // Advanced Filters from backend
        if ($request->has('status')) {
            $query->whereIn('status', explode(',', $request->query('status')));
        }
        
        if ($request->has('tahun_ajar')) {
            $years = explode(',', $request->query('tahun_ajar'));
            $query->whereHas('mahasiswa', function($q) use ($years) {
                $q->whereIn('id_tahun_ajar', function($sub) use ($years) {
                    $sub->select('id')->from('tahun_ajar')->whereIn('tahun_ajar', $years);
                });
            });
        }

        $perPage = $request->query('per_page', 10);
        $data = $query->orderBy('created_at', 'desc')->paginate($perPage);

        return response()->json($data);
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

    public function rekap(Request $request)
    {
        $user = $request->user();
        if (!$user->dosen) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $idProdi = $user->dosen->prodi()->first()?->id;

        $query = \App\Models\Mahasiswa::with([
            'prodi',
            'tahunAjar',
            'pengajuanPembimbing.pembimbingUtama',
            'pengajuanPembimbing.pembimbingPendamping',
            'jadwalSempro.pengujiUtama',
            'jadwalSempro.pengujiPendamping',
            'jadwalSidang.pengujiUtama',
            'jadwalSidang.pengujiPendamping'
        ]);

        if ($idProdi) {
            $query->where('id_prodi', $idProdi);
        }

        if ($request->has('search')) {
            $search = $request->query('search');
            $query->where(function($q) use ($search) {
                $q->where('nama_mahasiswa', 'like', "%$search%")
                  ->orWhere('nim', 'like', "%$search%");
            });
        }

        $data = $query->get();
        return response()->json(['data' => $data]);
    }

    public function daftarSidang(Request $request)
    {
        $user = $request->user();
        if (!$user->dosen) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $idProdi = $user->dosen->prodi()->first()?->id;

        $query = \App\Models\DaftarSidangTA::with(['mahasiswa.prodi', 'mahasiswa.tahunAjar']);

        if ($idProdi) {
            $query->whereHas('mahasiswa', function ($q) use ($idProdi) {
                $q->where('id_prodi', $idProdi);
            });
        }

        $data = $query->orderBy('created_at', 'desc')->get();

        return response()->json(['data' => $data]);
    }

    public function getHasilSempro(Request $request)
    {
        $user = $request->user();
        $idProdi = $user->dosen->prodi()->first()?->id;

        $query = \App\Models\HasilSempro::with(['proposal.mahasiswa.prodi']);

        if ($idProdi) {
            $query->whereHas('proposal.mahasiswa', function ($q) use ($idProdi) {
                $q->where('id_prodi', $idProdi);
            });
        }

        $hasil = $query->get();
        
        $data = $hasil->map(function ($item) {
            return [
                'id' => $item->id,
                'mahasiswa' => [
                    'nama' => $item->proposal->mahasiswa->nama_mahasiswa ?? '-',
                    'npm' => $item->proposal->mahasiswa->nim ?? '-',
                ],
                'prodi' => $item->proposal->mahasiswa->prodi->nama_prodi ?? '-',
                'nilai_penguji_utama' => $item->nilai_penguji_utama,
                'nilai_penguji_pendamping' => $item->nilai_penguji_pendamping,
                'nilai_akhir' => $item->nilai_total,
                'status' => ucfirst($item->status),
            ];
        });

        return response()->json(['data' => $data]);
    }

    public function getHasilSidang(Request $request)
    {
        $user = $request->user();
        $idProdi = $user->dosen->prodi()->first()?->id;

        $query = \App\Models\HasilAkhirTA::with(['mahasiswa.prodi']);

        if ($idProdi) {
            $query->whereHas('mahasiswa', function ($q) use ($idProdi) {
                $q->where('id_prodi', $idProdi);
            });
        }

        $hasil = $query->get();

        $data = $hasil->map(function ($item) {
            return [
                'id' => $item->id,
                'mahasiswa' => [
                    'nama' => $item->mahasiswa->nama_mahasiswa ?? '-',
                    'npm' => $item->mahasiswa->nim ?? '-',
                ],
                'prodi' => $item->mahasiswa->prodi->nama_prodi ?? '-',
                'nilai_pembimbing_utama' => $item->nilai_pembimbing_utama,
                'nilai_pembimbing_pendamping' => $item->nilai_pembimbing_pendamping,
                'nilai_penguji_utama' => $item->nilai_penguji_utama,
                'nilai_penguji_pendamping' => $item->nilai_penguji_pendamping,
                'nilai_akhir' => $item->nilai_total,
                'status' => $item->nilai_total >= 60 ? 'Lulus' : 'Tidak Lulus',
            ];
        });

        return response()->json(['data' => $data]);
    }
}
