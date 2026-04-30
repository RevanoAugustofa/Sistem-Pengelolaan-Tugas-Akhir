<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Prodi;
use Illuminate\Http\Request;

class ProdiController extends Controller
{
    public function index()
    {
        return response()->json(['data' => Prodi::all()]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'kode_prodi' => 'required|string|unique:prodi,kode_prodi',
            'nama_prodi' => 'required|string',
        ]);

        $prodi = Prodi::create($request->all());
        return response()->json(['message' => 'Prodi berhasil ditambahkan', 'data' => $prodi], 201);
    }

    public function show($id)
    {
        $prodi = Prodi::find($id);
        if (!$prodi) return response()->json(['message' => 'Data tidak ditemukan'], 404);
        return response()->json($prodi);
    }

    public function update(Request $request, $id)
    {
        $prodi = Prodi::find($id);
        if (!$prodi) return response()->json(['message' => 'Data tidak ditemukan'], 404);

        $request->validate([
            'kode_prodi' => 'required|string|unique:prodi,kode_prodi,' . $id,
            'nama_prodi' => 'required|string',
        ]);

        $prodi->update($request->all());
        return response()->json(['message' => 'Prodi berhasil diperbarui', 'data' => $prodi]);
    }

    public function destroy($id)
    {
        $prodi = Prodi::find($id);
        if (!$prodi) return response()->json(['message' => 'Data tidak ditemukan'], 404);
        $prodi->delete();
        return response()->json(['message' => 'Prodi berhasil dihapus']);
    }
}
