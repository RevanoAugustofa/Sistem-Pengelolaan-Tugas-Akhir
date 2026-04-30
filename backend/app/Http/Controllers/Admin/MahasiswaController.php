<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Mahasiswa;
use App\Models\User;
use App\Enums\UserRole;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class MahasiswaController extends Controller
{
    public function index()
    {
        $mahasiswa = Mahasiswa::with(['user', 'prodi', 'tahunAjar'])->get();
        return response()->json(['data' => $mahasiswa]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'nama_mahasiswa' => 'required|string|max:255',
            'nim' => 'required|string|unique:mahasiswa,nim',
            'id_prodi' => 'required|exists:prodi,id',
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
                'id_prodi' => $request->id_prodi,
                'id_tahun_ajar' => $request->id_tahun_ajar,
                'nim' => $request->nim,
                'nama_mahasiswa' => $request->nama_mahasiswa,
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

    public function show($id)
    {
        $mahasiswa = Mahasiswa::with(['user', 'prodi', 'tahunAjar'])->find($id);
        if (!$mahasiswa) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }
        return response()->json($mahasiswa);
    }

    public function update(Request $request, $id)
    {
        $mahasiswa = Mahasiswa::find($id);
        if (!$mahasiswa) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        $request->validate([
            'nama_mahasiswa' => 'required|string|max:255',
            'nim' => 'required|string|unique:mahasiswa,nim,' . $id,
            'id_prodi' => 'required|exists:prodi,id',
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
                'id_prodi' => $request->id_prodi,
                'id_tahun_ajar' => $request->id_tahun_ajar,
                'nim' => $request->nim,
                'nama_mahasiswa' => $request->nama_mahasiswa,
            ]);

            DB::commit();

            return response()->json([
                'message' => 'Data Mahasiswa berhasil diperbarui',
                'data' => $mahasiswa->load(['user', 'prodi', 'tahunAjar'])
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    public function destroy($id)
    {
        $mahasiswa = Mahasiswa::find($id);
        if (!$mahasiswa) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
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
