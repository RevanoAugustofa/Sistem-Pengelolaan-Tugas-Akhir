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
            'jabatan' => 'nullable|in:koorprodi,admin',
        ]);

        $dosen = Dosen::findOrFail($request->id_dosen);
        
        $dosen->prodi()->syncWithoutDetaching([
            $request->id_prodi => ['jabatan' => $request->jabatan]
        ]);

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
            'prodis' => 'required|array',
            'prodis.*.id' => 'required|exists:prodi,id',
            'prodis.*.jabatan' => 'nullable|in:koorprodi,admin',
        ]);

        $dosen = Dosen::findOrFail($id);
        
        $syncData = [];
        foreach ($request->prodis as $item) {
            $syncData[$item['id']] = ['jabatan' => $item['jabatan'] ?? null];
        }

        $dosen->prodi()->sync($syncData);

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
