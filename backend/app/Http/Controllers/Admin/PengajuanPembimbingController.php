<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PengajuanPembimbing;
use Illuminate\Http\Request;

class PengajuanPembimbingController extends Controller
{
    public function index()
    {
        $pengajuan = PengajuanPembimbing::with(['mahasiswa.prodi', 'mahasiswa.proposal', 'pembimbingUtama', 'pembimbingPendamping'])->get();
        return response()->json(['data' => $pengajuan]);
    }
}
