<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Enums\UserRole;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Enum;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    /**
     * Menampilkan daftar semua user.
     */
    public function index()
    {
        $users = User::all();
        return response()->json([
            'status' => 'success',
            'data' => $users
        ]);
    }

    /**
     * Menambahkan user baru.
     */
    public function store(Request $request)
    {
        // 1. Validasi input
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'nullable|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|',
            'role' => ['required', new Enum(UserRole::class)],
        ]);

        // 2. Buat user baru
        $user = User::create([
            'name' => $validatedData['name'],
            'email' => $validatedData['email'] ?? null,
            'password' => Hash::make($validatedData['password']),
            'role' => $validatedData['role'],
        ]);

        // 3. Berikan respon sukses
        return response()->json([
            'message' => 'User berhasil ditambahkan',
            'user' => $user
        ], 201);
    }

    /**
     * Memperbarui data user.
     */
    public function update(Request $request, $id)
    {
        $user = User::findOrFail($id);

        // 1. Validasi input
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'email' => [
                'nullable',
                'string',
                'email',
                'max:255',
                Rule::unique('users')->ignore($user->id),
            ],
            'password' => 'nullable|string|min:8|confirmed',
            'role' => ['required', new Enum(UserRole::class)],
        ]);

        // 2. Update data dasar
        $user->name = $validatedData['name'];
        $user->email = $validatedData['email'];
        $user->role = $validatedData['role'];

        // 3. Update password jika diberikan
        if (!empty($validatedData['password'])) {
            $user->password = Hash::make($validatedData['password']);
        }

        $user->save();

        return response()->json([
            'message' => 'User berhasil diperbarui',
            'user' => $user
        ]);
    }
}
