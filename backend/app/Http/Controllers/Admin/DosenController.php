<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Dosen;
use App\Models\User;
use App\Enums\UserRole;
use App\Enums\JabatanDosen;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Enum;

class DosenController extends Controller
{
    public function index()
    {
        $dosen = Dosen::with('user')->get();
        return response()->json(['data' => $dosen]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'nama_dosen' => 'required|string|max:255',
            'nip' => 'nullable|string|unique:dosen,nip',
            'nidn' => 'nullable|string|unique:dosen,nidn',
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
                'nama_dosen' => $request->nama_dosen,
                'nip' => $request->nip,
                'nidn' => $request->nidn,
                'jenis_kelamin' => $request->jenis_kelamin,
                'alamat' => $request->alamat,
            ]);

            DB::commit();

            return response()->json([
                'message' => 'Data Dosen berhasil ditambahkan',
                'data' => $dosen->load('user')
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    public function show($id)
    {
        $dosen = Dosen::with('user')->find($id);
        if (!$dosen) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }
        return response()->json($dosen);
    }

    public function update(Request $request, $id)
    {
        $dosen = Dosen::find($id);
        if (!$dosen) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        $request->validate([
            'nama_dosen' => 'required|string|max:255',
            'nip' => 'nullable|string|unique:dosen,nip,' . $id,
            'nidn' => 'nullable|string|unique:dosen,nidn,' . $id,
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
                'nama_dosen' => $request->nama_dosen,
                'nip' => $request->nip,
                'nidn' => $request->nidn,
                'jenis_kelamin' => $request->jenis_kelamin,
                'alamat' => $request->alamat,
            ]);

            DB::commit();

            return response()->json([
                'message' => 'Data Dosen berhasil diperbarui',
                'data' => $dosen->load('user')
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    public function destroy($id)
    {
        $dosen = Dosen::find($id);
        if (!$dosen) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        try {
            DB::beginTransaction();
            User::where('id', $dosen->id_user)->delete();
            // Dosen will be deleted by cascade if FK is set, or manually if not
            $dosen->delete();
            DB::commit();

            return response()->json(['message' => 'Data Dosen berhasil dihapus']);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }
}
