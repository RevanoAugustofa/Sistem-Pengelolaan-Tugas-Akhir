<?php

namespace App\Http\Controllers\Mahasiswa;

use App\Http\Controllers\Controller;
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

    // Tambahkan fungsi manajemen user di sini nanti
}
