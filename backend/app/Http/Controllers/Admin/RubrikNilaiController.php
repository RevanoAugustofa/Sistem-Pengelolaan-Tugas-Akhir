<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\RubrikNilai;
use Illuminate\Http\Request;

class RubrikNilaiController extends Controller
{
    public function index()
    {
        $rubrik = RubrikNilai::with('prodi')->get();
        return response()->json(['data' => $rubrik]);
    }
}
