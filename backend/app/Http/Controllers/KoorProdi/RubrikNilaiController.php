<?php

namespace App\Http\Controllers\KoorProdi;

use App\Http\Controllers\Controller;
use App\Models\RubrikNilai;
use Illuminate\Http\Request;

class RubrikNilaiController extends Controller
{
    private function getProdiId(Request $request)
    {
        $user = $request->user();
        if (!$user->dosen) {
            return null;
        }
        return $user->dosen->prodi()->first()?->id;
    }

    public function index(Request $request)
    {
        $idProdi = $this->getProdiId($request);
        if (!$idProdi) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $rubrik = RubrikNilai::where('id_prodi', $idProdi)->get();
        return response()->json(['data' => $rubrik]);
    }

    public function store(Request $request)
    {
        $idProdi = $this->getProdiId($request);
        if (!$idProdi) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'jenis_dosen' => 'required|in:pembimbing,penguji',
            'kelompok' => 'required|string',
            'kategori' => 'required|string',
            'presentse' => 'required|integer|min:0|max:100',
        ]);

        $rubrik = RubrikNilai::create([
            'id_prodi' => $idProdi,
            'jenis_dosen' => $request->jenis_dosen,
            'kelompok' => $request->kelompok,
            'kategori' => $request->kategori,
            'presentse' => $request->presentse,
        ]);

        return response()->json([
            'message' => 'Rubrik Nilai berhasil ditambahkan',
            'data' => $rubrik
        ], 201);
    }

    public function show(Request $request, $id)
    {
        $idProdi = $this->getProdiId($request);
        $rubrik = RubrikNilai::where('id_prodi', $idProdi)->find($id);

        if (!$rubrik) {
            return response()->json(['message' => 'Data tidak ditemukan atau akses dilarang'], 404);
        }
        return response()->json($rubrik);
    }

    public function update(Request $request, $id)
    {
        $idProdi = $this->getProdiId($request);
        $rubrik = RubrikNilai::where('id_prodi', $idProdi)->find($id);

        if (!$rubrik) {
            return response()->json(['message' => 'Data tidak ditemukan atau akses dilarang'], 404);
        }

        $request->validate([
            'jenis_dosen' => 'required|in:pembimbing,penguji',
            'kelompok' => 'required|string',
            'kategori' => 'required|string',
            'presentse' => 'required|integer|min:0|max:100',
        ]);

        $rubrik->update([
            'jenis_dosen' => $request->jenis_dosen,
            'kelompok' => $request->kelompok,
            'kategori' => $request->kategori,
            'presentse' => $request->presentse,
        ]);

        return response()->json([
            'message' => 'Rubrik Nilai berhasil diperbarui',
            'data' => $rubrik
        ]);
    }

    public function destroy(Request $request, $id)
    {
        $idProdi = $this->getProdiId($request);
        $rubrik = RubrikNilai::where('id_prodi', $idProdi)->find($id);

        if (!$rubrik) {
            return response()->json(['message' => 'Data tidak ditemukan atau akses dilarang'], 404);
        }

        $rubrik->delete();
        return response()->json(['message' => 'Rubrik Nilai berhasil dihapus']);
    }
}
