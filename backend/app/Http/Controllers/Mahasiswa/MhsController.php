<?php

namespace App\Http\Controllers\Mahasiswa;

use App\Http\Controllers\Controller;
use App\Models\Dosen;
use Illuminate\Http\Request;

class MhsController extends Controller
{
    public function index()
    {
        return response()->json([
            'message' => 'Welcome to Mahasiswa Dashboard',
            'role' => 'mahasiswa'
        ]);
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

    // Tambahkan fungsi manajemen user di sini nanti
}
