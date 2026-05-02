<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Dosen;
use App\Models\Prodi;
use Illuminate\Http\Request;

class DosenProdiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $dosen = Dosen::with('prodi')->get();
        return response()->json(['data' => $dosen]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'id_dosen' => 'required|exists:dosen,id',
            'id_prodi' => 'required|exists:prodi,id',
        ]);

        $dosen = Dosen::findOrFail($request->id_dosen);
        
        // Use syncWithoutDetaching to avoid duplicates
        $dosen->prodi()->syncWithoutDetaching([$request->id_prodi]);

        return response()->json([
            'message' => 'Relasi Dosen & Prodi berhasil ditambahkan',
            'data' => $dosen->load('prodi')
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $dosen = Dosen::with('prodi')->findOrFail($id);
        return response()->json(['data' => $dosen]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $request->validate([
            'prodi_ids' => 'required|array',
            'prodi_ids.*' => 'exists:prodi,id',
        ]);

        $dosen = Dosen::findOrFail($id);
        $dosen->prodi()->sync($request->prodi_ids);

        return response()->json([
            'message' => 'Relasi Dosen & Prodi berhasil diperbarui',
            'data' => $dosen->load('prodi')
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($dosen_id, $prodi_id)
    {
        $dosen = Dosen::findOrFail($dosen_id);
        $dosen->prodi()->detach($prodi_id);

        return response()->json([
            'message' => 'Relasi Dosen & Prodi berhasil dihapus'
        ]);
    }
}
