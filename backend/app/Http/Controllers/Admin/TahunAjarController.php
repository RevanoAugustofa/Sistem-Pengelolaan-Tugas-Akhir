<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\TahunAjar;
use Illuminate\Http\Request;

class TahunAjarController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(['data' => TahunAjar::all()]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'tahun_ajar' => 'required|string|max:255',
        ]);

        $tahunAjar = TahunAjar::create([
            'tahun_ajar' => $request->tahun_ajar,
        ]);

        return response()->json([
            'message' => 'Tahun Ajar berhasil ditambahkan',
            'data' => $tahunAjar
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $tahunAjar = TahunAjar::find($id);
        
        if (!$tahunAjar) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        return response()->json($tahunAjar);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $tahunAjar = TahunAjar::find($id);

        if (!$tahunAjar) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        $request->validate([
            'tahun_ajar' => 'required|string|max:255',
        ]);

        $tahunAjar->update([
            'tahun_ajar' => $request->tahun_ajar,
        ]);

        return response()->json([
            'message' => 'Tahun Ajar berhasil diperbarui',
            'data' => $tahunAjar
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $tahunAjar = TahunAjar::find($id);

        if (!$tahunAjar) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        $tahunAjar->delete();

        return response()->json(['message' => 'Tahun Ajar berhasil dihapus']);
    }
}
