<?php

namespace App\Http\Controllers\KoorProdi;

use App\Http\Controllers\Controller;
use App\Models\Dosen;
use App\Models\User;
use App\Enums\UserRole;
use App\Enums\JabatanDosen;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DosenController extends Controller
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

        $dosen = Dosen::with(['user', 'prodi'])
            ->whereHas('prodi', function($q) use ($idProdi) {
                $q->where('prodi.id', $idProdi);
            })
            ->get();
            
        return response()->json(['data' => $dosen]);
    }

    public function store(Request $request)
    {
        $idProdi = $this->getProdiId($request);
        if (!$idProdi) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'nama_dosen' => 'required|string|max:255',
            'nip' => 'required|string|unique:dosen,nip',
            'nidn' => 'required|string|unique:dosen,nidn',
            'jenis_kelamin' => 'required|string',
            'alamat' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6',
        ]);

        try {
            DB::beginTransaction();

            $user = User::create([
                'name' => $request->nama_dosen,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'role' => UserRole::DOSEN,
            ]);

            $dosen = Dosen::create([
                'id_user' => $user->id,
                'nip' => $request->nip,
                'nidn' => $request->nidn,
                'nama_dosen' => $request->nama_dosen,
                'jenis_kelamin' => $request->jenis_kelamin,
                'alamat' => $request->alamat,
            ]);

            // Attach to KoorProdi's prodi
            $dosen->prodi()->attach($idProdi);

            DB::commit();

            return response()->json([
                'message' => 'Data Dosen berhasil ditambahkan',
                'data' => $dosen->load(['user', 'prodi'])
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    public function show(Request $request, $id)
    {
        $idProdi = $this->getProdiId($request);
        $dosen = Dosen::with(['user', 'prodi'])
            ->whereHas('prodi', function($q) use ($idProdi) {
                $q->where('prodi.id', $idProdi);
            })
            ->find($id);

        if (!$dosen) {
            return response()->json(['message' => 'Data tidak ditemukan atau akses dilarang'], 404);
        }
        return response()->json($dosen);
    }

    public function update(Request $request, $id)
    {
        $idProdi = $this->getProdiId($request);
        $dosen = Dosen::whereHas('prodi', function($q) use ($idProdi) {
            $q->where('prodi.id', $idProdi);
        })->find($id);
        
        if (!$dosen) {
            return response()->json(['message' => 'Data tidak ditemukan atau akses dilarang'], 404);
        }

        $request->validate([
            'nama_dosen' => 'required|string|max:255',
            'nip' => 'required|string|unique:dosen,nip,' . $id,
            'nidn' => 'required|string|unique:dosen,nidn,' . $id,
            'jenis_kelamin' => 'required|string',
            'alamat' => 'required|string',
            'email' => 'required|email|unique:users,email,' . $dosen->id_user,
            'password' => 'nullable|min:6',
        ]);

        try {
            DB::beginTransaction();

            $user = User::find($dosen->id_user);
            $user->update([
                'name' => $request->nama_dosen,
                'email' => $request->email,
            ]);

            if ($request->password) {
                $user->update(['password' => Hash::make($request->password)]);
            }

            $dosen->update([
                'nip' => $request->nip,
                'nidn' => $request->nidn,
                'nama_dosen' => $request->nama_dosen,
                'jenis_kelamin' => $request->jenis_kelamin,
                'alamat' => $request->alamat,
            ]);

            DB::commit();

            return response()->json([
                'message' => 'Data Dosen berhasil diperbarui',
                'data' => $dosen->load(['user', 'prodi'])
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    public function destroy(Request $request, $id)
    {
        $idProdi = $this->getProdiId($request);
        $dosen = Dosen::whereHas('prodi', function($q) use ($idProdi) {
            $q->where('prodi.id', $idProdi);
        })->find($id);
        
        if (!$dosen) {
            return response()->json(['message' => 'Data tidak ditemukan atau akses dilarang'], 404);
        }

        try {
            DB::beginTransaction();
            User::where('id', $dosen->id_user)->delete();
            $dosen->prodi()->detach();
            $dosen->delete();
            DB::commit();

            return response()->json(['message' => 'Data Dosen berhasil dihapus']);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }
}
