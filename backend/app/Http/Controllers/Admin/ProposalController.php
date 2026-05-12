<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Proposal;
use Illuminate\Http\Request;

class ProposalController extends Controller
{
    public function index()
    {
        $proposal = Proposal::with(['mahasiswa.prodi'])->get();
        return response()->json(['data' => $proposal]);
    }
}
