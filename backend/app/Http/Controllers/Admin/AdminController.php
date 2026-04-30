<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function index()
    {
        return response()->json([
            'message' => 'Welcome to Admin Dashboard',
            'role' => 'admin'
        ]);
    }

    // Tambahkan fungsi manajemen user di sini nanti
}
