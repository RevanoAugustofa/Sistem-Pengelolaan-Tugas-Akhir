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
use App\Http\Controllers\KoorProdi\KoorProdiController;
use App\Http\Controllers\KoorProdi\JadwalController;

Route::post('/login',[AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);
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

    // Rubrik Nilai for Admin
    Route::get('/admin/rubrik-nilai', [\App\Http\Controllers\Admin\RubrikNilaiController::class, 'index']);

    // Proposal for Admin
    Route::get('/admin/proposal', [\App\Http\Controllers\Admin\ProposalController::class, 'index']);

    // Pengajuan Pembimbing for Admin
    Route::get('/admin/pengajuan-pembimbing', [\App\Http\Controllers\Admin\PengajuanPembimbingController::class, 'index']);

    // Jadwal for Admin
    Route::get('/admin/jadwal-sempro', [\App\Http\Controllers\Admin\JadwalController::class, 'getJadwalSempro']);
    Route::get('/admin/jadwal-sidangta', [\App\Http\Controllers\Admin\JadwalController::class, 'getJadwalSidangTA']);
    Route::get('/admin/jadwal-bimbingan', [\App\Http\Controllers\Admin\JadwalController::class, 'getJadwalBimbingan']);

    // Hasil Akhir for Admin
    Route::get('/admin/hasil-sempro', [\App\Http\Controllers\Admin\HasilAkhirController::class, 'getHasilSempro']);
    Route::get('/admin/hasil-sidang', [\App\Http\Controllers\Admin\HasilAkhirController::class, 'getHasilSidang']);
    Route::get('/admin/pendaftaran-sidang', [\App\Http\Controllers\Admin\HasilAkhirController::class, 'getPendaftaranSidang']);
});


Route::middleware('auth:sanctum', 'role:koorprodi')->group(function () {
    Route::get('/koorprodi/pengajuan-pembimbing', [KoorProdiController::class, 'index']);
    Route::get('/koorprodi/dosen', [KoorProdiController::class, 'dosenList']);
    Route::post('/koorprodi/pengajuan-pembimbing/{id}/update-supervisor', [KoorProdiController::class, 'updateSupervisor']);
    Route::post('/koorprodi/pengajuan-pembimbing/{id}/validasi', [KoorProdiController::class, 'validatePengajuan']);

    // Tahun Ajar for KoorProdi
    Route::get('/koorprodi/tahun-ajar', [TahunAjarController::class, 'index']);

    // Prodi for KoorProdi
    Route::get('/koorprodi/prodi', [ProdiController::class, 'index']);

    // Ruangan for KoorProdi
    Route::get('/koorprodi/ruangan', [RuanganController::class, 'index']);
    Route::post('/koorprodi/ruangan', [RuanganController::class, 'store']);
    Route::get('/koorprodi/ruangan/{id}', [RuanganController::class, 'show']);
    Route::put('/koorprodi/ruangan/{id}', [RuanganController::class, 'update']);
    Route::delete('/koorprodi/ruangan/{id}', [RuanganController::class, 'destroy']);

    // Mahasiswa CRUD for KoorProdi
    Route::get('/koorprodi/mahasiswa', [\App\Http\Controllers\KoorProdi\MahasiswaController::class, 'index']);
    Route::post('/koorprodi/mahasiswa', [\App\Http\Controllers\KoorProdi\MahasiswaController::class, 'store']);
    Route::get('/koorprodi/mahasiswa/{id}', [\App\Http\Controllers\KoorProdi\MahasiswaController::class, 'show']);
    Route::put('/koorprodi/mahasiswa/{id}', [\App\Http\Controllers\KoorProdi\MahasiswaController::class, 'update']);
    Route::delete('/koorprodi/mahasiswa/{id}', [\App\Http\Controllers\KoorProdi\MahasiswaController::class, 'destroy']);

    // Dosen CRUD for KoorProdi
    Route::get('/koorprodi/dosen-manajemen', [\App\Http\Controllers\KoorProdi\DosenController::class, 'index']);
    Route::post('/koorprodi/dosen-manajemen', [\App\Http\Controllers\KoorProdi\DosenController::class, 'store']);
    Route::get('/koorprodi/dosen-manajemen/{id}', [\App\Http\Controllers\KoorProdi\DosenController::class, 'show']);
    Route::put('/koorprodi/dosen-manajemen/{id}', [\App\Http\Controllers\KoorProdi\DosenController::class, 'update']);
    Route::delete('/koorprodi/dosen-manajemen/{id}', [\App\Http\Controllers\KoorProdi\DosenController::class, 'destroy']);

    // Rubrik Nilai CRUD for KoorProdi
    Route::get('/koorprodi/rubrik-nilai', [\App\Http\Controllers\KoorProdi\RubrikNilaiController::class, 'index']);
    Route::post('/koorprodi/rubrik-nilai', [\App\Http\Controllers\KoorProdi\RubrikNilaiController::class, 'store']);
    Route::get('/koorprodi/rubrik-nilai/{id}', [\App\Http\Controllers\KoorProdi\RubrikNilaiController::class, 'show']);
    Route::put('/koorprodi/rubrik-nilai/{id}', [\App\Http\Controllers\KoorProdi\RubrikNilaiController::class, 'update']);
    Route::delete('/koorprodi/rubrik-nilai/{id}', [\App\Http\Controllers\KoorProdi\RubrikNilaiController::class, 'destroy']);

    // Jadwal for KoorProdi
    Route::get('/koorprodi/jadwal', [JadwalController::class, 'index']);
    Route::post('/koorprodi/jadwal', [JadwalController::class, 'store']);

    // Rekap for KoorProdi
    Route::get('/koorprodi/rekap', [KoorProdiController::class, 'rekap']);

    // Daftar Sidang for KoorProdi
    Route::get('/koorprodi/daftar-sidang', [KoorProdiController::class, 'daftarSidang']);
});


Route::middleware('auth:sanctum', 'role:dosen')->group(function () {
    Route::get('/dosen/jadwal', [\App\Http\Controllers\Dosen\JadwalController::class, 'index']);
    Route::post('/dosen/jadwal', [\App\Http\Controllers\Dosen\JadwalController::class, 'store']);
    Route::get('/dosen/mahasiswa', [\App\Http\Controllers\Dosen\MahasiswaController::class, 'index']);
    Route::get('/dosen/mahasiswa/{id}/jadwal-sempro', [\App\Http\Controllers\Dosen\MahasiswaController::class, 'getJadwalSempro']);
    Route::post('/dosen/hasil-sempro', [\App\Http\Controllers\Dosen\MahasiswaController::class, 'storeHasilSempro']);
});


Route::middleware('auth:sanctum', 'role:mahasiswa')->group(function () {
    Route::get('/mahasiswa/dashboard', [MhsController::class, 'index']);
    Route::get('/mahasiswa/dosen', [MhsController::class, 'dosenList']);
    Route::post('/mahasiswa/daftar-pembimbing', [MhsController::class, 'storeDaftarPembimbing']);
    Route::get('/mahasiswa/jadwal-sempro', [MhsController::class, 'jadwalSempro']);
    Route::get('/mahasiswa/jadwal-sidang', [MhsController::class, 'jadwalSidang']);
    Route::get('/mahasiswa/jadwal-bimbingan', [MhsController::class, 'jadwalBimbingan']);
});
