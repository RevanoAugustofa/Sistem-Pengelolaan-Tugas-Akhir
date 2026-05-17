<?php

namespace App\Http\Controllers\KoorProdi;

use App\Http\Controllers\Controller;
use App\Models\Mahasiswa;
use App\Models\User;
use App\Enums\UserRole;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class MahasiswaController extends Controller
{
    private function getProdiId(Request $request)
    {
        $user = $request->user();
        if (!$user->dosen) {
            return null;
        }
        return $user->dosen->prodi()->first()?->id;
    }

    public function index(Request $request)
    {
        $idProdi = $this->getProdiId($request);
        if (!$idProdi) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $mahasiswa = Mahasiswa::with([
            'user', 
            'prodi', 
            'tahunAjar', 
            'proposal', 
            'pengajuanPembimbing.pembimbingUtama', 
            'pengajuanPembimbing.pembimbingPendamping'
        ])
            ->where('id_prodi', $idProdi)
            ->get();
        return response()->json(['data' => $mahasiswa]);
    }

    public function store(Request $request)
    {
        $idProdi = $this->getProdiId($request);
        if (!$idProdi) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'nama_mahasiswa' => 'required|string|max:255',
            'nim' => 'required|string|unique:mahasiswa,nim',
            'tgl_lahir' => 'required|string',
            'jenis_kelamin' => 'required|string',
            'alamat' => 'required|string',
            'id_tahun_ajar' => 'required|exists:tahun_ajar,id',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6',
        ]);

        try {
            DB::beginTransaction();

            $user = User::create([
                'name' => $request->nama_mahasiswa,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'role' => UserRole::MAHASISWA,
            ]);

            $mahasiswa = Mahasiswa::create([
                'id_user' => $user->id,
                'id_prodi' => $idProdi, // Automatically set to KoorProdi's prodi
                'id_tahun_ajar' => $request->id_tahun_ajar,
                'nim' => $request->nim,
                'nama_mahasiswa' => $request->nama_mahasiswa,
                'tgl_lahir' => $request->tgl_lahir,
                'jenis_kelamin' => $request->jenis_kelamin,
                'alamat' => $request->alamat,
            ]);

            DB::commit();

            return response()->json([
                'message' => 'Data Mahasiswa berhasil ditambahkan',
                'data' => $mahasiswa->load(['user', 'prodi', 'tahunAjar'])
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    public function show(Request $request, $id)
    {
        $idProdi = $this->getProdiId($request);
        $mahasiswa = Mahasiswa::with(['user', 'prodi', 'tahunAjar', 'proposal'])
            ->where('id_prodi', $idProdi)
            ->find($id);

        if (!$mahasiswa) {
            return response()->json(['message' => 'Data tidak ditemukan atau akses dilarang'], 404);
        }
        return response()->json($mahasiswa);
    }

    public function update(Request $request, $id)
    {
        $idProdi = $this->getProdiId($request);
        $mahasiswa = Mahasiswa::where('id_prodi', $idProdi)->find($id);
        
        if (!$mahasiswa) {
            return response()->json(['message' => 'Data tidak ditemukan atau akses dilarang'], 404);
        }

        $request->validate([
            'nama_mahasiswa' => 'required|string|max:255',
            'nim' => 'required|string|unique:mahasiswa,nim,' . $id,
            'tgl_lahir' => 'required|string',
            'jenis_kelamin' => 'required|string',
            'alamat' => 'required|string',
            'id_tahun_ajar' => 'required|exists:tahun_ajar,id',
            'email' => 'required|email|unique:users,email,' . $mahasiswa->id_user,
            'password' => 'nullable|min:6',
        ]);

        try {
            DB::beginTransaction();

            $user = User::find($mahasiswa->id_user);
            $user->update([
                'name' => $request->nama_mahasiswa,
                'email' => $request->email,
            ]);

            if ($request->password) {
                $user->update(['password' => Hash::make($request->password)]);
            }

            $mahasiswa->update([
                'id_tahun_ajar' => $request->id_tahun_ajar,
                'nim' => $request->nim,
                'nama_mahasiswa' => $request->nama_mahasiswa,
                'tgl_lahir' => $request->tgl_lahir,
                'jenis_kelamin' => $request->jenis_kelamin,
                'alamat' => $request->alamat,
            ]);

            DB::commit();

            return response()->json([
                'message' => 'Data Mahasiswa berhasil diperbarui',
                'data' => $mahasiswa->load(['user', 'prodi', 'tahunAjar', 'proposal'])
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    public function destroy(Request $request, $id)
    {
        $idProdi = $this->getProdiId($request);
        $mahasiswa = Mahasiswa::where('id_prodi', $idProdi)->find($id);
        
        if (!$mahasiswa) {
            return response()->json(['message' => 'Data tidak ditemukan atau akses dilarang'], 404);
        }

        try {
            DB::beginTransaction();
            User::where('id', $mahasiswa->id_user)->delete();
            $mahasiswa->delete();
            DB::commit();

            return response()->json(['message' => 'Data Mahasiswa berhasil dihapus']);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }
}
