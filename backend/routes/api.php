<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Enums\UserRole;
use App\Http\Controllers\Mahasiswa\MhsController;
use App\Http\Controllers\Admin\UserController;
use App\Http\Controllers\Admin\TahunAjarController;
use App\Http\Controllers\Admin\DosenController;
use App\Http\Controllers\Admin\MahasiswaController;
use App\Http\Controllers\Admin\ProdiController;
use App\Http\Controllers\Admin\RuanganController;
use App\Http\Controllers\Admin\DosenProdiController;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');

Route::post('/login',[AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/update-password', [AuthController::class, 'updatePassword']);
    Route::post('/logout', [AuthController::class, 'logout']);
});

Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    Route::get('/admin/users', [UserController::class, 'index']);
    Route::post('/admin/users', [UserController::class, 'store']);
    Route::put('/admin/users/{id}', [UserController::class, 'update']);

    // Tahun Ajar CRUD
    Route::get('/admin/tahun-ajar', [TahunAjarController::class, 'index']);
    Route::post('/admin/tahun-ajar', [TahunAjarController::class, 'store']);
    Route::get('/admin/tahun-ajar/{id}', [TahunAjarController::class, 'show']);
    Route::put('/admin/tahun-ajar/{id}', [TahunAjarController::class, 'update']);
    Route::delete('/admin/tahun-ajar/{id}', [TahunAjarController::class, 'destroy']);

    // Prodi CRUD
    Route::get('/admin/prodi', [ProdiController::class, 'index']);
    Route::post('/admin/prodi', [ProdiController::class, 'store']);
    Route::get('/admin/prodi/{id}', [ProdiController::class, 'show']);
    Route::put('/admin/prodi/{id}', [ProdiController::class, 'update']);
    Route::delete('/admin/prodi/{id}', [ProdiController::class, 'destroy']);

    // Dosen CRUD
    Route::get('/admin/dosen', [DosenController::class, 'index']);
    Route::post('/admin/dosen', [DosenController::class, 'store']);
    Route::get('/admin/dosen/{id}', [DosenController::class, 'show']);
    Route::put('/admin/dosen/{id}', [DosenController::class, 'update']);
    Route::delete('/admin/dosen/{id}', [DosenController::class, 'destroy']);

    // Mahasiswa CRUD
    Route::get('/admin/mahasiswa', [MahasiswaController::class, 'index']);
    Route::post('/admin/mahasiswa', [MahasiswaController::class, 'store']);
    Route::get('/admin/mahasiswa/{id}', [MahasiswaController::class, 'show']);
    Route::put('/admin/mahasiswa/{id}', [MahasiswaController::class, 'update']);
    Route::delete('/admin/mahasiswa/{id}', [MahasiswaController::class, 'destroy']);

    // Ruangan CRUD
    Route::get('/admin/ruangan', [RuanganController::class, 'index']);
    Route::post('/admin/ruangan', [RuanganController::class, 'store']);
    Route::get('/admin/ruangan/{id}', [RuanganController::class, 'show']);
    Route::put('/admin/ruangan/{id}', [RuanganController::class, 'update']);
    Route::delete('/admin/ruangan/{id}', [RuanganController::class, 'destroy']);

    // Dosen Prodi Relasi CRUD
    Route::get('/admin/dosen-prodi', [DosenProdiController::class, 'index']);
    Route::post('/admin/dosen-prodi', [DosenProdiController::class, 'store']);
    Route::get('/admin/dosen-prodi/{id}', [DosenProdiController::class, 'show']);
    Route::put('/admin/dosen-prodi/{id}', [DosenProdiController::class, 'update']);
    Route::delete('/admin/dosen-prodi/{dosen_id}/{prodi_id}', [DosenProdiController::class, 'destroy']);
});


Route::middleware('auth:sanctum', 'role:mahasiswa')->group(function () {
    Route::get('/mahasiswa/dashboard', [MhsController::class, 'index']);
    Route::get('/mahasiswa/dosen', [MhsController::class, 'dosenList']);
});



