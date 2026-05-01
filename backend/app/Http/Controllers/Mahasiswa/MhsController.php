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

    public function dosenList()
    {
        $dosen = Dosen::with('user')->get();
        return response()->json(['data' => $dosen]);
    }

    // Tambahkan fungsi manajemen user di sini nanti
}
