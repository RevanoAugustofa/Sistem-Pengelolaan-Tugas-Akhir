<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Ruangan;
use Illuminate\Http\Request;

class RuanganController extends Controller
{
    public function index()
    {
        return response()->json(['data' => Ruangan::all()]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'nama_ruangan' => 'required|string',
            'gedung' => 'required|string',
        ]);

        $ruangan = Ruangan::create($request->all());
        return response()->json(['message' => 'Ruangan berhasil ditambahkan', 'data' => $ruangan], 201);
    }

    public function show($id)
    {
        $ruangan = Ruangan::find($id);
        if (!$ruangan) return response()->json(['message' => 'Data tidak ditemukan'], 404);
        return response()->json($ruangan);
    }

    public function update(Request $request, $id)
    {
        $ruangan = Ruangan::find($id);
        if (!$ruangan) return response()->json(['message' => 'Data tidak ditemukan'], 404);

        $request->validate([
            'nama_ruangan' => 'required|string',
            'gedung' => 'required|string',
        ]);

        $ruangan->update($request->all());
        return response()->json(['message' => 'Ruangan berhasil diperbarui', 'data' => $ruangan]);
    }

    public function destroy($id)
    {
        $ruangan = Ruangan::find($id);
        if (!$ruangan) return response()->json(['message' => 'Data tidak ditemukan'], 404);
        $ruangan->delete();
        return response()->json(['message' => 'Ruangan berhasil dihapus']);
    }
}
