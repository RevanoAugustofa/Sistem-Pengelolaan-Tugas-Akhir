<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        // 1. Validasi input dari Flutter
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        // 2. Cari user berdasarkan email
        $user = User::with(['dosen.prodi', 'mahasiswa.prodi'])->where('email', $request->email)->first();

        // 3. Cek apakah user ada dan passwordnya bener
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'Email atau Password salah!'
            ], 401);
        }

        // 4. Buat Token Sanctum
        $token = $user->createToken('auth_token')->plainTextToken;

        $contextsCount = count($user->available_contexts);
        $message = "Login Berhasil!";
        if ($contextsCount > 1) {
            $message = "Login Berhasil, silakan pilih role/prodi anda.";
        } else if ($contextsCount === 1) {
            $role = $user->available_contexts[0]['role'];
            $prodi = $user->available_contexts[0]['prodi_name'];
            $message = "Login Berhasil sebagai $role di $prodi";
        }

        // 5. Kirim balasan ke Flutter
        return response()->json([
            'message' => $message,
            'token' => $token,
            'user' => $user
        ]);
    }

    public function logout(Request $request)
    {
        // Hapus token yang sedang digunakan
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Berhasil Logout']);
    }

    public function profile(Request $request)
    {
        $user = $request->user()->load(['dosen.prodi', 'mahasiswa.prodi']);
        return response()->json([
            'user' => $user
        ]);
    }

    public function updateProfile(Request $request)
    {
        $user = $request->user();
        
        $request->validate([
            'email' => 'required|email|unique:users,email,' . $user->id,
            'ttd' => 'nullable|image|mimes:png,jpg,jpeg|max:2048',
        ]);

        try {
            \DB::beginTransaction();

            // Update Email di tabel User
            $user->update([
                'email' => $request->email
            ]);

            // Update TTD di tabel Dosen atau Mahasiswa
            if ($user->role === 'dosen' || $user->role === 'koorprodi' || $user->role === 'admin') {
                $dosen = $user->dosen;
                if ($dosen) {
                    if ($request->hasFile('ttd')) {
                        $path = $request->file('ttd')->store('signatures', 'public');
                        $dosen->update(['ttd_dosen' => $path]);
                    }
                }
            } else if ($user->role === 'mahasiswa') {
                $mahasiswa = $user->mahasiswa;
                if ($mahasiswa) {
                    if ($request->hasFile('ttd')) {
                        $path = $request->file('ttd')->store('signatures', 'public');
                        $mahasiswa->update(['ttd_mahasiswa' => $path]);
                    }
                }
            }

            \DB::commit();

            return response()->json([
                'message' => 'Profil berhasil diperbarui',
                'user' => $user->fresh(['dosen.prodi', 'mahasiswa.prodi'])
            ]);

        } catch (\Exception $e) {
            \DB::rollBack();
            return response()->json(['message' => 'Gagal memperbarui profil: ' . $e->getMessage()], 500);
        }
    }

    public function updatePassword(Request $request)
    {
        $request->validate([
            'new_password' => 'required|min:8|confirmed',
        ]);

        $user = $request->user();

        $user->update([
            'password' => Hash::make($request->new_password)
        ]);

        return response()->json([
            'message' => 'Kata sandi berhasil diperbarui.'
        ]);
    }

    public function updateFcmToken(Request $request)
    {
        $request->validate([
            'fcm_token' => 'required|string',
        ]);

        $user = $request->user();
        $user->update([
            'fcm_token' => $request->fcm_token
        ]);

        return response()->json([
            'message' => 'FCM Token berhasil diperbarui'
        ]);
    }
}
